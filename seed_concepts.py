"""
seed_concepts.py - notes/ 폴더 파싱 후 domains, concepts, question_concepts 삽입
"""
import os
import re
import psycopg2

BASE_NOTES = os.path.join(os.path.dirname(__file__), "question", "databricks", "ml", "pro", "notes")


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


def slugify(path: str) -> str:
    return path.replace("/", "__").replace("\\", "__")


def get_or_create_domain(cur, rel_folder: str) -> int:
    """notes/ 기준 상대 폴더 경로로 domain 계층 생성. 마지막 id 반환."""
    parts = rel_folder.replace("\\", "/").strip("/").split("/")
    parent_id = None
    for part in parts:
        slug = slugify("/".join(parts[:parts.index(part) + 1]))
        cur.execute("""
            INSERT INTO domains (parent_id, name, slug)
            VALUES (%s, %s, %s)
            ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name
            RETURNING id
        """, (parent_id, part, slug))
        parent_id = cur.fetchone()[0]
    return parent_id


def parse_related_questions(content: str) -> list[tuple[int, str]]:
    """## 관련 문제 섹션에서 (question_number, note) 리스트 반환."""
    section = re.search(r"## 관련 문제\n(.*?)(?=\n##|\Z)", content, re.DOTALL)
    if not section:
        return []
    results = []
    for line in section.group(1).splitlines():
        m = re.match(r"^-\s+Q(\d+):\s*(.+)", line.strip())
        if m:
            results.append((int(m.group(1)), m.group(2).strip()))
    return results


def parse_title(content: str) -> str:
    m = re.match(r"^#\s+(.+)$", content, re.MULTILINE)
    return m.group(1).strip() if m else "Unknown"


def seed_concepts():
    conn = get_conn()
    cur = conn.cursor()

    # exam_level id (databricks/ml/pro)
    cur.execute("""
        SELECT el.id FROM exam_levels el
        JOIN exams e ON e.id = el.exam_id
        JOIN vendors v ON v.id = e.vendor_id
        WHERE v.slug = 'databricks' AND e.slug = 'ml' AND el.slug = 'pro'
    """)
    row = cur.fetchone()
    if not row:
        print("exam_level not found. Run seed.py first.")
        return
    level_id = row[0]

    # question number → id 매핑
    cur.execute("""
        SELECT q.number, q.id FROM questions q
        JOIN exam_sets es ON es.id = q.exam_set_id
        WHERE es.exam_level_id = %s
    """, (level_id,))
    q_map = {row[0]: row[1] for row in cur.fetchall()}

    inserted_concepts = 0
    inserted_links = 0

    for dirpath, _, filenames in os.walk(BASE_NOTES):
        for fname in filenames:
            if not fname.endswith(".md"):
                continue

            fpath = os.path.join(dirpath, fname)
            content = open(fpath, encoding="utf-8").read()
            title = parse_title(content)

            rel_folder = os.path.relpath(dirpath, BASE_NOTES)
            domain_id = get_or_create_domain(cur, rel_folder)

            # slug: 폴더경로__파일명
            slug_base = os.path.relpath(fpath, BASE_NOTES).replace("\\", "/").replace("/", "__").replace(".md", "")

            cur.execute("""
                INSERT INTO concepts (exam_level_id, domain_id, title, slug, content)
                VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (slug) DO UPDATE
                    SET title = EXCLUDED.title,
                        content = EXCLUDED.content,
                        domain_id = EXCLUDED.domain_id
                RETURNING id
            """, (level_id, domain_id, title, slug_base, content))
            concept_id = cur.fetchone()[0]
            inserted_concepts += 1

            for q_num, note in parse_related_questions(content):
                q_id = q_map.get(q_num)
                if not q_id:
                    print(f"  [WARN] Q{q_num} not found in DB (from {fname})")
                    continue
                cur.execute("""
                    INSERT INTO question_concepts (question_id, concept_id, note)
                    VALUES (%s, %s, %s)
                    ON CONFLICT (question_id, concept_id) DO UPDATE SET note = EXCLUDED.note
                """, (q_id, concept_id, note))
                inserted_links += 1

    conn.commit()
    cur.close()
    conn.close()
    print(f"Done: {inserted_concepts} concepts, {inserted_links} question_concept links inserted.")


if __name__ == "__main__":
    seed_concepts()
