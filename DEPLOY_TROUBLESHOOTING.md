# Databricks App 배포 트러블슈팅

Databricks Lakebase + Streamlit 앱 배포 중 만난 에러와 해결 방법 정리.

---

## 에러 1: `psql` 명령어를 못 찾음

```
'psql' 용어가 cmdlet, 함수, 스크립트 파일 또는 실행할 수 있는 프로그램 이름으로 인식되지 않습니다.
```

### 원인
Windows 로컬에 PostgreSQL 클라이언트(`psql`)가 설치되어 있지 않음.

### 해결
Docker 컨테이너 안에 있는 `psql`을 사용:

```bash
# 로컬에서 직접 실행 (X - 안 됨)
psql -h <host> -U <user> -d <db>

# Docker 컨테이너 안에서 실행 (O - 됨)
docker exec q_bank_db psql -h <host> -U <user> -d <db>
```

---

## 에러 2: `Provided authentication token is not a valid JWT encoding`

```
psql: error: connection to server failed: ERROR: Provided authentication token is not a valid JWT encoding
```

### 원인
Lakebase는 **2가지 인증 방식**이 있음:

| 방식 | 비밀번호에 넣는 것 | 만료 | 용도 |
|------|-------------------|------|------|
| **OAuth** | JWT 토큰 (`eyJraWQ...`) | 1시간 | psql 일회성 작업, 대화형 세션 |
| **Native Postgres Password** | 일반 비밀번호 (`QBank2026!`) | 안 만료 | 앱 연결, 장기 프로세스 |

- Databricks PAT 토큰(`dapi...`)은 **Lakebase 인증에 사용할 수 없음**
- 일반 비밀번호(`QBank2026!`)를 OAuth role에 넣으면 이 에러 발생

### 해결

**psql 일회성 작업 (덤프 복원 등):**

1. Lakebase App → 프로젝트 → Connect → OAuth 토큰 생성
2. `eyJraWQ...` 형태의 토큰을 비밀번호로 사용:

```bash
docker exec -e PGPASSWORD='eyJraWQ...(토큰)' -e PGSSLMODE=require \
  q_bank_db psql -h <lakebase-host> -U "jimin.ahn@data-dynamics.io" -d q_bank
```

**앱에서 장기 연결:**

OAuth role은 1시간마다 토큰 만료되므로, **별도 Native Postgres Password role 생성** 필요 (에러 3 참고).

---

## 에러 3: OAuth role에 일반 비밀번호를 사용하면 안 됨

```
OperationalError: connection to server failed: ERROR: Provided authentication token is not a valid JWT encoding
```

### 원인
`jimin.ahn@data-dynamics.io`는 **OAuth role**로 자동 생성된 계정이라, 일반 비밀번호(`QBank2026!`)로 로그인이 안 됨. JWT 토큰만 받음.

### 해결
Lakebase SQL Editor에서 **Native Postgres Password role을 별도로 생성**:

```sql
-- 1. 비밀번호 로그인용 계정 생성
CREATE ROLE q_bank_app WITH LOGIN PASSWORD 'QBank2026!';

-- 2. DB 권한 부여
GRANT ALL PRIVILEGES ON DATABASE q_bank TO q_bank_app;

-- 3. 테이블/시퀀스 권한 부여 (q_bank DB에 연결 후 실행)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO q_bank_app;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO q_bank_app;
```

그리고 `app.yaml`에서 DB_USER를 변경:

```yaml
# 변경 전 (OAuth role - 비밀번호 로그인 불가)
- name: DB_USER
  value: "jimin.ahn@data-dynamics.io"

# 변경 후 (Password role - 비밀번호 로그인 가능)
- name: DB_USER
  value: "q_bank_app"
```

### 정리: 계정 사용 구분

| 계정 | 용도 |
|------|------|
| `jimin.ahn@data-dynamics.io` | 사람이 직접 접속 (psql, SQL Editor). OAuth 토큰 사용 |
| `q_bank_app` | 앱이 자동 접속. 일반 비밀번호 사용 |

---

## 에러 4: SSL 연결 필수

```
FATAL: Invalid protocol version. Protocol version: 196608
DETAIL: Ensure that connection is using SSL. Try using `sslmode=require` in the connection string.
```

### 원인
Lakebase는 **모든 연결에 SSL 필수**. psycopg2 기본 설정은 SSL 없이 연결 시도함.

### 해결
`backend.py`에서 localhost가 아닌 경우 `sslmode=require` 자동 추가:

```python
# 변경 전
def get_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=os.getenv("DB_PORT", "5432"),
        dbname=os.getenv("DB_NAME", "q_bank"),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASSWORD", ""),
    )

# 변경 후
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
```

- **로컬 (localhost)**: SSL 없이 연결 (Docker PostgreSQL)
- **Lakebase (원격)**: SSL 필수로 연결

---

## 에러 5: Databricks PAT 토큰 권한 부족

```
Error: Provided PAT token does not have required scopes: apps
Error: Provided PAT token does not have required scopes: workspace
```

### 원인
Databricks PAT(`dapi...`)는 생성 시점에 Apps/Workspace scope가 포함되지 않을 수 있음.

### 해결
**PAT 대신 OAuth 인증 사용:**

```bash
# OAuth 프로필 생성 (브라우저가 열리고 로그인)
databricks auth login --host https://ddbx-serverless.cloud.databricks.com --profile oauth

# 이후 모든 명령에 --profile oauth 붙이기
databricks workspace import-dir ./frontend /Workspace/... --overwrite --profile oauth
databricks apps deploy q-bank --source-code-path /Workspace/... --profile oauth
```

OAuth는 PAT보다 권한 범위가 넓어서 Apps/Workspace 관련 명령도 동작함.

---

## 에러 6: Windows Git Bash 경로 변환 문제

```
ls: cannot access 'C:/Program Files/Git/var/tmp/': No such file or directory
```

### 원인
Git Bash가 Linux 경로(`/tmp`, `/var`)를 Windows Git 설치 경로로 자동 변환해버림.

### 해결
`MSYS_NO_PATHCONV=1` 환경변수로 경로 변환 비활성화:

```bash
# 안 됨
docker exec q_bank_db ls /tmp/dump.sql

# 됨
MSYS_NO_PATHCONV=1 docker exec q_bank_db ls /tmp/dump.sql
```

---

## 최종 배포 성공 구성

```
frontend/
├── app.yaml          # Databricks App 설정 (prod 환경변수)
├── .env              # 로컬 개발 설정 (localhost)
├── backend.py        # SSL 자동 감지 포함
└── ...

app.yaml 핵심 설정:
  DB_HOST:     ep-plain-mode-d2osyuep.database.us-east-1.cloud.databricks.com
  DB_USER:     q_bank_app (Native Postgres Password role)
  DB_PASSWORD: Databricks Secret (q-bank.DB_PASSWORD)에서 읽음
  sslmode:     backend.py에서 자동 require
```

### 배포 명령어 (수동)

```bash
# 1. OAuth 로그인
databricks auth login --host https://ddbx-serverless.cloud.databricks.com --profile oauth

# 2. 소스 업로드
databricks workspace import-dir ./frontend \
  /Workspace/Users/jimin.ahn@data-dynamics.io/apps/q_bank \
  --overwrite --profile oauth

# 3. 앱 배포
databricks apps deploy q-bank \
  --source-code-path /Workspace/Users/jimin.ahn@data-dynamics.io/apps/q_bank \
  --profile oauth
```

---

## 에러 7: `password authentication failed for user 'q_bank_app'`

```
OperationalError: connection to server failed: ERROR: password authentication failed for user 'q_bank_app'
```

### 원인
`app.yaml`에서 `valueFrom`으로 Databricks Secret을 읽으려 했지만 제대로 동작하지 않았음.

```yaml
# 이렇게 하면 Secret에서 읽어오는 건데, 동작하지 않았음
- name: DB_PASSWORD
  valueFrom: "q-bank.DB_PASSWORD"
```

### 해결
비밀번호를 `value`로 직접 넣어서 해결:

```yaml
# 직접 넣기 (동작함)
- name: DB_PASSWORD
  value: "QBank2026!"
```

> **주의:** 비밀번호를 코드에 직접 넣는 건 보안상 좋지 않음.
> 나중에 `valueFrom`이 정상 동작하면 Secret 방식으로 되돌리는 게 좋음.

---

## 에러 8: `permission denied for schema public`

```
InsufficientPrivilege: permission denied for schema public
LINE 2: CREATE TABLE IF NOT EXISTS exam_results (
```

### 이게 뭔 소리야?
앱이 시작할 때 `exam_results` 테이블이 없으면 자동으로 만들려고 하는데,
`q_bank_app` 계정에 **테이블을 만들 권한이 없어서** 거부당한 거야.

### 비유
카페에서 "커피 주세요"는 할 수 있는데 (SELECT - 데이터 읽기),
"새 메뉴 추가해주세요"는 직원만 할 수 있는 것처럼 (CREATE TABLE - 테이블 만들기),
`q_bank_app` 계정은 아직 "손님" 수준이라 테이블을 만들 권한이 없었음.

### 해결

Lakebase SQL Editor에서 **반드시 DB를 `q_bank`으로 선택한 상태에서** 아래 SQL 실행:

```sql
-- q_bank_app에게 public 스키마의 모든 권한 부여
GRANT ALL ON SCHEMA public TO q_bank_app;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO q_bank_app;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO q_bank_app;

-- 앞으로 새로 만들어지는 테이블/시퀀스에도 자동으로 권한 부여
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO q_bank_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO q_bank_app;
```

### 초보자가 자주 실수하는 점

**SQL Editor에서 DB 선택을 안 바꾸고 실행하는 것!**

```
SQL Editor 상단 드롭다운:

  [databricks_postgres ▼]  ← 이걸로 되어있으면 안 됨!
  [q_bank ▼]               ← 반드시 이걸로 바꿔야 함!
```

`databricks_postgres`에서 GRANT를 실행하면 `q_bank` DB에는 적용이 안 됨.
**꼭 `q_bank` DB를 선택한 상태에서 실행할 것!**

### 각 SQL이 하는 일 설명

| SQL | 쉬운 설명 |
|-----|----------|
| `GRANT ALL ON SCHEMA public` | "public 스키마에서 뭐든 해도 돼" |
| `GRANT ALL ON ALL TABLES` | "이미 있는 테이블 전부 읽고 쓰고 지워도 돼" |
| `GRANT ALL ON ALL SEQUENCES` | "자동 증가 번호(ID) 사용해도 돼" |
| `ALTER DEFAULT PRIVILEGES ... TABLES` | "앞으로 새로 만들어지는 테이블도 자동으로 권한 줄게" |
| `ALTER DEFAULT PRIVILEGES ... SEQUENCES` | "앞으로 새로 만들어지는 시퀀스도 자동으로 권한 줄게" |

---

## CI/CD 자동배포 설정

수동 배포에서 `git push` → 자동 배포로 전환하는 과정.

### 왜 CI/CD가 필요해?

수동 배포는 매번 이렇게 3단계를 직접 실행해야 함:
```bash
databricks auth login ...
databricks workspace import-dir ...
databricks apps deploy ...
```

CI/CD를 설정하면 `git push origin master` 한 번으로 끝남.

---

### 문제 1: `app.yaml`에 비밀번호가 코드에 박혀있음

```yaml
# 이렇게 하면 GitHub에 비밀번호가 올라감 (위험!)
- name: DB_PASSWORD
  value: "QBank2026!"
```

#### 해결: placeholder + CI/CD 치환 방식

`app.yaml`에는 가짜 값(placeholder)을 넣어두고, CI/CD가 배포할 때 진짜 값으로 바꿔치기함.

```yaml
# app.yaml (코드에 저장되는 것 - 안전)
- name: DB_HOST
  value: "your-lakebase-host"        # ← 가짜 값
- name: DB_USER
  value: "your-lakebase-user"        # ← 가짜 값
- name: DB_PASSWORD
  valueFrom: "q-bank.DB_PASSWORD"    # ← Databricks Secret에서 읽음
```

```yaml
# deploy.yml (CI/CD가 하는 일)
# 1. sed로 가짜 값을 진짜 값으로 치환
sed -i 's|your-lakebase-host|실제호스트|g' frontend/app.yaml
sed -i 's|your-lakebase-user|q_bank_app|g' frontend/app.yaml
# 2. 비밀번호는 Databricks Secret에 저장
databricks secrets put-secret q-bank DB_PASSWORD --string-value "QBank2026!"
```

**흐름도:**
```
GitHub Secrets (안전한 금고)
  ├── DB_HOST = ep-plain-mode-...
  ├── DB_USER = q_bank_app
  └── DB_PASSWORD = QBank2026!
         │
         ▼
CI/CD (GitHub Actions)
  ├── app.yaml의 placeholder를 sed로 치환
  ├── DB_PASSWORD를 Databricks Secret에 저장
  ├── 코드를 Databricks Workspace에 업로드
  └── 앱 배포
         │
         ▼
Databricks App 실행
  ├── DB_HOST, DB_USER → app.yaml에서 읽음 (치환된 값)
  └── DB_PASSWORD → Databricks Secret에서 읽음 (valueFrom)
```

---

### 문제 2: PAT 토큰 권한 부족 → 서비스 프린시플로 해결

#### PAT(Personal Access Token)의 문제
- 개인 토큰이라 CI/CD에 적합하지 않음
- Apps/Workspace scope가 없으면 배포 명령이 거부됨
- 토큰 만료 시 수동으로 재발급 필요

#### 서비스 프린시플이 뭐야?

**비유:** 회사에 "배포 전용 로봇 직원"을 하나 만드는 거야.
- 사람 계정(`jimin.ahn@...`)은 사람이 직접 로그인할 때 사용
- 서비스 프린시플(`q-bank-deploy`)은 자동화 시스템(CI/CD)이 사용
- 로봇 직원에게 "앱 배포"만 할 수 있는 권한을 줌

#### 서비스 프린시플 생성 방법

1. Databricks 워크스페이스 접속
2. 우상단 프로필 → **Admin Settings**
3. **Service principals** 탭 → **Add service principal**
4. 이름: `q-bank-deploy`
5. 생성 후 클릭 → **OAuth secrets** → **Generate secret**
6. **Client ID**와 **Client Secret**이 나옴 → 복사해놓기

> **중요:** Client Secret은 이때 한 번만 보여줌! 꼭 복사해놓기!

#### deploy.yml 인증 방식 변경

```yaml
# 변경 전: PAT 토큰 (개인 토큰)
env:
  DATABRICKS_HOST: ${{ secrets.DATABRICKS_HOST }}
  DATABRICKS_TOKEN: ${{ secrets.DATABRICKS_TOKEN }}

# 변경 후: 서비스 프린시플 OAuth (자동화용)
env:
  DATABRICKS_HOST: ${{ secrets.DATABRICKS_HOST }}
  DATABRICKS_CLIENT_ID: ${{ secrets.DATABRICKS_CLIENT_ID }}
  DATABRICKS_CLIENT_SECRET: ${{ secrets.DATABRICKS_CLIENT_SECRET }}
```

Databricks CLI는 `DATABRICKS_CLIENT_ID` + `DATABRICKS_CLIENT_SECRET` 환경변수가 있으면
자동으로 OAuth 인증을 사용함. 토큰 발급/갱신도 자동.

---

### GitHub Secrets 최종 상태

https://github.com/PilferAhn/q_bank/settings/secrets/actions

| Name | Value | 설명 |
|------|-------|------|
| `DATABRICKS_HOST` | `https://ddbx-serverless.cloud.databricks.com` | 워크스페이스 URL |
| `DATABRICKS_CLIENT_ID` | (서비스 프린시플 Client ID) | **새로 추가** |
| `DATABRICKS_CLIENT_SECRET` | (서비스 프린시플 Client Secret) | **새로 추가** |
| `DATABRICKS_USER` | `jimin.ahn@data-dynamics.io` | 워크스페이스 경로용 |
| `DATABRICKS_APP_NAME` | `q-bank` | 앱 이름 |
| `DB_HOST` | `ep-plain-mode-d2osyuep.database.us-east-1.cloud.databricks.com` | Lakebase 호스트 |
| `DB_USER` | `q_bank_app` | **값 변경** (기존: jimin.ahn@...) |
| `DB_PASSWORD` | `QBank2026!` | Lakebase 비밀번호 |

> `DATABRICKS_TOKEN`은 더 이상 필요 없으므로 **삭제해도 됨**.

---

### 자동배포 테스트 방법

```bash
# 1. 코드 커밋 & 푸시
git add -A
git commit -m "ci: switch to service principal OAuth for CI/CD"
git push origin master

# 2. GitHub Actions 확인
# https://github.com/PilferAhn/q_bank/actions 에서 초록색 체크 확인

# 3. Databricks App URL 접속해서 동작 확인
```

### 배포 실패 시 체크리스트

- [ ] GitHub Secrets 8개 전부 등록했는지?
- [ ] `DATABRICKS_TOKEN` 삭제하고 `CLIENT_ID`/`CLIENT_SECRET` 추가했는지?
- [ ] `DB_USER`를 `q_bank_app`으로 바꿨는지?
- [ ] 서비스 프린시플에 Apps/Workspace 권한이 있는지?
- [ ] Databricks Secret scope `q-bank`이 존재하는지? (이미 생성됨)

---

## CI/CD 실행 중 발생한 에러들

GitHub Actions에서 `deploy.yml` 실행 시 발생한 에러와 해결 방법.

### CI/CD 에러 1: `invalid character " " in host name`

```
Error: parse "***  ": invalid character " " in host name
```

#### 원인
GitHub Secrets에 값을 등록할 때 **앞뒤에 공백이 포함**됨.
예: `https://ddbx-serverless.cloud.databricks.com ` ← 끝에 공백!

GitHub Secrets는 복사-붙여넣기할 때 공백이 들어가기 쉬움.
눈에 안 보이지만 CLI가 URL을 파싱할 때 에러남.

#### 해결
해당 Secret을 **삭제하고 다시 등록**. 복사할 때 앞뒤 공백 없이!

> **팁:** Secret 값을 붙여넣은 후 `Home` → `Shift+End`로 전체 선택해서
> 앞뒤 공백이 있는지 눈으로 확인하는 습관을 들이자.

---

### CI/CD 에러 2: `cannot configure default credentials` (OAuth M2M)

```
Error: default auth: cannot configure default credentials
Config: host=***, client_id=***, client_secret=***
```

#### 원인
두 가지 가능성:

1. **Secret 값에 공백이 포함** — 위와 같은 문제
2. **OAuth Secret이 만료되었거나 무효** — SP의 OAuth Secret은 유효기간이 있음

#### 해결
1. `DATABRICKS_CLIENT_ID`, `DATABRICKS_CLIENT_SECRET` Secret 재등록 (공백 제거)
2. Secret이 만료되었으면 Databricks에서 새로 발급:
   - Admin Settings → Service principals → 해당 SP 클릭
   - OAuth secrets → Generate secret → 새 Client Secret 복사
   - GitHub Secrets 업데이트

---

### CI/CD 에러 3: `does not have secret-scopes.secrets/put permission`

```
Error: User *** does not have secret-scopes.secrets/put permission on scope ***
Auth type: OAuth Machine-to-Machine (oauth-m2m)
```

#### 이게 뭔 소리야?
OAuth M2M 인증은 성공했는데 (서비스 프린시플 로그인은 됨),
Databricks Secret scope에 비밀번호를 저장할 **권한이 없다**는 뜻.

#### 비유
회사 건물에 출입증으로 들어오는 건 됐는데 (로그인 성공),
금고 방에 들어가서 물건을 넣을 권한은 없는 상태 (Secret 쓰기 권한 없음).

#### 해결
서비스 프린시플에 Secret scope 접근 권한을 부여:

```bash
# OAuth 프로필로 실행 (관리자 권한 필요)
databricks secrets put-acl q-bank <서비스프린시플-client-id> MANAGE --profile oauth
```

- `q-bank`: Secret scope 이름
- `<서비스프린시플-client-id>`: SP의 Client ID
- `MANAGE`: 읽기+쓰기+관리 전체 권한

우리의 경우:
```bash
databricks secrets put-acl q-bank 4abe3da9-f69d-4821-be1e-74cce377deda MANAGE --profile oauth
```

---

### CI/CD 에러 4: `accepts 2 arg(s), received 3`

```
Run databricks workspace import-dir ./frontend \
Error: accepts 2 arg(s), received 3
```

#### 이게 뭔 소리야?
`databricks workspace import-dir`은 인자(argument)가 2개 필요함:
1. `SOURCE_PATH` = `./frontend` (로컬 경로)
2. `TARGET_PATH` = `/Workspace/Users/.../apps/q_bank` (Databricks 경로)

그런데 3개가 들어왔다고 함. 경로 안에 **공백이 있어서 쪼개진 것**.

#### 원인
`DATABRICKS_USER` Secret 값에 공백이 포함되어 있으면:

```
# Secret 값: "jimin.ahn@data-dynamics.io " (끝에 공백!)
# 결과:
databricks workspace import-dir ./frontend /Workspace/Users/jimin.ahn@data-dynamics.io /apps/q_bank --overwrite
                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ^^^^^^^^^^^^^^
                                           인자 2 (여기서 잘림)                          인자 3 (이게 생김!)
```

경로 중간에 공백이 들어가서 하나의 경로가 2개로 쪼개지고, 총 3개 인자가 됨.

#### 해결

**방법 1: Secret 값의 공백 제거** (근본 해결)
- GitHub Secrets에서 `DATABRICKS_USER` 삭제 후 다시 등록
- 값: `jimin.ahn@data-dynamics.io` (공백 절대 없이!)

**방법 2: deploy.yml에서 따옴표로 감싸기** (방어적 코딩)
```yaml
# 여러 줄로 쓰면 줄바꿈 + Secret 공백이 합쳐져서 문제가 될 수 있음
# 한 줄로 쓰고 따옴표로 감싸는 게 안전:

# 변경 전 (여러 줄, 따옴표 없음)
- name: Sync source to Databricks Workspace
  run: |
    databricks workspace import-dir ./frontend \
      /Workspace/Users/${{ secrets.DATABRICKS_USER }}/apps/q_bank \
      --overwrite

# 변경 후 (한 줄, 따옴표 있음)
- name: Sync source to Databricks Workspace
  run: databricks workspace import-dir ./frontend "/Workspace/Users/${{ secrets.DATABRICKS_USER }}/apps/q_bank" --overwrite
```

> **교훈:** GitHub Secrets 값에 공백이 들어가면 온갖 에러가 남.
> Secret 등록할 때 **반드시 앞뒤 공백을 제거**하는 것이 가장 중요!

---

## 현재 상태 (2026-04-17)

### 완료된 것

| # | 작업 | 상태 |
|---|------|------|
| 1 | Databricks 워크스페이스 확보 (AWS us-east-1) | 완료 |
| 2 | Lakebase 프로젝트 생성 (`q-bank`, PostgreSQL 16) | 완료 |
| 3 | `q_bank` 데이터베이스 생성 | 완료 |
| 4 | Connection details 확인 | 완료 |
| 5 | 로컬 Docker → `pg_dump` 풀 덤프 | 완료 |
| 6 | Lakebase에 스키마 + 데이터 복원 (12개 테이블) | 완료 |
| 7 | Databricks Secret scope `q-bank` 생성 + `DB_PASSWORD` 저장 | 완료 |
| 8 | Databricks App `q-bank` 생성 | 완료 |
| 9 | 수동 배포 + 동작 확인 (Streamlit + Lakebase 연결) | 완료 |
| 10 | `app.yaml` placeholder로 되돌림 (보안) | 완료 |
| 11 | `deploy.yml` OAuth 인증 방식으로 변경 | 완료 |
| 12 | `backend.py` SSL 자동 감지 추가 | 완료 |
| 13 | `selector.py` Databricks 사용자 헤더 감지 추가 | 완료 |
| 14 | GitHub Secrets 기본 등록 (6개) | 완료 |
| 15 | 코드 push (`fce5421`) | 완료 |

### 아직 안 된 것 (CI/CD 자동배포가 안 되는 이유)

현재 `git push origin master` 하면 GitHub Actions가 **실패**함. 이유:

#### 1. 서비스 프린시플이 없음

`deploy.yml`이 `DATABRICKS_CLIENT_ID` + `DATABRICKS_CLIENT_SECRET`으로 인증하도록 바꿨는데,
아직 서비스 프린시플 자체를 안 만들었음. 없는 계정으로 로그인하려는 거라 실패.

#### 2. GitHub Secrets에 `CLIENT_ID`/`CLIENT_SECRET`이 없음

서비스 프린시플을 만들어야 Client ID와 Client Secret이 나오고,
그걸 GitHub Secrets에 등록해야 CI/CD가 동작함.

#### 3. `DB_USER` GitHub Secret 값이 옛날 값임

GitHub Secrets의 `DB_USER`가 아직 `jimin.ahn@data-dynamics.io`로 되어있을 수 있음.
`q_bank_app`으로 변경해야 CI/CD가 올바른 계정으로 배포함.

---

## 남은 할일 (순서대로)

### Step 1: Databricks 서비스 프린시플 생성

> **어디서:** Databricks 워크스페이스 웹

1. https://ddbx-serverless.cloud.databricks.com 접속
2. 우상단 프로필 클릭 → **Admin Settings**
3. 왼쪽 메뉴 **Service principals** 클릭
4. **Add service principal** 클릭
5. 이름: `q-bank-deploy` 입력 → 저장
6. 방금 만든 `q-bank-deploy` 클릭
7. **OAuth secrets** 섹션 → **Generate secret** 클릭
8. **Client ID**와 **Client Secret**이 화면에 나옴

> **주의:** Client Secret은 **이 화면에서 한 번만** 보여줌!
> 반드시 어딘가에 복사해놓기. 닫으면 다시 못 봄.

### Step 2: 서비스 프린시플에 권한 부여

> **어디서:** Databricks 워크스페이스 웹

서비스 프린시플을 만들었어도 권한이 없으면 아무것도 못 함.
아래 권한을 부여해야 함:

1. **Workspace 접근 권한**
   - Admin Settings → Service principals → `q-bank-deploy` 클릭
   - **Entitlements** 에서 `Workspace access` 체크

2. **Apps 배포 권한**
   - Databricks Apps → `q-bank` 앱 → Settings/Permissions
   - `q-bank-deploy` 서비스 프린시플에 `Can Manage` 권한 부여

3. **Workspace 폴더 접근 권한**
   - Workspace → `/Users/jimin.ahn@data-dynamics.io/apps/q_bank` 폴더
   - 해당 폴더에 `q-bank-deploy`에게 쓰기 권한 부여

### Step 3: GitHub Secrets 업데이트

> **어디서:** https://github.com/PilferAhn/q_bank/settings/secrets/actions

| 작업 | Name | Value |
|------|------|-------|
| **추가** | `DATABRICKS_CLIENT_ID` | Step 1에서 복사한 Client ID |
| **추가** | `DATABRICKS_CLIENT_SECRET` | Step 1에서 복사한 Client Secret |
| **수정** | `DB_USER` | `q_bank_app` (기존: `jimin.ahn@data-dynamics.io`) |
| **수정** | `DB_PASSWORD` | `QBank2026!` |
| **삭제** | `DATABRICKS_TOKEN` | 더 이상 안 씀 |

나머지는 그대로 유지:
- `DATABRICKS_HOST` = `https://ddbx-serverless.cloud.databricks.com`
- `DATABRICKS_USER` = `jimin.ahn@data-dynamics.io`
- `DATABRICKS_APP_NAME` = `q-bank`
- `DB_HOST` = `ep-plain-mode-d2osyuep.database.us-east-1.cloud.databricks.com`

### Step 4: GitHub Actions 재실행

> **어디서:** https://github.com/PilferAhn/q_bank/actions

1. 가장 최근 실패한 워크플로우 클릭
2. **Re-run all jobs** 클릭
3. 또는 GitHub Actions 페이지에서 **Run workflow** 버튼 (workflow_dispatch 지원)
4. 초록색 체크가 뜨면 성공!

### Step 5: 앱 동작 확인

1. Databricks Apps에서 `q-bank` 앱 URL 클릭
2. Streamlit 화면이 뜨는지 확인
3. 문제 조회/풀기가 동작하는지 확인
4. 응시자 이름이 자동으로 잡히는지 확인
