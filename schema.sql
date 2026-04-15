-- ============================================================
-- Q-Bank Schema
-- ============================================================

-- 1. 벤더
CREATE TABLE IF NOT EXISTS vendors (
    id    SERIAL PRIMARY KEY,
    name  TEXT NOT NULL,
    slug  TEXT NOT NULL UNIQUE
);

-- 2. 시험 종류
CREATE TABLE IF NOT EXISTS exams (
    id        SERIAL PRIMARY KEY,
    vendor_id INTEGER NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
    name      TEXT NOT NULL,
    slug      TEXT NOT NULL,
    UNIQUE (vendor_id, slug)
);

-- 3. 시험 레벨
CREATE TABLE IF NOT EXISTS exam_levels (
    id      SERIAL PRIMARY KEY,
    exam_id INTEGER NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
    level   TEXT NOT NULL,
    slug    TEXT NOT NULL,
    UNIQUE (exam_id, slug)
);

-- 4. 시험 세트 (Set 1 ~ N)
CREATE TABLE IF NOT EXISTS exam_sets (
    id            SERIAL PRIMARY KEY,
    exam_level_id INTEGER NOT NULL REFERENCES exam_levels(id) ON DELETE CASCADE,
    set_number    INTEGER NOT NULL,
    UNIQUE (exam_level_id, set_number)
);

-- 5. 문제
CREATE TABLE IF NOT EXISTS questions (
    id          SERIAL PRIMARY KEY,
    exam_set_id INTEGER NOT NULL REFERENCES exam_sets(id) ON DELETE CASCADE,
    number      INTEGER NOT NULL,
    body        TEXT NOT NULL,
    UNIQUE (exam_set_id, number)
);

-- 6. 선택지 (option_number: 1~5 고정 식별자, 화면 표시 순서와 무관)
CREATE TABLE IF NOT EXISTS question_options (
    id            SERIAL PRIMARY KEY,
    question_id   INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    option_number INTEGER NOT NULL CHECK (option_number BETWEEN 1 AND 5),
    body          TEXT NOT NULL,
    UNIQUE (question_id, option_number)
);

-- 7. 정답 & 해설 (correct = option_number 1~5)
CREATE TABLE IF NOT EXISTS answers (
    id          SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE UNIQUE,
    correct     INTEGER NOT NULL CHECK (correct BETWEEN 1 AND 5),
    quote       TEXT,
    explanation TEXT
);

-- 8. 개념 도메인 (계층형)
CREATE TABLE IF NOT EXISTS domains (
    id        SERIAL PRIMARY KEY,
    parent_id INTEGER REFERENCES domains(id) ON DELETE SET NULL,
    name      TEXT NOT NULL,
    slug      TEXT NOT NULL UNIQUE
);

-- 9. 개념 노트
CREATE TABLE IF NOT EXISTS concepts (
    id            SERIAL PRIMARY KEY,
    exam_level_id INTEGER REFERENCES exam_levels(id) ON DELETE SET NULL,
    domain_id     INTEGER REFERENCES domains(id) ON DELETE SET NULL,
    title         TEXT NOT NULL,
    slug          TEXT NOT NULL UNIQUE,
    content       TEXT,
    created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 10. 문제 ↔ 개념 (M:N)
CREATE TABLE IF NOT EXISTS question_concepts (
    question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    concept_id  INTEGER NOT NULL REFERENCES concepts(id) ON DELETE CASCADE,
    note        TEXT,
    PRIMARY KEY (question_id, concept_id)
);
