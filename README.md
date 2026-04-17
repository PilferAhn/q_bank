# Q-Bank — 자격증 시험 문제은행

Streamlit + PostgreSQL 기반 자격증 시험 문제은행 웹앱.
시험 모드(일괄 채점)와 연습 모드(즉시 정답)를 지원하며,
로컬 Docker 개발 + Databricks Apps 프로덕션 배포 구조.

## 스크린샷

```
① 벤더 선택 → ② 시험 선택 → ③ 레벨 선택 → ④ 시험/연습 시작
```

---

## 스택

| 구분 | 기술 |
|------|------|
| Frontend | Streamlit (Python) |
| DB (dev) | Docker PostgreSQL 16 (`localhost:5432`) |
| DB (prod) | Databricks Lakebase (managed PostgreSQL, AWS) |
| 배포 | Databricks Apps |
| CI/CD | GitHub Actions → `git push origin master` 자동 배포 |
| 인증 (CI/CD) | Service Principal OAuth M2M |

---

## 프로젝트 구조

```
q_bank/
├── frontend/                    # Streamlit 앱
│   ├── app.py                   # 라우터 + 사이드바
│   ├── app.yaml                 # Databricks App 설정 (CI/CD placeholder)
│   ├── backend.py               # PostgreSQL 쿼리 (psycopg2, SSL 자동 감지)
│   ├── .env                     # 로컬 개발 설정 (gitignore)
│   └── views/
│       ├── selector.py          # 벤더→시험→레벨→모드 선택
│       ├── exam_mode.py         # 시험 모드 (세트 단위, 일괄 채점)
│       ├── practice_mode.py     # 연습 모드 (1문제씩, 즉시 정답)
│       ├── option_selector.py   # 보기 버튼 컴포넌트
│       └── admin.py             # 시험 이력 / 문제 목록
├── backend/
│   └── docker-compose.yml       # 로컬 PostgreSQL 16
├── .github/workflows/
│   └── deploy.yml               # CI/CD (SP OAuth M2M → Databricks Apps)
├── schema.sql                   # DB 스키마
├── seed.sql / seed.py           # 시드 데이터
├── question/                    # 문제 원본 (마크다운)
├── SETUP_DATABRICKS.md          # Lakebase 배포 가이드
├── DEPLOY_TROUBLESHOOTING.md    # 배포 트러블슈팅 (에러 17개 + 해결)
├── DATABRICKS_AUTH_NOTES.md     # Databricks 인증 정리 (OAuth/JWT/SP)
└── TODO.md                      # 남은 할일
```

---

## 빠른 시작 (로컬 개발)

### 1. DB 실행

```bash
cd backend
docker-compose up -d
```

### 2. 스키마 + 시드 데이터

```bash
# Docker 안에서 실행
docker exec -i q_bank_db psql -U postgres -d q_bank < schema.sql
docker exec -i q_bank_db psql -U postgres -d q_bank < seed.sql
```

### 3. 앱 실행

```bash
cd frontend
pip install -r requirements.txt  # 최초 1회

# .env 설정
cat > .env << 'EOF'
DB_HOST=localhost
DB_PORT=5432
DB_NAME=q_bank
DB_USER=postgres
DB_PASSWORD=postgres
EOF

streamlit run app.py --server.port 8503 --server.headless true --server.address 0.0.0.0
```

- 로컬: http://localhost:8503
- 네트워크: http://<내IP>:8503 (모바일 접속 가능)

---

## DB 스키마

```
vendors → exams → exam_levels → exam_sets → questions → question_options
                                                      → answers
                                         domains → concepts ↔ question_concepts
```

| 테이블 | 설명 |
|--------|------|
| `vendors` | 벤더 (Databricks, AWS 등) |
| `exams` | 시험 (Machine Learning 등) |
| `exam_levels` | 레벨 (Professional 등) |
| `exam_sets` | 세트 (Set 1, Set 2 ...) |
| `questions` | 문제 본문 |
| `question_options` | 보기 (option_number: 1~5) |
| `answers` | 정답 + 해설 (`correct`: INTEGER[], `explanation`: TEXT) |
| `domains` / `concepts` | 개념 분류 (계층형) |
| `exam_results` / `user_answers` | 시험 결과 추적 (앱 자동 생성) |

> `answers.correct`는 `INTEGER[]` 배열 — 단일 정답도 `[1]` 형태.
> `answers.answer_count`: 1=단일, N=N개 정답, NULL=개수 미공개 멀티.

---

## 주요 기능

### 시험 모드
- 세트 단위 풀기 (Set 1의 60문제 등)
- 전부 풀고 일괄 채점
- 점수 + 합격 여부 + 오답노트 제공
- 결과는 `exam_results` 테이블에 저장

### 연습 모드
- 1문제씩 풀고 즉시 정답/해설 확인
- 해설에 원문 참조(quote) 포함
- `@st.fragment`로 빠른 인터랙션

### 공통
- 단일 선택 / 멀티 선택 자동 감지 (`answer_count`)
- 코드블록 마크다운 렌더링 (문제 + 보기 모두)
- 모바일 대응 CSS
- Databricks Apps에서 로그인 사용자 자동 감지

---

## 프로덕션 배포

### 아키텍처

```
git push origin master
    │
    ▼
GitHub Actions (deploy.yml)
    ├── app.yaml placeholder → 실제 값 치환 (sed)
    ├── DB 비밀번호 → Databricks Secret 저장
    ├── 소스코드 → Databricks Workspace 업로드
    └── databricks apps deploy
    │
    ▼
Databricks App (Streamlit)
    └── Lakebase (managed PostgreSQL, SSL 필수)
```

### 필요한 것

1. **Databricks Lakebase** 프로젝트 + `q_bank` DB
2. **Service Principal** + OAuth Secret + 3가지 권한
3. **GitHub Secrets** 8개 (공백 없이!)

자세한 내용:
- [SETUP_DATABRICKS.md](./SETUP_DATABRICKS.md) — Lakebase 설정 가이드
- [DEPLOY_TROUBLESHOOTING.md](./DEPLOY_TROUBLESHOOTING.md) — 배포 전 과정 + 에러 17개 해결
- [DATABRICKS_AUTH_NOTES.md](./DATABRICKS_AUTH_NOTES.md) — OAuth/JWT/SP 인증 정리

### 수동 배포 (필요 시)

```bash
databricks auth login --host https://<workspace>.cloud.databricks.com --profile oauth
databricks workspace import-dir ./frontend "/Workspace/Users/<user>/apps/q_bank" --overwrite --profile oauth
databricks apps deploy q-bank --source-code-path "/Workspace/Users/<user>/apps/q_bank" --profile oauth
```

---

## 현재 데이터

- 벤더: Databricks
- 시험: Machine Learning
- 레벨: Professional
- 세트: Set 1 (60문제)

---

## TODO

[TODO.md](./TODO.md) 참고

- [ ] `concepts` 테이블 UI 연결
- [ ] 벤더/시험 추가
- [ ] 시험 모드 오답노트 코드블록 렌더링
- [ ] `answers.quote` 데이터 보강
