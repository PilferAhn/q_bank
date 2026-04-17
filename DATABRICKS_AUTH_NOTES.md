# Databricks 인증(Authentication) 완벽 정리

> OAuth, JWT, Token 종류별 비교 및 실무 가이드

---

## 목차

**Part 1 — 기초 개념 (먼저 읽기)**

1. [인증 방식 한눈에 보기](#1-인증-방식-한눈에-보기)
2. [OAuth 개요](#2-oauth-개요)
3. [JWT (JSON Web Token) 구조](#3-jwt-json-web-token-구조)
4. [Service Principal 완전 정복](#4-service-principal-완전-정복)

**Part 2 — 인증 방식 상세**

5. [Personal Access Token (PAT)](#5-personal-access-token-pat)
6. [OAuth U2M (User-to-Machine)](#6-oauth-u2m-user-to-machine)
7. [OAuth M2M (Machine-to-Machine)](#7-oauth-m2m-machine-to-machine)

**Part 3 — 심화 & 실무**

8. [토큰 수명(Lifetime) — 왜 1시간인가?](#8-토큰-수명lifetime--왜-1시간인가)
9. [토큰 비교표](#9-토큰-비교표)
10. [실무 시나리오별 추천](#10-실무-시나리오별-추천)
11. [보안 베스트 프랙티스](#11-보안-베스트-프랙티스)

---

## 읽는 순서 가이드

```
처음이라면 이 순서로 읽으세요:

Step 1 — "왜 OAuth인가?" 큰 그림 잡기
  → 1. 인증 방식 한눈에 보기
  → 2. OAuth 개요

Step 2 — 토큰과 주체 이해하기 (빌딩 블록)
  → 3. JWT — "토큰이 어떻게 생겼는가"
  → 4. Service Principal — "누가 인증하는가"

Step 3 — 구체적 인증 방식 (이제 전부 이해됨)
  → 5. PAT (가장 단순, 레거시)
  → 6. U2M (사람이 브라우저로)
  → 7. M2M (기계가 자동으로)

Step 4 — 왜 이렇게 설계되었는가
  → 8. 토큰 수명 — "왜 1시간?"

Step 5 — 실전
  → 9~11. 비교표, 시나리오별 추천, 보안
```

---

# Part 1 — 기초 개념

---

## 1. 인증 방식 한눈에 보기

```
┌─────────────────────────────────────────────────────┐
│                Databricks 인증 체계                    │
├─────────────┬───────────────┬───────────────────────┤
│   PAT       │  OAuth U2M    │     OAuth M2M         │
│  (레거시)    │ (사용자↔앱)   │   (서비스↔서비스)      │
├─────────────┼───────────────┼───────────────────────┤
│ 수동 생성    │ 브라우저 로그인 │  Client Credentials   │
│ 만료일 수동  │ 자동 갱신      │  자동 토큰 발급        │
│ 장기 유효    │ 단기 토큰      │  단기 JWT 토큰        │
└─────────────┴───────────────┴───────────────────────┘
```

Databricks는 **PAT를 레거시로 분류**하고 **OAuth 기반 인증을 권장**한다.

---

## 2. OAuth 개요

### OAuth 2.0이란?

- **인가(Authorization) 프레임워크** — 제3자 앱에 제한된 접근 권한을 안전하게 위임
- Databricks는 OAuth 2.0 표준을 따르며, **OIDC (OpenID Connect)** 도 지원

### Databricks에서 OAuth가 중요한 이유

1. **단기 토큰**: Access Token은 1시간 내외로 만료 → 유출 시 피해 최소화
2. **자동 갱신**: Refresh Token으로 사용자 개입 없이 토큰 재발급
3. **범위 제한**: Scope로 필요한 권한만 부여 가능
4. **표준화**: OAuth 2.0/OIDC 표준 → 기존 인프라와 통합 용이

### 핵심 용어

| 용어 | 설명 |
|------|------|
| **Authorization Server** | Databricks의 토큰 발급 서버 (`/oidc/v1/token`) |
| **Resource Server** | Databricks REST API 엔드포인트 |
| **Client** | API를 호출하는 앱/서비스 |
| **Access Token** | API 호출 시 사용하는 단기 토큰 (JWT 형태) |
| **Refresh Token** | Access Token 재발급용 장기 토큰 |
| **Scope** | 토큰이 접근 가능한 범위 (예: `clusters`, `sql`) |
| **Service Principal** | 사람이 아닌 시스템/앱을 위한 ID → [4장에서 상세 설명](#4-service-principal-완전-정복) |

---

## 3. JWT (JSON Web Token) 구조

> **왜 여기서?** — U2M, M2M 모두 Access Token이 JWT 형태이다.
> JWT가 뭔지 알아야 이후 인증 흐름이 이해된다.

Databricks OAuth가 발급하는 Access Token은 **JWT 형태**이다.

### JWT 기본 구조

```
eyJhbGciOi...  .  eyJzdWIiOi...  .  SflKxwRJSM...
 ───────────     ───────────────     ───────────────
   Header            Payload            Signature
```

세 파트가 `.`으로 구분되며, 각각 **Base64URL** 인코딩되어 있다.

### Header (헤더)

```json
{
  "alg": "RS256",       // 서명 알고리즘 (RSA + SHA-256)
  "typ": "JWT",         // 토큰 타입
  "kid": "key-id-123"   // 서명 검증용 공개키 ID
}
```

### Payload (페이로드) — Databricks 토큰 예시

```json
{
  // 표준 클레임 (Standard Claims)
  "iss": "https://<workspace>.databricks.com/oidc",  // 발급자 (Issuer)
  "sub": "1234567890",                                // 주체 (Subject) — 사용자/SP ID
  "aud": "https://<workspace>.databricks.com",        // 대상 (Audience)
  "exp": 1700000000,                                  // 만료 시간 (Unix timestamp)
  "iat": 1699996400,                                  // 발급 시간
  "jti": "unique-token-id",                           // 토큰 고유 ID

  // Databricks 커스텀 클레임
  "azp": "<client-id>",           // Authorized Party (OAuth Client ID)
  "scope": "all-apis",            // 허용된 범위
  "groups": ["admins", "users"]   // 그룹 멤버십 (선택적)
}
```

### Signature (서명)

```
RSASHA256(
  base64UrlEncode(header) + "." + base64UrlEncode(payload),
  privateKey
)
```

- Databricks Authorization Server의 **Private Key**로 서명
- API 서버는 대응하는 **Public Key**로 검증
- Public Key는 JWKS 엔드포인트에서 조회:
  ```
  GET https://<workspace>.databricks.com/oidc/v1/.well-known/jwks
  ```

### JWT vs Opaque Token 비교

| 항목 | JWT (OAuth Access Token) | Opaque Token (PAT) |
|------|-------------------------|---------------------|
| 형태 | 구조화된 JSON (디코딩 가능) | 랜덤 문자열 |
| 검증 | 토큰 자체에 정보 포함 → 서명 검증만으로 유효성 확인 | 서버에 매번 조회 필요 |
| 크기 | 상대적으로 큼 (~1KB) | 작음 (~40자) |
| 정보 | 발급자, 만료, 권한 등 포함 | 아무 정보도 없음 |
| 만료 | 토큰 안에 `exp` 명시 | 서버 DB에 저장 |
| 회수 | 만료 전까지 유효 (즉시 무효화 어려움) | 서버에서 즉시 삭제 가능 |

### JWT 디버깅

```bash
# jwt.io에서 디코딩하거나 CLI로 확인
echo "eyJhbGci..." | cut -d'.' -f2 | base64 -d 2>/dev/null | python -m json.tool
```

> **주의**: Access Token은 민감 정보이므로 외부 사이트(jwt.io 등)에 프로덕션 토큰을 붙여넣지 말 것

---

## 4. Service Principal 완전 정복

> **왜 여기서?** — M2M 인증은 Service Principal 없이 불가능하다.
> SP가 뭔지, 내부에 어떤 필드가 있는지 먼저 이해해야 M2M 흐름이 자연스럽게 읽힌다.

### 개념

- **사람이 아닌 애플리케이션/서비스를 위한 ID**
- 사람 계정을 공유하지 않고도 시스템이 Databricks에 접근 가능
- Azure AD 또는 Databricks Account Console에서 관리

### Service Principal vs 사용자 계정

| 항목 | 사용자 계정 | Service Principal |
|------|------------|-------------------|
| 주체 | 사람 | 앱/서비스 |
| 인증 | 비밀번호, SSO, MFA | OAuth Secret, 인증서 |
| 라이선스 | 필요 | 불필요 (대부분) |
| 용도 | 대화형 작업 | 자동화, CI/CD |
| 보안 | MFA 가능 | Secret 회전 |

### SP 내부 구성요소 상세

Service Principal을 생성하면 아래 필드들이 만들어진다:

```
┌─────────────────────────────────────────────────────────┐
│              Service Principal 내부 구조                  │
├──────────────────┬──────────────────────────────────────┤
│  Application ID  │  SP 고유 식별자 (= Client ID)         │
│  (client_id)     │  예: "12345678-abcd-efgh-ijkl-..."   │
│                  │  자동 생성, 변경 불가                   │
├──────────────────┼──────────────────────────────────────┤
│  Display Name    │  사람이 읽을 수 있는 이름               │
│                  │  예: "ci-cd-pipeline", "airflow-prod" │
├──────────────────┼──────────────────────────────────────┤
│  OAuth Secret    │  인증용 비밀 키 (= Client Secret)      │
│  (client_secret) │  예: "dose1234567890abcdef..."        │
│                  │  생성 시에만 확인 가능, 이후 조회 불가    │
│                  │  여러 개 발급 가능 (회전용)              │
├──────────────────┼──────────────────────────────────────┤
│  Auth Type       │  SP가 사용할 인증 방식                  │
│                  │  · oauth-m2m (Client Credentials) ← 권장│
│                  │  · pat (SP용 PAT) ← 레거시             │
├──────────────────┼──────────────────────────────────────┤
│  Permissions     │  SP에 부여된 권한 (Workspace/Account)  │
│                  │  · 그룹 멤버십 (admins, users 등)      │
│                  │  · ACL (클러스터, 잡, SQL 웨어하우스 등) │
├──────────────────┼──────────────────────────────────────┤
│  Status          │  Active / Deactivated                │
│                  │  비활성화하면 모든 토큰 즉시 무효화       │
└──────────────────┴──────────────────────────────────────┘
```

### 핵심 필드별 상세 설명

#### Client ID (= Application ID)

```
- SP의 "사용자 이름" 에 해당
- UUID 형태: "12345678-abcd-efgh-ijkl-000000000000"
- 공개 값 — 코드나 설정에 넣어도 보안 위험 낮음
- 토큰 요청 시 "나는 누구다"를 증명하는 식별자
- JWT payload의 "azp" 클레임에 기록됨
```

#### Client Secret (= OAuth Secret)

```
- SP의 "비밀번호" 에 해당
- 긴 랜덤 문자열: "dose1234567890abcdef..."
- 비밀 값 — 절대 코드에 하드코딩하지 말 것
- 생성 시점에만 확인 가능 (이후 다시 볼 수 없음)
- 하나의 SP에 여러 Secret 발급 가능 → 무중단 회전(rotation)에 활용

Secret 회전 패턴:
  1. 새 Secret 발급 (Secret #2)
  2. 앱에서 Secret #2로 전환
  3. 기존 Secret #1 삭제
  → 다운타임 없이 교체 완료
```

#### Auth Type (인증 방식)

SP가 Databricks에 인증하는 방식을 결정한다:

| Auth Type | 설명 | 권장 여부 |
|-----------|------|-----------|
| **`oauth-m2m`** | Client ID + Secret으로 Access Token(JWT) 발급 | **권장** |
| **`pat`** | SP 전용 PAT 수동 생성 | 레거시, 비권장 |

```
auth_type 선택 기준:

oauth-m2m (Client Credentials):
  ✅ 자동 토큰 갱신
  ✅ 단기 토큰 (1시간) → 유출 피해 최소
  ✅ Scope로 권한 세분화
  ✅ SDK가 자동 관리

pat (SP용 PAT):
  ❌ 수동 생성/갱신
  ❌ 장기 유효 → 유출 시 위험
  ❌ Scope 제한 불가
  ⚠️  레거시 시스템 호환용으로만 사용
```

### SDK/환경변수에서 SP 필드가 어떻게 매핑되는지

```python
# 명시적 방식
from databricks.sdk import WorkspaceClient

w = WorkspaceClient(
    host="https://<workspace>.databricks.com",  # Workspace URL
    client_id="12345678-abcd-...",               # ← Application ID
    client_secret="dose1234567890abcdef..."       # ← OAuth Secret
)
# auth_type은 client_id + client_secret이 있으면
# SDK가 자동으로 oauth-m2m (Client Credentials)으로 판단
```

```bash
# 환경변수 방식 (권장)
export DATABRICKS_HOST="https://<workspace>.databricks.com"
export DATABRICKS_CLIENT_ID="12345678-abcd-..."       # ← Application ID
export DATABRICKS_CLIENT_SECRET="dose1234567890..."    # ← OAuth Secret
# DATABRICKS_AUTH_TYPE은 보통 생략 가능 — SDK가 자동 감지
```

```ini
# ~/.databrickscfg 프로필 방식
[my-sp-profile]
host          = https://<workspace>.databricks.com
client_id     = 12345678-abcd-...
client_secret = dose1234567890...
auth_type     = databricks-oauth-m2m   # 명시적 지정도 가능
```

### Databricks SDK의 Auth Type 자동 감지 순서

SDK는 제공된 필드 조합으로 auth_type을 자동 판단한다:

```
제공된 필드                         → SDK가 선택하는 auth_type
──────────────────────────────────────────────────────────
token                              → pat
client_id + client_secret          → oauth-m2m (client-credentials)
(아무것도 없음, CLI 로그인 상태)     → oauth-u2m (authorization-code)
azure_client_id + azure_tenant_id  → azure-service-principal
google_credentials                 → google-credentials
```

> `auth_type`을 명시적으로 설정할 수도 있지만, 대부분 **자동 감지에 맡기는 것이 관례**이다.

### SP 생성부터 사용까지 전체 흐름

```
Step 1: SP 생성
  Account Console → User Management → Service Principals → Add
  → Display Name 지정 (예: "ci-cd-pipeline")
  → Application ID 자동 생성됨 (이것이 client_id)

Step 2: OAuth Secret 생성
  Service Principal 상세 → OAuth Secrets → Generate Secret
  → Client ID (= Application ID) 확인
  → Client Secret 발급 (이것이 client_secret)
  → ⚠️ Secret은 이 시점에만 확인 가능 → 즉시 저장!

Step 3: Workspace에 권한 부여
  Workspace → Admin Settings → Service Principals → Add
  → 그룹 추가 (예: users, admins)
  → 리소스별 ACL 설정 (클러스터, SQL 웨어하우스 등)

Step 4: 앱에서 사용
  → 환경변수에 DATABRICKS_CLIENT_ID, DATABRICKS_CLIENT_SECRET 설정
  → SDK가 자동으로 OAuth M2M 인증 수행
```

---

# Part 2 — 인증 방식 상세

---

## 5. Personal Access Token (PAT)

> 가장 단순하지만 가장 제한적인 방식. **레거시**로 분류되었지만 빠른 테스트에는 여전히 편리하다.

### 개념

- Databricks UI에서 수동으로 생성하는 **정적 문자열 토큰**
- `dapi`로 시작하는 긴 문자열 (예: `dapiXXXXXXXXXXXXXXXX`)
- HTTP 요청의 `Authorization: Bearer <PAT>` 헤더로 전달

### 생성 방법

```
Databricks Workspace → Settings → Developer → Access Tokens → Generate New Token
```

### 특징

| 항목 | 설명 |
|------|------|
| 형태 | 고정 문자열 (opaque token) |
| 만료 | 생성 시 수동 설정 (최대 무기한 가능) |
| 갱신 | 불가 — 만료되면 새로 생성 |
| 범위 | 해당 사용자의 모든 권한 |
| 회수 | UI에서 수동 삭제 |

### 사용 예시

```bash
# REST API 호출
curl -X GET "https://<workspace>.databricks.com/api/2.0/clusters/list" \
  -H "Authorization: Bearer dapi1234567890abcdef"
```

```python
# databricks-sdk
from databricks.sdk import WorkspaceClient
w = WorkspaceClient(
    host="https://<workspace>.databricks.com",
    token="dapi1234567890abcdef"
)
```

### 한계점

- **보안 위험**: 장기 유효 토큰이 유출되면 전체 workspace 접근 가능
- **권한 세분화 불가**: 토큰 자체에 scope 제한 없음 (사용자 전체 권한)
- **감사(Audit) 어려움**: 누가 어떤 목적으로 사용하는지 추적 곤란
- **자동 회전 없음**: 수동 관리 필요

---

## 6. OAuth U2M (User-to-Machine)

> **사전 지식**: [2. OAuth 개요](#2-oauth-개요), [3. JWT](#3-jwt-json-web-token-구조)

### 개념

- **사용자가 브라우저를 통해 로그인** → 앱이 사용자 대신 API 호출
- OAuth 2.0의 **Authorization Code Flow + PKCE** 사용
- CLI, 로컬 개발 도구, 노트북 등에서 사용

### 인증 흐름

```
┌──────────┐    1. 인증 요청     ┌──────────────────┐
│  사용자   │ ──────────────────→ │  Databricks      │
│  (브라우저)│                     │  Authorization   │
│          │ ←────────────────── │  Server          │
│          │  2. 로그인 페이지    │                  │
│          │ ──────────────────→ │                  │
│          │  3. ID/PW 입력      │                  │
│          │ ←────────────────── │                  │
│          │  4. Auth Code       │                  │
└──────────┘                     └──────────────────┘
      │                                   │
      │ 5. Auth Code + PKCE               │
      ▼                                   │
┌──────────┐                              │
│  Client  │ ──────────────────────────→  │
│  (앱)    │  6. Auth Code → Token 교환   │
│          │ ←────────────────────────── │
│          │  7. Access Token + Refresh   │
└──────────┘                              │
      │                                   │
      │ 8. API 호출 (Bearer Token)        │
      ▼                                   │
┌──────────────────┐                      │
│  Databricks API  │                      │
│  (Resource Srv)  │                      │
└──────────────────┘
```

### PKCE (Proof Key for Code Exchange)

- **Public Client**(비밀 키를 안전하게 저장할 수 없는 클라이언트)를 위한 보안 확장
- `code_verifier` → SHA256 해시 → `code_challenge` 생성
- Authorization Code 탈취해도 `code_verifier` 없으면 토큰 교환 불가

```
code_verifier  = 랜덤 문자열 (43~128자)
code_challenge = BASE64URL(SHA256(code_verifier))
```

### Databricks CLI에서 U2M 사용

```bash
# 프로필 설정
databricks auth login --host https://<workspace>.databricks.com

# 브라우저가 열리고 로그인 → 자동으로 토큰 저장
# ~/.databrickscfg 에 토큰 정보 저장됨

# 이후 CLI 명령은 자동으로 토큰 사용
databricks clusters list
```

### SDK에서 U2M 사용

```python
from databricks.sdk import WorkspaceClient

# 자동으로 ~/.databrickscfg 또는 환경변수에서 인증 정보 로드
w = WorkspaceClient(host="https://<workspace>.databricks.com")
clusters = w.clusters.list()
```

### 토큰 갱신 흐름

```
Access Token 만료 (보통 1시간)
      │
      ▼
Refresh Token으로 새 Access Token 요청
      │
      ▼
POST /oidc/v1/token
  grant_type=refresh_token
  refresh_token=<refresh_token>
      │
      ▼
새 Access Token + (선택적) 새 Refresh Token 수신
```

---

## 7. OAuth M2M (Machine-to-Machine)

> **사전 지식**: [2. OAuth 개요](#2-oauth-개요), [3. JWT](#3-jwt-json-web-token-구조), [4. Service Principal](#4-service-principal-완전-정복)

### 개념

- **사람이 관여하지 않는** 서비스 간 인증
- OAuth 2.0의 **Client Credentials Grant** 사용
- CI/CD 파이프라인, 자동화 스크립트, 백그라운드 잡에서 사용
- **Service Principal**의 `client_id` + `client_secret`으로 인증

### 인증 흐름

```
┌──────────────┐                    ┌──────────────────┐
│  Service     │  1. Client ID      │  Databricks      │
│  (CI/CD 등)  │  + Client Secret   │  Authorization   │
│              │ ──────────────────→ │  Server          │
│              │                     │                  │
│              │ ←────────────────── │  /oidc/v1/token  │
│              │  2. Access Token    │                  │
│              │     (JWT)           │                  │
└──────────────┘                    └──────────────────┘
       │
       │ 3. API 호출 (Bearer Token)
       ▼
┌──────────────────┐
│  Databricks API  │
└──────────────────┘
```

### 토큰 요청 시 전달하는 필드

```bash
curl -X POST "https://<workspace>.databricks.com/oidc/v1/token" \
  -d "grant_type=client_credentials" \    # ← 인증 방식: M2M
  -d "client_id=<client-id>" \            # ← SP의 Application ID
  -d "client_secret=<client-secret>" \    # ← SP의 OAuth Secret
  -d "scope=all-apis"                     # ← 접근 범위

# Account-level 엔드포인트도 가능:
# https://accounts.cloud.databricks.com/oidc/accounts/<account-id>/v1/token
```

각 필드의 역할:

| 필드 | 값 | 의미 |
|------|-----|------|
| `grant_type` | `client_credentials` | "나는 기계(SP)이고, ID+Secret으로 인증한다" |
| `client_id` | SP의 Application ID | "내 신원은 이것이다" |
| `client_secret` | SP의 OAuth Secret | "이것이 내 비밀번호다" |
| `scope` | `all-apis` 등 | "이 범위의 권한을 요청한다" |

### 응답 예시

```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "all-apis"
}
```

- `access_token`: JWT 형태의 단기 토큰 (→ [3장 JWT 구조](#3-jwt-json-web-token-구조) 참고)
- `expires_in`: 3600초 = **1시간** (→ [8장 토큰 수명](#8-토큰-수명lifetime--왜-1시간인가)에서 이유 설명)
- `token_type`: 항상 `Bearer` — API 호출 시 `Authorization: Bearer <token>` 형태로 사용

### SDK에서 M2M 사용

```python
from databricks.sdk import WorkspaceClient

w = WorkspaceClient(
    host="https://<workspace>.databricks.com",
    client_id="<service-principal-client-id>",
    client_secret="<service-principal-secret>"
)
```

```python
# 환경변수 방식 (권장)
# DATABRICKS_HOST=https://<workspace>.databricks.com
# DATABRICKS_CLIENT_ID=<client-id>
# DATABRICKS_CLIENT_SECRET=<client-secret>

w = WorkspaceClient()  # 자동으로 환경변수에서 로드
```

---

# Part 3 — 심화 & 실무

---

## 8. 토큰 수명(Lifetime) — 왜 1시간인가?

### 핵심 질문: "길게 줘도 되지 않나?"

직관적으로 보면 토큰 만료가 짧으면 불편하다. 왜 굳이 1시간으로 제한할까?

답은 **"토큰은 한번 발급되면 중간에 취소하기 어렵다"**는 JWT의 구조적 특성에 있다.

### JWT는 "자체 완결형" 토큰이다

```
┌──────────────────────────────────────────────────────────┐
│  PAT (Opaque Token)                                      │
│  ① 클라이언트가 토큰 제시                                  │
│  ② 서버가 DB에서 토큰 유효한지 매번 조회                     │
│  ③ DB에서 삭제하면 → 즉시 무효화 가능                       │
│                                                          │
│  JWT (Access Token)                                      │
│  ① 클라이언트가 토큰 제시                                  │
│  ② 서버가 서명만 검증 (DB 조회 없음)                        │
│  ③ DB에서 삭제해도 → 토큰 안의 exp까지 여전히 유효           │
└──────────────────────────────────────────────────────────┘
```

JWT는 서명 검증만으로 유효성을 확인하기 때문에:
- **장점**: DB 조회 없이 빠르게 인증 가능 (수만 개의 마이크로서비스가 독립적으로 검증)
- **단점**: 발급 후 "취소(revoke)"가 사실상 불가능 — **만료될 때까지 살아있다**

### 그래서 만료를 짧게 건다

```
토큰 유출 시 피해 범위 (Blast Radius)

PAT (만료 90일)
├── 유출 후 1시간:  공격자 접근 가능 ✗
├── 유출 후 1일:    공격자 접근 가능 ✗
├── 유출 후 30일:   공격자 접근 가능 ✗
└── 유출 후 90일:   비로소 만료됨

OAuth Access Token (만료 1시간)
├── 유출 후 1시간:  만료됨 ✓
└── 이후:           쓸모없는 문자열
```

**1시간은 "실용성과 보안의 타협점"**이다:
- 너무 짧으면 (예: 5분) → 갱신 요청이 너무 빈번, 네트워크 부하
- 너무 길면 (예: 24시간) → 유출 시 공격 가능 시간이 길어짐
- **업계 표준**: Google, Azure, AWS, Databricks 모두 Access Token 기본 수명 = **약 1시간**

### U2M과 M2M의 갱신 방식 차이

```
┌─────────────────────────────────────────────────────────┐
│                  U2M (User-to-Machine)                  │
│                                                         │
│  [Access Token] ──1시간 만료──→ 폐기                     │
│       ↑                                                 │
│  [Refresh Token] ───── 새 Access Token 자동 재발급       │
│       │                                                 │
│  Refresh Token 자체는 수명이 길다 (수일~수주)              │
│  만료되면? → 브라우저에서 다시 로그인 (사람이 개입)          │
│                                                         │
│  ✦ 왜 이 구조?                                          │
│    사람은 매시간 로그인하기 싫다.                           │
│    하지만 Access Token은 짧아야 안전하다.                  │
│    → Refresh Token이 "장기 세션"을 대행한다.              │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                  M2M (Machine-to-Machine)                │
│                                                         │
│  [Access Token] ──1시간 만료──→ 폐기                     │
│       ↑                                                 │
│  Client ID + Secret ─── 새 Access Token 재요청           │
│                                                         │
│  Refresh Token이 없다!                                   │
│  대신 Client Secret을 가지고 있으므로 언제든 새로 요청 가능  │
│                                                         │
│  ✦ 왜 이 구조?                                          │
│    기계는 브라우저를 열 수 없다 (사람 개입 불가).            │
│    하지만 Client Secret을 안전하게 보관할 수 있다.          │
│    → Secret이 곧 "영구 자격증명" 역할을 한다.              │
│    → Refresh Token이 별도로 필요 없다.                    │
└─────────────────────────────────────────────────────────┘
```

### Refresh Token은 왜 길게 줘도 괜찮은가?

| 항목 | Access Token | Refresh Token |
|------|-------------|---------------|
| **용도** | API 호출 시 매번 전송 | 토큰 갱신 시에만 전송 |
| **노출 빈도** | 매 요청마다 네트워크 타고 이동 | 갱신할 때만 (1시간에 1번) |
| **탈취 위험** | 높음 (매번 전송되므로) | 낮음 (사용 빈도가 극히 낮음) |
| **탈취 시 대응** | 즉시 취소 불가 (JWT 특성) | 서버 DB에서 즉시 무효화 가능 |
| **적절한 수명** | 짧게 (1시간) | 길게 (수일~수주) |

> Refresh Token은 **Opaque Token**(서버 DB에서 관리)이라 PAT처럼 즉시 취소할 수 있다.
> 그래서 길게 줘도 괜찮다 — 문제 발견 시 바로 끊을 수 있기 때문.

### 토큰 수명 설계 원칙 정리

```
보안 원칙                          실무 적용
─────────────────────────────────────────────────────
최소 권한 (Least Privilege)    →   Scope로 접근 범위 제한
최소 노출 (Least Exposure)    →   Access Token 수명 1시간
즉시 무효화 (Revocability)    →   Refresh Token은 서버측 관리
자동화 (Automation)           →   M2M은 Secret으로 무인 갱신
```

### 실무에서 체감하는 차이

```
PAT 시절의 워크플로우:
  1. 토큰 만들기 (UI에서 수동)
  2. .env에 복붙
  3. 90일 후 만료 → 앱 장애
  4. "누가 토큰 갱신 안 했어?" 슬랙 알림
  5. 다시 1번부터...

OAuth M2M 워크플로우:
  1. Service Principal + Secret 한 번 설정
  2. SDK가 자동으로 토큰 발급/갱신
  3. 만료? 알아서 재요청됨 → 장애 없음
  4. Secret 회전만 90일마다 하면 끝
```

---

## 9. 토큰 비교표

| 항목 | PAT | OAuth U2M | OAuth M2M |
|------|-----|-----------|-----------|
| **인증 주체** | 사용자 | 사용자 | Service Principal |
| **토큰 형태** | Opaque | JWT | JWT |
| **만료** | 수동 설정 (장기 가능) | ~1시간 (자동 갱신) | ~1시간 (재요청) |
| **갱신** | 불가 | Refresh Token | 새로 요청 |
| **브라우저 필요** | 아니오 (UI에서 생성만) | 예 (로그인) | 아니오 |
| **사람 개입** | 생성 시에만 | 최초 로그인 | 불필요 |
| **권한 세분화** | 불가 | Scope 지정 가능 | Scope 지정 가능 |
| **보안 수준** | 낮음 | 높음 | 높음 |
| **추천 용도** | 빠른 테스트 | CLI, 노트북, 로컬 개발 | CI/CD, 자동화, 프로덕션 |
| **Databricks 권장** | 비권장 (레거시) | 권장 | 권장 |

---

## 10. 실무 시나리오별 추천

### 로컬 개발 / CLI 사용

```
→ OAuth U2M
  - databricks auth login 으로 한 번 로그인
  - 이후 자동 토큰 관리
```

### CI/CD 파이프라인 (GitHub Actions, Jenkins 등)

```
→ OAuth M2M
  - Service Principal 생성
  - Client ID + Secret을 CI/CD 시크릿에 저장
  - 파이프라인 실행 시 자동 토큰 발급
```

```yaml
# GitHub Actions 예시
env:
  DATABRICKS_HOST: ${{ secrets.DATABRICKS_HOST }}
  DATABRICKS_CLIENT_ID: ${{ secrets.DATABRICKS_SP_CLIENT_ID }}
  DATABRICKS_CLIENT_SECRET: ${{ secrets.DATABRICKS_SP_SECRET }}
```

### Airflow / 스케줄러에서 Databricks Job 호출

```
→ OAuth M2M
  - Airflow Connection에 Service Principal 정보 설정
  - DatabricksRunNowOperator 등이 자동으로 토큰 관리
```

### Streamlit 앱에서 Databricks SQL 연결

```
→ OAuth M2M (백엔드 서비스이므로)
  - Service Principal의 Client ID/Secret을 .env에 저장
  - databricks-sql-connector가 OAuth 지원
```

```python
from databricks import sql

connection = sql.connect(
    server_hostname="<workspace>.databricks.com",
    http_path="/sql/1.0/warehouses/<warehouse-id>",
    client_id="<sp-client-id>",
    client_secret="<sp-secret>"
)
```

### 빠른 일회성 테스트

```
→ PAT (간편하지만 주의)
  - 짧은 만료 설정 필수
  - 테스트 후 즉시 삭제
```

---

## 11. 보안 베스트 프랙티스

### 토큰 관리

1. **PAT 사용 최소화** — OAuth로 전환 계획 수립
2. **Secret 회전 주기** — 90일 이내 권장
3. **최소 권한 원칙** — Scope를 필요한 범위로 제한
4. **환경변수 사용** — 코드에 토큰 하드코딩 절대 금지
5. **Vault 연동** — HashiCorp Vault, AWS Secrets Manager 등 활용

### Workspace 관리자

```
✅ DO:
- PAT 생성 제한 정책 설정 (Admin Console → Settings)
- PAT 최대 수명 제한 (예: 최대 30일)
- Service Principal별 OAuth Secret 추적
- 감사 로그(Audit Log) 모니터링

❌ DON'T:
- 사용자 PAT을 공유 계정처럼 사용
- Secret을 Slack/이메일로 전달
- 무기한 PAT 허용
```

### 감사(Audit)

Databricks는 모든 토큰 사용을 감사 로그에 기록:

```
- 토큰 생성/삭제 이벤트
- API 호출 시 어떤 토큰이 사용되었는지
- Service Principal별 활동 내역
```

---

## 부록: 용어 정리

| 약어 | 풀네임 | 설명 |
|------|--------|------|
| PAT | Personal Access Token | 개인 접근 토큰 |
| OAuth | Open Authorization | 인가 프레임워크 |
| OIDC | OpenID Connect | OAuth 위에 인증 레이어 |
| JWT | JSON Web Token | 구조화된 토큰 형식 |
| U2M | User-to-Machine | 사용자→머신 인증 |
| M2M | Machine-to-Machine | 머신→머신 인증 |
| PKCE | Proof Key for Code Exchange | Public Client 보안 확장 |
| SP | Service Principal | 서비스 주체 (비인간 ID) |
| JWKS | JSON Web Key Set | JWT 서명 검증용 공개키 세트 |
| RBAC | Role-Based Access Control | 역할 기반 접근 제어 |

---

*마지막 업데이트: 2026-04-17*
