# Databricks Lakebase + Apps 배포 완전 가이드

> 로컬 Docker PostgreSQL → Databricks Lakebase(managed PostgreSQL) 마이그레이션,
> Databricks Apps(Streamlit) 배포, CI/CD 자동화까지의 전 과정.
> 만난 에러 17개와 해결 방법, 그리고 **왜 그 에러를 미리 예측하지 못했는지** 반성까지 포함.

---

# 1부: 전체 그림

## 우리가 만든 것

자격증 시험 문제은행 웹앱. Streamlit(Python) + PostgreSQL.

## 로컬 개발 vs 프로덕션 비교

```
┌─ 로컬 개발 (dev) ──────────────────┐    ┌─ 프로덕션 (prod) ──────────────────────┐
│                                     │    │                                         │
│  브라우저 → localhost:8503          │    │  브라우저 → Databricks App URL          │
│      │                              │    │      │                                  │
│      ▼                              │    │      ▼                                  │
│  Streamlit (app.py)                 │    │  Streamlit (app.py)                     │
│      │                              │    │      │                                  │
│      ▼                              │    │      ▼                                  │
│  Docker PostgreSQL                  │    │  Databricks Lakebase                    │
│  localhost:5432                     │    │  (managed PostgreSQL, AWS)              │
│  user: postgres                     │    │  user: q_bank_app                       │
│  password: postgres                 │    │  password: Databricks Secret에서 읽음   │
│  SSL: 불필요                        │    │  SSL: 필수 (sslmode=require)            │
│                                     │    │                                         │
└─────────────────────────────────────┘    └─────────────────────────────────────────┘
```

## 배포 3단계

```
Phase 1: DB 마이그레이션          Phase 2: 수동 배포             Phase 3: CI/CD 자동화
─────────────────────          ──────────────────           ────────────────────
Docker PostgreSQL               Databricks CLI로              git push origin master
   │  pg_dump                   소스 업로드 + 앱 배포           │
   ▼                               │                           ▼
Lakebase에 데이터 복원          브라우저에서 앱 동작 확인       GitHub Actions가
                                                              자동으로 배포
```

---

# 2부: 계정과 권한 — 이 프로젝트의 가장 어려운 부분

> 이 프로젝트에서 만난 에러 17개 중 **10개가 계정/권한 문제**였다.
> 여기서 한 번에 정리하고 가자.

## 왜 계정이 3개나 필요해?

```
비유: 회사에 3종류의 출입증이 있다

🧑 사원증 (OAuth role)
   → 사람이 직접 건물에 들어갈 때 사용
   → 매일 아침 출입 게이트에서 인증 (1시간짜리 임시 토큰)

🤖 로봇 출입증 (Native Password role)
   → 24시간 돌아가는 기계(앱)가 사용
   → 비밀번호로 인증, 만료 없음

🔧 배포 로봇 출입증 (Service Principal)
   → CI/CD 자동화 시스템이 사용
   → Client ID + Client Secret으로 인증
```

### 실제 매핑

| 비유 | 실제 계정 | 인증 방식 | 용도 | 만료 |
|------|----------|----------|------|------|
| 🧑 사원증 | `jimin.ahn@data-dynamics.io` | OAuth JWT 토큰 | psql 직접 접속, SQL Editor | 1시간 |
| 🤖 로봇 출입증 | `q_bank_app` | 일반 비밀번호 (`QBank2026!`) | Streamlit 앱의 DB 연결 | 만료 없음 |
| 🔧 배포 로봇 | `principal_from_workspace` | Client ID + Secret | GitHub Actions CI/CD | Secret 유효기간 |

### 왜 하나의 계정으로 안 되나?

```
❌ jimin.ahn@... 하나로 다 하면?
   → 앱이 1시간마다 토큰 갱신해야 함 (OAuth라서)
   → CI/CD에서 사람 계정 쓰면 보안 위험 + 퇴사 시 배포 불가

❌ q_bank_app 하나로 다 하면?
   → Databricks CLI 인증 불가 (Workspace/Apps API는 Databricks 계정만 가능)
   → DB 접속만 가능, 앱 배포는 못 함

✅ 그래서 역할별로 나눔:
   사람 → OAuth role (관리용)
   앱 → Password role (DB 접속용)
   CI/CD → Service Principal (배포 자동화용)
```

### 미리 예측하지 못한 이유

> 일반적인 웹 개발에서는 DB 계정 하나 + 서버 계정 하나면 충분하다.
> Databricks는 **DB 인증**과 **플랫폼 인증**이 완전히 분리된 구조라서,
> "DB에 연결되면 앱도 배포할 수 있겠지"라는 기존 경험이 통하지 않았다.
> Lakebase(PostgreSQL)와 Databricks Platform은 별개의 인증 체계를 가진다.

---

## 서비스 프린시플(SP)의 3가지 권한

> 이게 가장 헷갈리는 부분이다.
> SP를 만들었다고 끝이 아니라, **3개의 문을 각각 열어줘야** 한다.

### 비유: 신입사원 첫 출근

```
서비스 프린시플을 만든다 = 신입사원에게 사번을 발급한다

하지만 사번만 있으면 아무것도 못 함:
  ❌ 건물 1층 로비까지만 들어올 수 있음 (로그인은 됨)
  ❌ 금고실 출입 불가 (Secret 접근 불가)
  ❌ 사무실 출입 불가 (Workspace 폴더 접근 불가)
  ❌ 배포 버튼 못 누름 (App 배포 권한 없음)

그래서 3개의 카드키를 각각 발급해야 함:
  🔑 카드키 1: 금고실 (Secret scope)
  🔑 카드키 2: 사무실 (Workspace 폴더)
  🔑 카드키 3: 배포 버튼 (App)
```

### 3가지 권한 상세

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    GitHub Actions (CI/CD) 배포 과정                          │
│                                                                             │
│  Step 1: Databricks 로그인                                                  │
│          → CLIENT_ID + CLIENT_SECRET으로 인증                               │
│          → SP 자체가 존재하면 성공                                            │
│                                                                             │
│  Step 2: Databricks Secret에 DB 비밀번호 저장                                │
│          → 🔑 권한 1: Secret scope "q-bank"에 MANAGE 권한 필요               │
│          → 없으면: "does not have secret-scopes.secrets/put permission"      │
│                                                                             │
│  Step 3: 소스코드를 Workspace 폴더에 업로드                                   │
│          → 🔑 권한 2: /Workspace/Users/.../apps/q_bank 에 CAN_MANAGE 필요    │
│          → 없으면: "no such directory" (사실은 권한 없음)                      │
│                                                                             │
│  Step 4: 앱 배포 명령 실행                                                   │
│          → 🔑 권한 3: q-bank 앱에 CAN_MANAGE 필요                            │
│          → 없으면: "assign the user CAN_MANAGE permission for the app"       │
│                                                                             │
│  → 3개 전부 있어야 Step 4까지 도달해서 배포 성공!                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 권한 부여 명령어

| # | 권한 | 대상 리소스 | 명령어 |
|---|------|-----------|--------|
| 1 | Secret scope 읽기/쓰기 | `q-bank` scope | `databricks secrets put-acl q-bank <SP-client-id> MANAGE --profile oauth` |
| 2 | Workspace 폴더 쓰기 | `/Workspace/.../apps/q_bank` | `databricks api patch /api/2.0/permissions/directories/<폴더ID> --json '{"access_control_list":[{"service_principal_name":"<SP-client-id>","permission_level":"CAN_MANAGE"}]}' --profile oauth` |
| 3 | App 배포 | `q-bank` 앱 | `databricks api patch /api/2.0/permissions/apps/q-bank --json '{"access_control_list":[{"service_principal_name":"<SP-client-id>","permission_level":"CAN_MANAGE"}]}' --profile oauth` |

> `--profile oauth`는 **사람 계정**(관리자)으로 실행한다는 뜻.
> SP 자신은 권한을 줄 수 없고, 관리자가 줘야 한다.

### 미리 예측하지 못한 이유

> **Databricks는 "최소 권한 원칙(Principle of Least Privilege)"을 엄격하게 적용한다.**
>
> 일반적인 클라우드(AWS IAM 등)에서도 비슷하지만, Databricks는:
> - Secret scope, Workspace 폴더, App이 **각각 독립된 권한 시스템**을 가짐
> - SP를 만들 때 "전체 권한" 같은 옵션이 없음
> - 공식 문서에서도 이 3가지를 **한 곳에서 설명하지 않음** (각각 다른 페이지에 분산)
>
> 그래서 Step 2에서 막히고 → 권한 주고 → Step 3에서 막히고 → 권한 주고 → Step 4에서 또 막히는
> "하나씩 부딪혀서 하나씩 해결하는" 패턴이 된 것이다.
> 처음부터 "SP에게 이 3가지를 전부 줘야 한다"는 체크리스트가 있었다면 한 번에 끝났을 것이다.

---

## DB 권한 (PostgreSQL 레벨)

위의 3가지는 **Databricks 플랫폼** 권한이고, 이건 **PostgreSQL DB** 안의 권한이다.

```
Databricks 플랫폼 권한 (SP용, CI/CD가 사용)
  ├── Secret scope → 비밀번호 저장
  ├── Workspace → 소스코드 업로드
  └── App → 앱 배포

PostgreSQL DB 권한 (q_bank_app용, 앱이 사용)
  ├── SCHEMA public → 테이블 생성
  ├── TABLES → 읽기/쓰기
  └── SEQUENCES → 자동 번호(ID) 사용
```

이 두 가지는 **완전히 별개**. 하나를 설정했다고 다른 하나가 되는 게 아님.

---

# 3부: Phase 1 — DB 마이그레이션

로컬 Docker PostgreSQL의 데이터를 Databricks Lakebase로 옮기는 과정.

---

## 에러 1: `psql` 명령어를 못 찾음

```
'psql' 용어가 cmdlet, 함수, 스크립트 파일 또는 실행할 수 있는 프로그램 이름으로 인식되지 않습니다.
```

### 원인
Windows에 PostgreSQL 클라이언트(`psql`)가 설치되어 있지 않음.

### 해결
Docker 컨테이너 안에 있는 `psql`을 사용:

```bash
# ❌ 로컬에서 직접 (안 됨)
psql -h <host> -U <user> -d <db>

# ✅ Docker 안에서 (됨)
docker exec q_bank_db psql -h <host> -U <user> -d <db>
```

### 왜 미리 못 잡았나
> 개발 환경 세팅을 처음부터 Docker 기반으로 했기 때문에, 로컬에 psql이 없다는 것을 당연히 인지하고 있었어야 했다. Docker 안에 psql이 있다는 대안을 처음부터 안내했어야 함.

---

## 에러 2: `Provided authentication token is not a valid JWT encoding` (psql)

```
psql: error: connection to server failed: ERROR: Provided authentication token is not a valid JWT encoding
```

### 원인
Lakebase에 접속할 때 **Databricks PAT 토큰**(`dapi...`)이나 **일반 비밀번호**를 넣었음.
하지만 `jimin.ahn@data-dynamics.io` 계정은 **OAuth role**이라서, **OAuth JWT 토큰**만 받음.

Lakebase 인증 방식 2가지:

| 방식 | 비밀번호에 넣는 것 | 만료 | 용도 |
|------|-------------------|------|------|
| **OAuth** | JWT 토큰 (`eyJraWQ...`) | 1시간 | 사람이 직접 접속 (psql, SQL Editor) |
| **Native Postgres Password** | 일반 비밀번호 (`QBank2026!`) | 안 만료 | 앱의 DB 연결 |

### 해결
Lakebase → 프로젝트 → **Connect** 탭에서 OAuth 토큰 생성 후 사용:

```bash
docker exec -e PGPASSWORD='eyJraWQ...(토큰)' -e PGSSLMODE=require \
  q_bank_db psql -h <lakebase-host> -U "jimin.ahn@data-dynamics.io" -d q_bank
```

### 왜 미리 못 잡았나
> Databricks PAT 토큰(`dapi...`)이 모든 Databricks 서비스에 통용될 거라고 잘못 가정했다.
> 실제로는 **Lakebase(PostgreSQL)는 Databricks Platform과 다른 인증 체계**를 사용한다.
> PAT은 REST API용이고, Lakebase는 PostgreSQL 프로토콜이라 OAuth JWT가 필요하다.
> 이 구분을 처음부터 설명했어야 했다.

---

## 에러 3: OAuth role에 일반 비밀번호 사용

```
OperationalError: connection to server failed: ERROR: Provided authentication token is not a valid JWT encoding
```

### 원인
에러 2와 같은 메시지지만 다른 상황.
**앱(Streamlit)**에서 DB에 연결할 때 `jimin.ahn@data-dynamics.io` 계정에 `QBank2026!` 비밀번호를 넣었음.
이 계정은 OAuth role이라 일반 비밀번호를 받지 않음.

### 해결
**Native Postgres Password role을 별도로 생성:**

```sql
-- Lakebase SQL Editor에서 실행 (q_bank DB 선택!)
CREATE ROLE q_bank_app WITH LOGIN PASSWORD 'QBank2026!';
GRANT ALL PRIVILEGES ON DATABASE q_bank TO q_bank_app;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO q_bank_app;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO q_bank_app;
```

그리고 앱 설정에서 DB 사용자 변경:

```yaml
# 변경 전 (OAuth role - 비밀번호 로그인 불가)
- name: DB_USER
  value: "jimin.ahn@data-dynamics.io"

# 변경 후 (Password role - 비밀번호 로그인 가능)
- name: DB_USER
  value: "q_bank_app"
```

### 왜 미리 못 잡았나
> **2부에서 설명한 "왜 계정이 3개 필요한가"의 핵심**.
> 일반적인 PostgreSQL에서는 계정 하나로 다 되는데, Lakebase는 OAuth role과 Password role이 분리되어 있다.
> Lakebase 계정 생성 시점에 이 구분을 설명하고, 앱용 Password role 생성을 먼저 안내했어야 했다.
> "사람 계정으로 앱도 연결하면 되겠지"라는 가정이 잘못이었다.

---

## 에러 4: SSL 연결 필수

```
FATAL: Invalid protocol version. Protocol version: 196608
DETAIL: Ensure that connection is using SSL. Try using `sslmode=require` in the connection string.
```

### 원인
Lakebase는 **모든 연결에 SSL 필수**. 기존 코드는 SSL 없이 연결 시도.

### 해결
`backend.py`에서 localhost가 아닌 경우 자동으로 SSL 추가:

```python
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

- **로컬 (localhost)**: SSL 없이 연결
- **Lakebase (원격)**: SSL 필수로 연결

### 왜 미리 못 잡았나
> 클라우드 managed DB가 SSL을 강제한다는 건 상식적인 부분이다.
> Lakebase 연결 설정을 할 때 **첫 번째로** sslmode=require를 추가했어야 했다.
> 이건 순수하게 내가 놓친 것이다.

---

# 4부: Phase 2 — Databricks App 수동 배포

소스코드를 Databricks Workspace에 올리고, App을 배포하는 과정.

---

## 에러 5: `password authentication failed for user 'q_bank_app'`

```
OperationalError: password authentication failed for user 'q_bank_app'
```

### 원인
`app.yaml`에서 `valueFrom`으로 Databricks Secret을 읽으려 했지만 동작하지 않았음.

```yaml
# 이렇게 하면 Secret에서 읽어와야 하는데, 동작하지 않았음
- name: DB_PASSWORD
  valueFrom: "q-bank.DB_PASSWORD"
```

### 해결
비밀번호를 `value`로 직접 넣어서 확인 후, 나중에 CI/CD에서 Secret 방식으로 전환:

```yaml
# 임시 해결 (동작 확인용)
- name: DB_PASSWORD
  value: "QBank2026!"
```

> **최종적으로는** CI/CD가 `valueFrom`을 사용하고, app.yaml에는 이 설정이 그대로 남아있다.
> 앱이 정상 동작하는 것을 보면 `valueFrom`이 최종적으로는 동작한 것이다.

### 왜 미리 못 잡았나
> `valueFrom`의 동작 조건을 정확히 파악하지 못했다.
> Databricks Secret scope에 값이 먼저 존재해야 하고, scope 이름과 key 이름이 정확해야 한다.
> 수동 배포 시점에는 Secret scope에 값을 아직 안 넣었을 수도 있었다.

---

## 에러 6: `permission denied for schema public`

```
InsufficientPrivilege: permission denied for schema public
LINE 2: CREATE TABLE IF NOT EXISTS exam_results (
```

### 원인
앱이 시작할 때 `exam_results` 테이블이 없으면 자동으로 만드는데,
`q_bank_app` 계정에 **테이블을 만들 권한이 없어서** 거부됨.

### 비유
카페에서 "커피 주세요"는 할 수 있는데 (SELECT),
"새 메뉴 추가해주세요"는 직원만 할 수 있는 것처럼 (CREATE TABLE),
`q_bank_app`은 아직 "손님" 수준.

### 해결
Lakebase SQL Editor에서 **반드시 DB를 `q_bank`으로 선택한 상태에서** 실행:

```sql
-- q_bank_app에게 public 스키마의 모든 권한 부여
GRANT ALL ON SCHEMA public TO q_bank_app;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO q_bank_app;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO q_bank_app;

-- 앞으로 새로 만들어지는 테이블/시퀀스에도 자동으로 권한 부여
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO q_bank_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO q_bank_app;
```

#### SQL 각 줄 설명

| SQL | 쉬운 설명 |
|-----|----------|
| `GRANT ALL ON SCHEMA public` | "public 스키마에서 뭐든 해도 돼" |
| `GRANT ALL ON ALL TABLES` | "이미 있는 테이블 전부 읽고 쓰고 지워도 돼" |
| `GRANT ALL ON ALL SEQUENCES` | "자동 증가 번호(ID) 사용해도 돼" |
| `ALTER DEFAULT PRIVILEGES ... TABLES` | "앞으로 새로 만들어지는 테이블도 자동으로 권한 줄게" |
| `ALTER DEFAULT PRIVILEGES ... SEQUENCES` | "앞으로 새로 만들어지는 시퀀스도 자동으로 권한 줄게" |

#### 초보자가 자주 실수하는 점

**SQL Editor에서 DB 선택을 안 바꾸고 실행하는 것!**

```
SQL Editor 상단 드롭다운:
  [databricks_postgres ▼]  ← 이걸로 되어있으면 안 됨!
  [q_bank ▼]               ← 반드시 이걸로 바꿔야 함!
```

### 왜 미리 못 잡았나
> 에러 3에서 `q_bank_app` role을 만들 때 DB와 테이블 권한은 줬지만,
> **스키마(public) 자체에 대한 권한**을 빠뜨렸다.
> PostgreSQL에서는 테이블 권한과 스키마 권한이 별개인데, 이걸 놓쳤다.
> role 생성 시 GRANT 문을 더 꼼꼼하게 작성했어야 했다.

---

## 에러 7: Databricks PAT 토큰 권한 부족

```
Error: Provided PAT token does not have required scopes: apps
Error: Provided PAT token does not have required scopes: workspace
```

### 원인
Databricks PAT(`dapi...`)는 생성 시점에 Apps/Workspace scope가 포함되지 않을 수 있음.

### 해결
PAT 대신 **OAuth 인증** 사용:

```bash
# OAuth 프로필 생성 (브라우저가 열리고 로그인)
databricks auth login --host https://ddbx-serverless.cloud.databricks.com --profile oauth

# 이후 모든 명령에 --profile oauth 붙이기
databricks workspace import-dir ./frontend /Workspace/... --overwrite --profile oauth
databricks apps deploy q-bank --source-code-path /Workspace/... --profile oauth
```

### 왜 미리 못 잡았나
> PAT 토큰의 scope 제한을 확인하지 않았다.
> PAT은 생성할 때 scope를 제한할 수 있는데, 기본 PAT에 Apps/Workspace가 빠져있을 수 있다.
> OAuth 인증이 더 넓은 권한을 가진다는 것을 먼저 안내했어야 했다.

---

## 에러 8: Windows Git Bash 경로 변환 문제

```
ls: cannot access 'C:/Program Files/Git/var/tmp/': No such file or directory
```

### 원인
Git Bash가 Linux 경로(`/tmp`, `/var`)를 Windows Git 설치 경로로 자동 변환.

### 해결
`MSYS_NO_PATHCONV=1` 환경변수로 경로 변환 비활성화:

```bash
# ❌ 안 됨
docker exec q_bank_db ls /tmp/dump.sql

# ✅ 됨
MSYS_NO_PATHCONV=1 docker exec q_bank_db ls /tmp/dump.sql
```

### 왜 미리 못 잡았나
> Windows Git Bash 환경 특유의 문제. Docker 명령에 Linux 경로를 넘길 때 발생한다.
> Windows 개발 환경에서 Docker를 사용할 때의 함정으로, 경험하지 않으면 예측하기 어렵다.
> Windows + Docker + Git Bash 조합에서는 이 문제를 미리 언급했어야 했다.

---

# 5부: Phase 3 — CI/CD 자동배포

`git push origin master` → GitHub Actions → Databricks App 자동 배포.

## CI/CD가 하는 일

```yaml
# .github/workflows/deploy.yml 의 6단계

Step 1: 코드 checkout (git clone)
Step 2: Databricks CLI 설치
Step 3: app.yaml의 placeholder를 실제 값으로 치환 (sed)
Step 4: DB 비밀번호를 Databricks Secret에 저장
Step 5: 소스코드를 Databricks Workspace에 업로드
Step 6: Databricks App 배포
```

## 인증 방식: 서비스 프린시플 OAuth (M2M)

```yaml
# deploy.yml
env:
  DATABRICKS_HOST: ${{ secrets.DATABRICKS_HOST }}
  DATABRICKS_CLIENT_ID: ${{ secrets.DATABRICKS_CLIENT_ID }}
  DATABRICKS_CLIENT_SECRET: ${{ secrets.DATABRICKS_CLIENT_SECRET }}
```

Databricks CLI는 이 3개 환경변수가 있으면 자동으로 OAuth M2M 인증.

## 비밀번호를 코드에 안 넣는 방법

```
문제: app.yaml에 비밀번호를 넣으면 GitHub에 올라감 (위험!)

해결: placeholder + CI/CD 치환

app.yaml (GitHub에 올라가는 것):
  DB_HOST: "your-lakebase-host"      ← 가짜 값
  DB_USER: "your-lakebase-user"      ← 가짜 값
  DB_PASSWORD: valueFrom "q-bank.DB_PASSWORD"  ← Databricks Secret에서 읽음

CI/CD가 배포할 때:
  1. sed로 가짜 값 → 진짜 값 치환
  2. DB_PASSWORD는 Databricks Secret에 저장

이렇게 하면 GitHub에는 가짜 값만 올라가고, 진짜 값은 GitHub Secrets에만 존재.
```

## GitHub Secrets 전체 목록

| Name | Value | 설명 |
|------|-------|------|
| `DATABRICKS_HOST` | `https://ddbx-serverless.cloud.databricks.com` | 워크스페이스 URL |
| `DATABRICKS_CLIENT_ID` | (SP Client ID) | 서비스 프린시플 인증용 |
| `DATABRICKS_CLIENT_SECRET` | (SP Client Secret) | 서비스 프린시플 인증용 |
| `DATABRICKS_USER` | `jimin.ahn@data-dynamics.io` | Workspace 경로 구성용 |
| `DATABRICKS_APP_NAME` | `q-bank` | 배포할 앱 이름 |
| `DB_HOST` | `ep-plain-mode-d2osyuep.database.us-east-1.cloud.databricks.com` | Lakebase 호스트 |
| `DB_USER` | `q_bank_app` | DB 계정 (Password role) |
| `DB_PASSWORD` | `QBank2026!` | DB 비밀번호 |

---

## CI/CD 에러 9: `invalid character " " in host name`

```
Error: parse "***  ": invalid character " " in host name
```

### 원인
GitHub Secrets에 값을 등록할 때 **앞뒤에 보이지 않는 공백이 포함**됨.
예: `https://ddbx-serverless.cloud.databricks.com ` ← 끝에 공백!

### 해결
Secret을 **삭제하고 다시 등록**. 복사할 때 앞뒤 공백 없이!

> **팁:** Secret 값을 붙여넣은 후 `Home` → `Shift+End`로 전체 선택해서 공백 확인.

### 왜 미리 못 잡았나
> GitHub Secrets 등록 시 "앞뒤 공백을 제거하라"는 주의사항을 안내하지 않았다.
> 웹 입력 필드에서 복사-붙여넣기 할 때 공백이 들어가는 건 매우 흔한 일인데,
> GitHub은 이걸 자동으로 trim하지 않는다. 이건 사전에 경고했어야 했다.

---

## CI/CD 에러 10: `cannot configure default credentials`

```
Error: default auth: cannot configure default credentials
Config: host=***, client_id=***, client_secret=***
```

### 원인
1. Secret 값에 공백이 포함되어 인증 실패
2. 또는 OAuth Secret이 만료/무효

### 해결
1. `DATABRICKS_CLIENT_ID`, `DATABRICKS_CLIENT_SECRET` Secret 재등록 (공백 제거)
2. 필요 시 Databricks에서 OAuth Secret 재발급:
   - Admin Settings → Service principals → SP 클릭 → OAuth secrets → Generate secret

---

## CI/CD 에러 11: `does not have secret-scopes.secrets/put permission`

```
Error: User *** does not have secret-scopes.secrets/put permission on scope ***
```

### 원인
SP가 Databricks에 로그인은 성공했지만, Secret scope에 비밀번호를 저장할 **권한이 없음**.
(2부에서 설명한 **🔑 권한 1: Secret scope** 부재)

### 비유
회사 건물에 출입증으로 들어왔는데 (로그인 성공),
금고 방에 들어가서 물건을 넣을 권한이 없는 상태.

### 해결
```bash
databricks secrets put-acl q-bank <SP-client-id> MANAGE --profile oauth
```

- `q-bank`: Secret scope 이름
- `<SP-client-id>`: 서비스 프린시플의 Client ID
- `MANAGE`: 읽기+쓰기+관리 전체 권한
- `--profile oauth`: 관리자(사람) 계정으로 실행

### 왜 미리 못 잡았나
> SP를 만들면 기본적으로 아무 권한도 없다는 것을 알았어야 했다.
> SP 생성 직후에 "3가지 권한을 전부 줘야 한다"는 체크리스트를 제시했어야 했다.
> 하나씩 에러가 나고 → 하나씩 해결하는 방식이 아니라,
> 처음부터 전부 설정했어야 했다.

---

## CI/CD 에러 12: `accepts 2 arg(s), received 3`

```
Run databricks workspace import-dir ./frontend \
Error: accepts 2 arg(s), received 3
```

### 원인
`DATABRICKS_USER` Secret 값에 공백이 있어서 경로가 쪼개짐:

```
# Secret 값: "jimin.ahn@data-dynamics.io " (끝에 공백!)
# 결과:
databricks workspace import-dir ./frontend /Workspace/Users/jimin.ahn@data-dynamics.io /apps/q_bank
                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ^^^^^^^^^^^^^
                                           인자 2 (여기서 잘림)                          인자 3 (생김!)
```

### 해결

**방법 1: Secret 값의 공백 제거** (근본 해결)

**방법 2: deploy.yml에서 따옴표로 감싸기** (방어적 코딩)
```yaml
# 변경 전 (여러 줄, 따옴표 없음 - 위험)
run: |
  databricks workspace import-dir ./frontend \
    /Workspace/Users/${{ secrets.DATABRICKS_USER }}/apps/q_bank \
    --overwrite

# 변경 후 (한 줄, 따옴표 있음 - 안전)
run: databricks workspace import-dir ./frontend "/Workspace/Users/${{ secrets.DATABRICKS_USER }}/apps/q_bank" --overwrite
```

### 왜 미리 못 잡았나
> deploy.yml 작성 시 경로를 따옴표로 감싸는 방어적 코딩을 하지 않았다.
> GitHub Secrets 값에 공백이 들어올 수 있다는 것을 고려해서,
> 처음부터 모든 Secret 참조를 따옴표로 감쌌어야 했다.

---

## CI/CD 에러 13: `no such directory`

```
Error: no such directory: /Workspace/Users/***/apps/q_bank
```

### 원인
SP가 해당 Workspace 폴더를 **볼 수는 있지만 쓸 수 없어서** 에러.
(2부에서 설명한 **🔑 권한 2: Workspace 폴더** 부재)

### 비유
친구 집 주소는 아는데, 현관문 비밀번호를 몰라서 못 들어가는 상태.

### 해결
```bash
# 1. 폴더의 object_id 확인
databricks workspace get-status "/Workspace/Users/jimin.ahn@data-dynamics.io/apps/q_bank" --profile oauth -o json
# → object_id: 3059263319220889

# 2. SP에 CAN_MANAGE 권한 부여
databricks api patch /api/2.0/permissions/directories/3059263319220889 \
  --json '{"access_control_list":[{"service_principal_name":"<SP-client-id>","permission_level":"CAN_MANAGE"}]}' \
  --profile oauth
```

### 왜 미리 못 잡았나
> 에러 11과 같은 이유. SP 생성 시 3가지 권한을 한 번에 설정하지 않았다.
> 특히 이 에러 메시지가 "no such directory"라서 **권한 문제가 아니라 폴더가 없는 것처럼 보인다**.
> Databricks가 권한 없음을 "디렉토리 없음"으로 표시하는 것이 혼란을 야기했다.

---

## CI/CD 에러 14: Re-run했는데 같은 에러 반복

### 원인
코드를 고쳐서 push했는데, GitHub Actions에서 **Re-run all jobs**를 누르면
**고치기 전 코드**로 다시 실행됨.

```
commit A (버그 있음) → Actions 실행 → 실패
commit B (버그 수정) → push 완료
commit A의 실패 run → Re-run 클릭 → commit A로 다시 실행 → 또 실패!
```

### 해결
**Re-run** 대신 **Run workflow** 버튼으로 새로 실행:

1. GitHub Actions → 왼쪽 **Deploy to Databricks Apps (prod)** 클릭
2. 오른쪽 **Run workflow** 드롭다운 → Branch: `master` → **Run workflow**
3. 최신 commit 기준으로 실행됨

> `workflow_dispatch`가 deploy.yml에 설정되어 있어야 이 버튼이 보임.

### 왜 미리 못 잡았나
> GitHub Actions의 Re-run 동작을 정확히 설명하지 않았다.
> "Re-run은 해당 시점의 commit으로 실행된다"는 것을 미리 안내했어야 했다.

---

## CI/CD 에러 15: `App with name *** does not exist`

```
Error: App with name "q-bank " does not exist
```

### 원인
`DATABRICKS_APP_NAME` Secret 값 끝에 공백이 있어서 `"q-bank "` ≠ `"q-bank"`.

### 비유
카페에서 "아메리카노 "라고 주문표에 적었는데,
바리스타가 "아메리카노 라는 메뉴는 없는데요?" 하는 상황.

### 해결
Secret 삭제 후 공백 없이 재등록.

### 이 프로젝트에서 공백 때문에 발생한 에러 4개

| # | 어떤 Secret | 어떤 에러 |
|---|-----------|----------|
| 9 | `DATABRICKS_HOST` | URL 파싱 실패 |
| 10 | `DATABRICKS_CLIENT_SECRET` | 인증 실패 |
| 12 | `DATABRICKS_USER` | 경로 쪼개짐 |
| 15 | `DATABRICKS_APP_NAME` | 앱 못 찾음 |

> **결론: GitHub Secrets 등록할 때 무조건 공백 확인. 이건 규칙으로 삼자.**

### 왜 미리 못 잡았나
> 에러 9에서 이미 공백 문제를 겪었으면서, 나머지 Secret도 전부 공백 검증을 하자고 제안하지 않았다.
> 에러 9 해결 시점에 "**모든 Secret을 한 번에 공백 검증하자**"고 했어야 했다.
> 한 곳에서 문제가 발견되면 같은 유형의 문제가 다른 곳에도 있을 확률이 높다.

---

## CI/CD 에러 16: `assign the user CAN_MANAGE permission for the app`

```
Error: User (Service Principal) *** does not have permission to deploy app q-bank.
Please assign the user CAN_MANAGE permission for the app.
```

### 원인
SP가 로그인 성공, Secret 저장 성공, Workspace 업로드 성공까지 했는데,
마지막 단계인 **앱 배포 권한이 없어서** 실패.
(2부에서 설명한 **🔑 권한 3: App 배포** 부재)

### 비유
신입사원이 출근해서 (로그인 ✓), 금고에 서류 넣고 (Secret ✓),
사무실에 짐도 풀었는데 (Workspace ✓), "배포 버튼" 누를 권한이 없는 상태 (App ✗).

### 해결
```bash
databricks api patch /api/2.0/permissions/apps/q-bank \
  --json '{"access_control_list":[{"service_principal_name":"<SP-client-id>","permission_level":"CAN_MANAGE"}]}' \
  --profile oauth
```

### SP 3가지 권한 체크리스트 (최종)

```
✅ 1. Secret scope "q-bank" → MANAGE
✅ 2. Workspace 폴더 → CAN_MANAGE
✅ 3. App "q-bank" → CAN_MANAGE

→ 3개 전부 있어야 CI/CD 성공!
```

### 왜 미리 못 잡았나
> **같은 실수를 3번 반복했다** (에러 11 → 13 → 16).
> "SP에 권한이 없다" → "해당 권한 추가" → "다음 단계에서 또 권한 없다" 반복.
> SP를 만들자마자 **3가지 권한을 전부 한 번에 설정하는 스크립트**를 만들었어야 했다.
> 이런 패턴을 겪었으면 "또 다음 단계에서 권한 문제가 있을 수 있다"고 예측했어야 했다.

---

# 6부: 에러 총정리 + 핵심 교훈

## 전체 에러 한눈에 보기

### Phase 1: DB 마이그레이션 에러

| # | 에러 메시지 | 한 줄 원인 | 한 줄 해결 |
|---|-----------|----------|----------|
| 1 | `psql: 용어가 인식되지 않습니다` | Windows에 psql 미설치 | Docker 안의 psql 사용 |
| 2 | `not a valid JWT` (psql) | Lakebase에 PAT 사용 불가 | OAuth JWT 토큰 사용 |
| 3 | `not a valid JWT` (앱) | OAuth role에 일반 비밀번호 사용 | Password role 별도 생성 |
| 4 | `Invalid protocol version... SSL` | Lakebase SSL 필수 | `sslmode=require` 자동 감지 |

### Phase 2: 수동 배포 에러

| # | 에러 메시지 | 한 줄 원인 | 한 줄 해결 |
|---|-----------|----------|----------|
| 5 | `password authentication failed` | `valueFrom` Secret 읽기 실패 | `value`로 직접 입력 (임시) |
| 6 | `permission denied for schema public` | DB 스키마 권한 없음 | GRANT ALL ON SCHEMA 실행 |
| 7 | `PAT does not have required scopes` | PAT에 Apps/Workspace 없음 | OAuth 인증으로 전환 |
| 8 | Windows 경로 변환 | Git Bash가 경로 자동 변환 | `MSYS_NO_PATHCONV=1` |

### Phase 3: CI/CD 에러

| # | 에러 메시지 | 한 줄 원인 | 한 줄 해결 |
|---|-----------|----------|----------|
| 9 | `invalid character " " in host name` | Secret에 공백 | 공백 없이 재등록 |
| 10 | `cannot configure default credentials` | Secret 공백 또는 OAuth 만료 | 재등록 + 필요 시 재발급 |
| 11 | `secret-scopes.secrets/put permission` | SP에 Secret scope 권한 없음 | `put-acl MANAGE` |
| 12 | `accepts 2 arg(s), received 3` | Secret 공백으로 경로 쪼개짐 | 공백 제거 + 따옴표 |
| 13 | `no such directory` | SP에 Workspace 폴더 권한 없음 | 폴더 CAN_MANAGE |
| 14 | Re-run 같은 에러 반복 | 이전 commit으로 Re-run됨 | Run workflow 사용 |
| 15 | `App with name *** does not exist` | App 이름 Secret에 공백 | 공백 없이 재등록 |
| 16 | `CAN_MANAGE permission for the app` | SP에 앱 배포 권한 없음 | 앱 CAN_MANAGE |

---

## 핵심 교훈 3가지

### 교훈 1: GitHub Secrets 공백은 보이지 않는 적

> 에러 17개 중 4개가 **공백 하나** 때문에 발생.
> GitHub Secrets는 복사-붙여넣기 시 공백을 자동 제거하지 않는다.
>
> **규칙:** Secret 등록할 때 `Home` → `Shift+End`로 전체 선택해서 공백 확인.
> 하나에서 공백 문제가 발견되면 **나머지 전부** 확인할 것.

### 교훈 2: 서비스 프린시플은 만들기만 하면 아무것도 못 함

> SP를 만들면 "빈 출입증"만 발급된 것.
> **3가지 권한을 전부 줘야** 실제로 동작함:
> 1. Secret scope MANAGE
> 2. Workspace 폴더 CAN_MANAGE
> 3. App CAN_MANAGE
>
> **규칙:** SP 생성 직후 3가지 권한을 **한 번에** 설정할 것.

### 교훈 3: 계정은 역할별로 분리

> 사람 계정, 앱 계정, CI/CD 계정은 각각 다른 인증 방식과 권한을 가진다.
> 하나의 계정으로 다 하려고 하면 반드시 문제가 생긴다.
>
> | 누가 | 어떤 계정 | 어떤 인증 |
> |------|----------|----------|
> | 사람 | OAuth role | JWT 토큰 (1시간) |
> | 앱 | Password role | 일반 비밀번호 |
> | CI/CD | Service Principal | Client ID + Secret |

---

## GitHub Secrets 최종 체크리스트

| Name | Value | 공백 확인 |
|------|-------|----------|
| `DATABRICKS_HOST` | `https://ddbx-serverless.cloud.databricks.com` | 앞뒤 공백 없이! |
| `DATABRICKS_CLIENT_ID` | `4abe3da9-f69d-4821-be1e-74cce377deda` | 앞뒤 공백 없이! |
| `DATABRICKS_CLIENT_SECRET` | (SP OAuth Secret) | 앞뒤 공백 없이! |
| `DATABRICKS_USER` | `jimin.ahn@data-dynamics.io` | 앞뒤 공백 없이! |
| `DATABRICKS_APP_NAME` | `q-bank` | 앞뒤 공백 없이! |
| `DB_HOST` | `ep-plain-mode-d2osyuep.database.us-east-1.cloud.databricks.com` | 앞뒤 공백 없이! |
| `DB_USER` | `q_bank_app` | 앞뒤 공백 없이! |
| `DB_PASSWORD` | `QBank2026!` | 앞뒤 공백 없이! |

---

# 7부: 최종 성공 구성

## 프로젝트 구조

```
frontend/
├── app.yaml          # Databricks App 설정 (placeholder → CI/CD가 치환)
├── app.py            # Streamlit 라우터
├── backend.py        # DB 연결 (SSL 자동 감지)
├── .env              # 로컬 개발용 (gitignore)
└── views/            # 페이지별 UI

.github/workflows/
└── deploy.yml        # CI/CD (SP OAuth M2M 인증)
```

## 배포 흐름

```
개발자: git push origin master
         │
         ▼
GitHub Actions 자동 시작
  │
  ├── 1. 코드 checkout
  ├── 2. Databricks CLI 설치 (SP OAuth 자동 인증)
  ├── 3. app.yaml placeholder → 실제 값 치환 (sed)
  │       your-lakebase-host → ep-plain-mode-...
  │       your-lakebase-user → q_bank_app
  ├── 4. DB 비밀번호 → Databricks Secret에 저장
  ├── 5. 소스코드 → Databricks Workspace에 업로드
  └── 6. databricks apps deploy → 앱 재배포
         │
         ▼
Databricks App 자동 재시작
  │
  ├── DB_HOST, DB_USER → app.yaml에서 읽음 (치환된 값)
  ├── DB_PASSWORD → Databricks Secret에서 읽음 (valueFrom)
  └── sslmode=require → backend.py가 자동 추가
         │
         ▼
브라우저에서 앱 접속 → 문제 풀기 가능!
```

## 수동 배포 (필요 시)

```bash
# 1. OAuth 로그인
databricks auth login --host https://ddbx-serverless.cloud.databricks.com --profile oauth

# 2. 소스 업로드
databricks workspace import-dir ./frontend \
  "/Workspace/Users/jimin.ahn@data-dynamics.io/apps/q_bank" \
  --overwrite --profile oauth

# 3. 앱 배포
databricks apps deploy q-bank \
  --source-code-path "/Workspace/Users/jimin.ahn@data-dynamics.io/apps/q_bank" \
  --profile oauth
```

---

## 서비스 프린시플 생성 가이드 (다른 프로젝트에서도 참고)

### Step 1: SP 생성

1. Databricks 워크스페이스 → 우상단 프로필 → **Admin Settings**
2. **Service principals** → **Add service principal**
3. 이름 입력 (예: `q-bank-deploy`) → 저장
4. SP 클릭 → **OAuth secrets** → **Generate secret**
5. **Client ID**와 **Client Secret** 복사 (Secret은 이때만 볼 수 있음!)

### Step 2: 3가지 권한 부여 (한 번에!)

```bash
# 관리자 계정으로 로그인
databricks auth login --host <WORKSPACE_URL> --profile oauth

# 🔑 권한 1: Secret scope
databricks secrets put-acl <scope-name> <SP-client-id> MANAGE --profile oauth

# 🔑 권한 2: Workspace 폴더
#   먼저 폴더 ID 확인:
databricks workspace get-status "<폴더경로>" --profile oauth -o json
#   권한 부여:
databricks api patch /api/2.0/permissions/directories/<폴더ID> \
  --json '{"access_control_list":[{"service_principal_name":"<SP-client-id>","permission_level":"CAN_MANAGE"}]}' \
  --profile oauth

# 🔑 권한 3: App
databricks api patch /api/2.0/permissions/apps/<앱이름> \
  --json '{"access_control_list":[{"service_principal_name":"<SP-client-id>","permission_level":"CAN_MANAGE"}]}' \
  --profile oauth
```

### Step 3: GitHub Secrets 등록

**공백 없이!** 등록 후 `Home` → `Shift+End`로 확인.

---

> 2026-04-17 작성. 에러 17개, 교훈 3가지, 반성 16개 포함.
