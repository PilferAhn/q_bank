"""
backend.py - 자격증 시험 문제은행 백엔드 (PostgreSQL)
dev:  Docker postgres:16 (localhost)
prod: Databricks Lakebase (managed PostgreSQL)
"""
import os
import psycopg2
import psycopg2.extras
import pandas as pd

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass


def get_connection():
    host = os.getenv("DB_HOST", "localhost")
    sslmode = "require" if host != "localhost" else None
    params = dict(
        host=host,
        port=os.getenv("DB_PORT", "5432"),
        dbname=os.getenv("DB_NAME", "q_bank"),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASSWORD", ""),
    )
    if sslmode:
        params["sslmode"] = sslmode
    return psycopg2.connect(**params)


def run_query(query: str, params=None) -> pd.DataFrame:
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query, params)
            if not cur.description:
                return pd.DataFrame()
            cols = [d[0] for d in cur.description]
            return pd.DataFrame(cur.fetchall(), columns=cols)


def run_execute(query: str, params=None):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query, params)
            try:
                row = cur.fetchone()
                return row[0] if row else None
            except Exception:
                return None


def _pivot_options(df: pd.DataFrame) -> pd.DataFrame:
    """(id, option_number, option_body, ...) 행들을 options dict로 집계"""
    if df.empty:
        return df
    result = []
    for _, group in df.groupby("id", sort=False):
        row = group.iloc[0].to_dict()
        row["options"] = dict(zip(
            group["option_number"].astype(str),
            group["option_body"]
        ))
        del row["option_number"]
        del row["option_body"]
        result.append(row)
    return pd.DataFrame(result)


def init_db():
    """앱 전용 결과 추적 테이블 생성"""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                CREATE TABLE IF NOT EXISTS exam_results (
                    result_id       SERIAL PRIMARY KEY,
                    user_name       TEXT,
                    exam_level_id   INTEGER,
                    exam_set_id     INTEGER,
                    total_questions INTEGER,
                    correct_count   INTEGER,
                    score           NUMERIC(5,2),
                    passed          BOOLEAN,
                    mode            TEXT,
                    exam_date       TIMESTAMPTZ DEFAULT NOW()
                );
                CREATE TABLE IF NOT EXISTS user_answers (
                    answer_id       SERIAL PRIMARY KEY,
                    result_id       INTEGER REFERENCES exam_results(result_id),
                    question_id     INTEGER,
                    selected_answer INTEGER,
                    is_correct      BOOLEAN,
                    answered_at     TIMESTAMPTZ DEFAULT NOW()
                );
            """)


init_db()


# ── 벤더 / 시험 / 레벨 ──

def get_vendors() -> pd.DataFrame:
    return run_query("SELECT id, name, slug FROM vendors ORDER BY name")


def get_exams(vendor_id: int) -> pd.DataFrame:
    return run_query(
        "SELECT id, name, slug FROM exams WHERE vendor_id = %s ORDER BY name",
        (vendor_id,)
    )


def get_exam_levels(exam_id: int) -> pd.DataFrame:
    return run_query(
        "SELECT id, level, slug FROM exam_levels WHERE exam_id = %s ORDER BY id",
        (exam_id,)
    )


def get_exam_sets(exam_level_id: int) -> pd.DataFrame:
    return run_query(
        "SELECT id, set_number FROM exam_sets WHERE exam_level_id = %s ORDER BY set_number",
        (exam_level_id,)
    )


def get_question_count_by_level(exam_level_id: int) -> int:
    df = run_query("""
        SELECT COUNT(*) AS cnt
        FROM exam_sets es
        JOIN questions q ON q.exam_set_id = es.id
        WHERE es.exam_level_id = %s
    """, (exam_level_id,))
    return int(df["cnt"].iloc[0]) if not df.empty else 0


# ── 문제 조회 ──

_Q_SELECT = """
    SELECT
        q.id,
        q.number,
        q.body,
        qo.option_number,
        qo.body           AS option_body,
        a.correct,
        a.answer_count,
        a.quote,
        a.explanation
    FROM questions q
    JOIN question_options qo ON qo.question_id = q.id
    JOIN answers          a  ON a.question_id  = q.id
"""


def get_questions_by_set(exam_set_id: int) -> pd.DataFrame:
    df = run_query(
        _Q_SELECT + "WHERE q.exam_set_id = %s ORDER BY q.number, qo.option_number",
        (exam_set_id,)
    )
    return _pivot_options(df)


def get_questions_by_level(exam_level_id: int, random: bool = False) -> pd.DataFrame:
    df = run_query(
        _Q_SELECT + """
        JOIN exam_sets es ON es.id = q.exam_set_id
        WHERE es.exam_level_id = %s
        ORDER BY es.set_number, q.number, qo.option_number
        """,
        (exam_level_id,)
    )
    result = _pivot_options(df)
    if random and not result.empty:
        result = result.sample(frac=1).reset_index(drop=True)
    return result


# ── 결과 저장 ──

def save_exam_result(user_name, exam_level_id, exam_set_id,
                     total, correct, score, passed, mode) -> int:
    return run_execute("""
        INSERT INTO exam_results
            (user_name, exam_level_id, exam_set_id, total_questions,
             correct_count, score, passed, mode)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING result_id
    """, (user_name, exam_level_id, exam_set_id, total, correct, score, passed, mode))


def save_user_answers(result_id: int, answers: list):
    if not answers:
        return
    query = """
        INSERT INTO user_answers (result_id, question_id, selected_answer, is_correct)
        VALUES (%s, %s, %s, %s)
    """
    for qid, selected, is_correct in answers:
        run_execute(query, (result_id, qid, int(selected), is_correct))


def get_exam_history() -> pd.DataFrame:
    return run_query("""
        SELECT r.result_id, r.user_name, el.level,
               r.total_questions, r.correct_count, r.score,
               r.passed, r.mode, r.exam_date
        FROM exam_results r
        LEFT JOIN exam_levels el ON el.id = r.exam_level_id
        ORDER BY r.exam_date DESC
    """)


def delete_exam_result(result_id: int):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM user_answers WHERE result_id = %s", (result_id,))
            cur.execute("DELETE FROM exam_results WHERE result_id = %s", (result_id,))


def get_wrong_answers(result_id: int) -> pd.DataFrame:
    df = run_query("""
        SELECT
            q.body                   AS question_text,
            qo.option_number,
            qo.body                  AS option_body,
            ua.selected_answer::text AS selected_answer,
            a.correct[1]::text       AS correct_answer,
            a.explanation
        FROM user_answers ua
        JOIN questions        q  ON q.id           = ua.question_id
        JOIN question_options qo ON qo.question_id = q.id
        JOIN answers          a  ON a.question_id  = q.id
        WHERE ua.result_id = %s AND ua.is_correct = false
        ORDER BY ua.answer_id, qo.option_number
    """, (result_id,))
    if df.empty:
        return df
    result = []
    for _, group in df.groupby("question_text", sort=False):
        row = group.iloc[0].to_dict()
        row["options"] = dict(zip(group["option_number"].astype(str), group["option_body"]))
        del row["option_number"]
        del row["option_body"]
        result.append(row)
    return pd.DataFrame(result)
