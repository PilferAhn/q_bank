# q_bank 프로젝트 규칙

## 스택

- **Frontend**: Streamlit — `frontend/README.md` 참고
- **Backend**: PostgreSQL (Docker) — `backend/docker-compose.yml`
- **DB 연결**: psycopg2, `.env` 파일 (`frontend/.env`)

---

## DB 스키마 핵심

```
questions:        id, exam_set_id, number, body
question_options: id, question_id, option_number(int), body
answers:          id, question_id, correct(INTEGER[]), answer_count(int|null), quote, explanation
```

- `correct`는 `INTEGER[]` 배열 — 단일 정답도 `[1]` 형태
- `answer_count`: 1=단일, N=N개 정답, NULL=개수 미공개 멀티

---

## push 규칙

명시적으로 "push해"라고 할 때만 push. 그 전까지는 commit만.
