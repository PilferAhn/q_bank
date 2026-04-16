# Databricks CI/CD 설정 메모

## 아키텍처

```
dev  (로컬)      →  Docker postgres:16  (localhost:5432)
prod (Databricks) →  Databricks Lakebase (managed PostgreSQL)
```

psycopg2 단일 코드베이스. SQL 방언 차이 없음. 환경변수만 다름.

---

## 1. GitHub Secrets 등록

> 레포 → Settings → Secrets and variables → Actions → New repository secret

| Secret 이름 | 값 | 어디서 확인 |
|------------|---|-----------|
| `DATABRICKS_HOST` | `https://adb-xxxxxxxxxx.azuredatabricks.net` | Databricks 워크스페이스 URL |
| `DATABRICKS_TOKEN` | `dapi...` | Databricks → User Settings → Access tokens |
| `DATABRICKS_USER` | `your@email.com` | Databricks 계정 이메일 |
| `DATABRICKS_APP_NAME` | `q-bank` | 앱 이름 (자유롭게 지정, 이후 고정) |
| `DB_HOST` | Lakebase 엔드포인트 | Lakebase 인스턴스 접속 정보 |
| `DB_USER` | Lakebase 유저명 | Lakebase 인스턴스 접속 정보 |
| `DB_PASSWORD` | Lakebase 패스워드 | Lakebase 인스턴스 접속 정보 |

---

## 2. Databricks Lakebase 설정

1. Databricks 워크스페이스 → **Lakebase** → 인스턴스 생성
2. 생성 후 **Connection details**에서 Host, User, Password 확인
3. 해당 값을 GitHub Secrets에 등록 (`DB_HOST`, `DB_USER`, `DB_PASSWORD`)
4. Lakebase 인스턴스에 `q_bank` 데이터베이스 생성

---

## 3. 최초 1회: Databricks App 생성

> GitHub Actions는 **이미 존재하는 앱**에 배포함. 앱 자체는 처음 한 번만 수동 생성.

```bash
# 로컬에서 Databricks CLI 설치 후 실행
pip install databricks-cli
databricks configure --token   # HOST, TOKEN 입력

# 앱 생성 (이름은 DATABRICKS_APP_NAME Secret과 동일하게)
databricks apps create q-bank \
  --source-code-path /Workspace/Users/<your@email.com>/apps/q_bank
```

---

## 4. 최초 1회: Lakebase에 스키마 + 데이터 시딩

```bash
# schema.sql을 Lakebase에 적용 (psql 사용)
psql -h <lakebase-host> -U <user> -d q_bank -f schema.sql

# 로컬 데이터를 Lakebase로 복사
pg_dump -U postgres -h localhost q_bank \
  --data-only --inserts \
  -t vendors -t exams -t exam_levels -t exam_sets \
  -t questions -t question_options -t answers \
  -t domains -t concepts -t question_concepts \
  | psql -h <lakebase-host> -U <user> -d q_bank
```

---

## 5. 배포 흐름

```
git push origin master
    └─ GitHub Actions 트리거
        ├─ app.yaml에 DB_HOST, DB_USER 주입 (sed)
        ├─ DB_PASSWORD를 Databricks Secret에 저장
        ├─ ./frontend → /Workspace/Users/.../apps/q_bank 업로드
        └─ databricks apps deploy q-bank
```

Actions 로그 확인: GitHub 레포 → **Actions** 탭

---

## 6. 로컬 dev 실행 (변경 없음)

```bash
# 1. PostgreSQL 컨테이너 시작
cd backend && docker-compose up -d

# 2. Streamlit 앱 실행
cd frontend && streamlit run app.py
```

`frontend/.env` 파일 (DB_HOST=localhost 이면 자동으로 로컬 PostgreSQL 사용):
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=q_bank
DB_USER=postgres
DB_PASSWORD=postgres
```

---

## TODO 체크리스트

- [ ] GitHub Secrets 7개 등록
- [ ] Databricks Lakebase 인스턴스 생성
- [ ] Lakebase에 `q_bank` DB 생성
- [ ] `databricks apps create q-bank` 최초 실행
- [ ] Lakebase에 스키마 적용 (`schema.sql`)
- [ ] Lakebase에 시드 데이터 로드 (pg_dump → psql)
- [ ] `master` push 후 GitHub Actions 성공 확인
- [ ] Databricks App URL로 접속 확인
