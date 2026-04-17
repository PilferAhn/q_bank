# Databricks Lakebase 배포 가이드

## 아키텍처

```
dev  (로컬)      →  Docker postgres:16       (localhost:5432)
prod (Databricks) →  Lakebase Autoscaling     (managed PostgreSQL)
```

psycopg2 단일 코드베이스. SQL 방언 차이 없음. `.env` / `app.yaml` 환경변수만 다름.

---

## 사전 조건

- Databricks 워크스페이스 (AWS)
- 지원 리전: us-east-1, us-east-2, us-west-2, ca-central-1, sa-east-1, eu-central-1, eu-west-1, eu-west-2, ap-south-1, ap-southeast-1, ap-southeast-2
- Lakebase 프로젝트는 워크스페이스 리전에 자동 생성됨
- PostgreSQL 16 또는 17 지원

---

## 1. Lakebase 프로젝트 생성

> 2026-03-12부터 새 인스턴스는 모두 **Lakebase Autoscaling** (프로젝트 기반)으로 생성됨.

### UI로 생성

1. Databricks 워크스페이스 → 우상단 앱 스위처 → **Lakebase App** 열기
2. **New project** 클릭
3. 설정:
   - Project name: `q-bank`
   - Postgres version: `16` (로컬 Docker와 동일)
4. 생성 완료 후 자동으로 만들어지는 것:
   - `production` 브랜치 (기본, 삭제 불가)
   - R/W 컴퓨트 (8~16 CU, Autoscaling 활성화)
   - `databricks_postgres` 기본 DB
   - Databricks 계정으로 Postgres role 자동 생성

### CLI로 생성

```bash
databricks postgres create-project q-bank \
  --json '{
    "spec": {
      "display_name": "Q Bank",
      "pg_version": 16
    }
  }'
```

### Python SDK로 생성

```python
from databricks.sdk import WorkspaceClient
from databricks.sdk.service.postgres import Project, ProjectSpec

w = WorkspaceClient()
operation = w.postgres.create_project(
    project=Project(
        spec=ProjectSpec(display_name="Q Bank", pg_version=16)
    ),
    project_id="q-bank"
)
result = operation.wait()
print(f"Created: {result.name}")
```

---

## 2. Lakebase에 q_bank DB 생성

프로젝트 생성 시 기본 DB는 `databricks_postgres`. 우리 앱용 DB를 별도로 만들어야 함.

### Lakebase App UI에서

1. 프로젝트 선택 → **SQL Editor** 또는 **Tables editor**
2. `CREATE DATABASE q_bank;` 실행

### psql로 직접 연결

```bash
# Connection details는 Lakebase App → 프로젝트 → Connect 탭에서 확인
psql -h <lakebase-host> -U <user> -d databricks_postgres -c "CREATE DATABASE q_bank;"
```

---

## 3. 스키마 + 데이터 마이그레이션

```bash
# 로컬 Docker에서 덤프
pg_dump -h localhost -U postgres q_bank > dump.sql

# Lakebase에 복원
psql -h <lakebase-host> -U <user> -d q_bank < dump.sql
```

또는 테이블 단위로:

```bash
pg_dump -U postgres -h localhost q_bank \
  --data-only --inserts \
  -t vendors -t exams -t exam_levels -t exam_sets \
  -t questions -t question_options -t answers \
  -t domains -t concepts -t question_concepts \
  | psql -h <lakebase-host> -U <user> -d q_bank
```

---

## 4. Unity Catalog 등록

Lakebase 테이블은 Unity Catalog에 자동 등록됨 (메타데이터, 권한, 검색).
Spark 분석이 필요하면 **Lakehouse Sync** 를 별도 설정.

---

## 5. GitHub Secrets 등록

> 레포 → Settings → Secrets and variables → Actions → New repository secret

| Secret 이름 | 값 | 어디서 확인 |
|------------|---|-----------|
| `DATABRICKS_HOST` | `https://adb-xxxxxxxxxx.azuredatabricks.net` | Databricks 워크스페이스 URL |
| `DATABRICKS_TOKEN` | `dapi...` | Databricks → User Settings → Access tokens |
| `DATABRICKS_USER` | `your@email.com` | Databricks 계정 이메일 |
| `DATABRICKS_APP_NAME` | `q-bank` | 앱 이름 (자유롭게 지정, 이후 고정) |
| `DB_HOST` | Lakebase 호스트 | Lakebase App → 프로젝트 → Connect |
| `DB_USER` | Lakebase 유저명 | Lakebase App → 프로젝트 → Connect |
| `DB_PASSWORD` | Lakebase 패스워드 | Lakebase App → 프로젝트 → Connect |

---

## 6. Databricks App 최초 생성

> GitHub Actions는 **이미 존재하는 앱**에 배포함. 앱 자체는 처음 한 번만 수동 생성.

```bash
# Databricks CLI 설치 (pip install databricks-cli 아님!)
# https://docs.databricks.com/dev-tools/cli/install.html 참고
databricks configure --token   # HOST, TOKEN 입력

# 앱 생성
databricks apps create q-bank \
  --source-code-path /Workspace/Users/<your@email.com>/apps/q_bank
```

---

## 7. 배포 흐름 (CI/CD)

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

## 8. 로컬 dev 실행 (변경 없음)

```bash
# 1. PostgreSQL 컨테이너 시작
cd backend && docker-compose up -d

# 2. Streamlit 앱 실행
cd frontend && streamlit run app.py
```

`frontend/.env`:
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=q_bank
DB_USER=postgres
DB_PASSWORD=postgres
```

---

## TODO 체크리스트

### Databricks 설정 (웹 UI)
- [ ] Databricks 워크스페이스 확보 (AWS, 지원 리전)
- [ ] Lakebase App에서 프로젝트 생성 (`q-bank`, PostgreSQL 16)
- [ ] `q_bank` 데이터베이스 생성 (기본 DB는 `databricks_postgres`)
- [ ] Connection details 확인 (Host, User, Password)

### 데이터 마이그레이션
- [ ] 로컬 Docker PostgreSQL에서 `pg_dump`
- [ ] Lakebase에 스키마 적용
- [ ] Lakebase에 시드 데이터 로드

### CI/CD 설정
- [ ] GitHub Secrets 7개 등록
- [ ] `databricks apps create q-bank` 최초 실행

### 검증
- [ ] `master` push 후 GitHub Actions 성공 확인
- [ ] Databricks App URL로 접속 확인
- [ ] Lakebase 연결 동작 확인 (문제 조회/풀기)

### 선택 (나중에)
- [ ] Unity Catalog 등록 확인
- [ ] Lakehouse Sync 설정 (Spark 분석 필요 시)
- [ ] Scale-to-zero 설정 (비용 최적화)
- [ ] Branching으로 dev/staging 환경 분리

---

> 참고 문서:
> - Lakebase 개요: https://docs.databricks.com/aws/en/oltp
> - Lakebase Autoscaling: https://docs.databricks.com/aws/en/oltp/projects/
> - 프로젝트 관리: https://docs.databricks.com/aws/en/oltp/projects/manage-projects
> - 개념 정리: [LAKEBASE_OVERVIEW.md](./LAKEBASE_OVERVIEW.md)
