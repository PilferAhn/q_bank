"""
seed.py — databricks/ml/pro 문제 파싱 후 DB 삽입
"""
import re
import os
import psycopg2
import psycopg2.extras

# ── DB 연결 ──────────────────────────────────────────────────
def get_conn():
    try:
        from dotenv import load_dotenv
        load_dotenv(os.path.join(os.path.dirname(__file__), "frontend", ".env"))
    except ImportError:
        pass
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=os.getenv("DB_PORT", "5432"),
        dbname=os.getenv("DB_NAME", "q_bank"),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASSWORD", "postgres"),
    )

LETTER_TO_NUM = {"A": 1, "B": 2, "C": 3, "D": 4, "E": 5}

# ── 파서: questions.md ────────────────────────────────────────
def parse_questions(path: str) -> list[dict]:
    text = open(path, encoding="utf-8").read()
    blocks = re.split(r"\n---\n", text)
    results = []

    for block in blocks:
        m = re.search(r"## Question (\d+)\n", block)
        if not m:
            continue
        number = int(m.group(1))
        after_header = block[m.end():]

        # 선택지 시작 전까지가 body
        # 선택지는 "- A." 로 시작하는 줄
        opt_start = re.search(r"^- A\.", after_header, re.MULTILINE)
        if not opt_start:
            continue
        body = after_header[:opt_start.start()].strip()

        options_text = after_header[opt_start.start():]
        options = parse_options(options_text)

        results.append({"number": number, "body": body, "options": options})

    results.sort(key=lambda x: x["number"])
    return results


def parse_options(text: str) -> dict:
    """- A. ... - B. ... 형태를 {1: "...", 2: "...", ...} 로 파싱"""
    # 각 선택지 시작 위치를 찾음
    pattern = re.compile(r"^- ([A-E])\.", re.MULTILINE)
    matches = list(pattern.finditer(text))
    options = {}

    for i, m in enumerate(matches):
        letter = m.group(1)
        start = m.end()
        end = matches[i + 1].start() if i + 1 < len(matches) else len(text)
        body = text[start:end].strip()
        options[LETTER_TO_NUM[letter]] = body

    return options


# ── 파서: answers.md ─────────────────────────────────────────
def parse_answers(path: str) -> list[dict]:
    text = open(path, encoding="utf-8").read()
    blocks = re.split(r"\n---\n", text)
    results = []

    for block in blocks:
        m = re.search(r"## Question (\d+)\n", block)
        if not m:
            continue
        number = int(m.group(1))

        correct_m = re.search(r"\*\*Answer:\s*([A-E])\*\*", block)
        if not correct_m:
            continue
        correct = LETTER_TO_NUM[correct_m.group(1)]

        quote_m = re.search(r"^>\s*(.+)$", block, re.MULTILINE)
        quote = quote_m.group(1).strip() if quote_m else None

        exp_m = re.search(r"\*\*Explanation:\*\*\n([\s\S]+)", block)
        explanation = exp_m.group(1).strip() if exp_m else None

        results.append({
            "number": number,
            "correct": correct,
            "quote": quote,
            "explanation": explanation,
        })

    results.sort(key=lambda x: x["number"])
    return results


# ── DB 삽입 ──────────────────────────────────────────────────
def seed():
    base = os.path.join(os.path.dirname(__file__), "question", "databricks", "ml", "pro")
    questions = parse_questions(os.path.join(base, "questions.md"))
    answers   = parse_answers(os.path.join(base, "answers.md"))
    ans_map   = {a["number"]: a for a in answers}

    conn = get_conn()
    cur  = conn.cursor()

    # 스키마 재생성
    with open(os.path.join(os.path.dirname(__file__), "schema.sql"), encoding="utf-8") as f:
        cur.execute(f.read())

    # vendor
    cur.execute("""
        INSERT INTO vendors (name, slug) VALUES (%s, %s)
        ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name
        RETURNING id
    """, ("Databricks", "databricks"))
    vendor_id = cur.fetchone()[0]

    # exam
    cur.execute("""
        INSERT INTO exams (vendor_id, name, slug) VALUES (%s, %s, %s)
        ON CONFLICT (vendor_id, slug) DO UPDATE SET name = EXCLUDED.name
        RETURNING id
    """, (vendor_id, "Machine Learning", "ml"))
    exam_id = cur.fetchone()[0]

    # exam_level
    cur.execute("""
        INSERT INTO exam_levels (exam_id, level, slug) VALUES (%s, %s, %s)
        ON CONFLICT (exam_id, slug) DO UPDATE SET level = EXCLUDED.level
        RETURNING id
    """, (exam_id, "Professional", "pro"))
    level_id = cur.fetchone()[0]

    # exam_set
    cur.execute("""
        INSERT INTO exam_sets (exam_level_id, set_number) VALUES (%s, %s)
        ON CONFLICT (exam_level_id, set_number) DO NOTHING
        RETURNING id
    """, (level_id, 1))
    row = cur.fetchone()
    if row is None:
        cur.execute("SELECT id FROM exam_sets WHERE exam_level_id = %s AND set_number = %s", (level_id, 1))
        row = cur.fetchone()
    set_id = row[0]

    # questions + options + answers
    for q in questions:
        cur.execute("""
            INSERT INTO questions (exam_set_id, number, body)
            VALUES (%s, %s, %s)
            ON CONFLICT (exam_set_id, number) DO UPDATE SET body = EXCLUDED.body
            RETURNING id
        """, (set_id, q["number"], q["body"]))
        q_id = cur.fetchone()[0]

        for opt_num, opt_body in q["options"].items():
            cur.execute("""
                INSERT INTO question_options (question_id, option_number, body)
                VALUES (%s, %s, %s)
                ON CONFLICT (question_id, option_number) DO UPDATE SET body = EXCLUDED.body
            """, (q_id, opt_num, opt_body))

        ans = ans_map.get(q["number"])
        if ans:
            cur.execute("""
                INSERT INTO answers (question_id, correct, quote, explanation)
                VALUES (%s, %s, %s, %s)
                ON CONFLICT (question_id) DO UPDATE
                    SET correct = EXCLUDED.correct,
                        quote = EXCLUDED.quote,
                        explanation = EXCLUDED.explanation
            """, (q_id, ans["correct"], ans["quote"], ans["explanation"]))

    conn.commit()
    cur.close()
    conn.close()
    print(f"Done: {len(questions)} questions inserted.")


if __name__ == "__main__":
    seed()
