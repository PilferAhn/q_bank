# Git Workflow — 실제 운영 환경 기준

> 이 프로젝트(q_bank)를 팀으로 운영한다고 가정했을 때의 Git + CI/CD 워크플로우.
> 현재는 간소화 버전(master 직접 push)이지만, 실무에서는 아래 흐름을 따른다.

---

## 브랜치 전략

```
main (= production)          ← 실서비스. 여기에 직접 push 금지
  │
  ├── staging                ← 배포 전 최종 테스트. QA팀이 확인
  │
  └── feature/xxx            ← 개발자가 작업하는 브랜치
      develop/xxx
      fix/xxx
      hotfix/xxx
```

| 브랜치 | 누가 쓰나 | 배포 대상 | 직접 push |
|--------|----------|----------|----------|
| `main` | 아무도 직접 안 씀 | **Production** (실서비스) | **금지** |
| `staging` | PR merge로만 | **Staging** (테스트 서버) | 금지 |
| `feature/*` | 개발자 | 없음 (로컬만) | 자유 |

---

## 전체 흐름 (한 기능을 개발할 때)

```
                                    개발자 PC
                                    ─────────
Step 1.  git checkout -b feature/add-timer     ← 브랜치 생성
Step 2.  코드 수정 + 테스트
Step 3.  git push origin feature/add-timer     ← 원격에 올림
                │
                ▼
                                    GitHub
                                    ──────
Step 4.  PR 생성: feature/add-timer → staging
Step 5.  자동 검사 실행 (CI)
           ├── 린트 (코드 스타일)
           ├── 유닛 테스트
           └── 빌드 확인
Step 6.  동료가 코드 리뷰
           ├── "이 쿼리 N+1 문제 있어요" → 수정
           └── "LGTM 👍" → Approve
Step 7.  PR merge → staging 브랜치에 합쳐짐
                │
                ▼
                                    Staging 서버
                                    ─────────────
Step 8.  자동 배포 (CD): staging → Staging 환경
Step 9.  QA 테스트
           ├── 기능 동작 확인
           ├── 다른 기능 깨지지 않았는지 확인
           └── 성능 이상 없는지 확인
                │
                ▼ (문제 없으면)
                                    GitHub
                                    ──────
Step 10. PR 생성: staging → main
Step 11. 최종 Approve (팀장/리드)
Step 12. PR merge → main 브랜치에 합쳐짐
                │
                ▼
                                    Production 서버
                                    ────────────────
Step 13. 자동 배포 (CD): main → Production 환경
Step 14. 실서비스 동작 확인
```

---

## 각 단계를 이 프로젝트(q_bank)에 대입하면

### Step 1~3: 개발자가 코드 작성

```bash
# 새 기능: 시험에 타이머 추가
git checkout -b feature/add-timer

# 코드 수정
# frontend/views/exam_mode.py 에 타이머 로직 추가

# 로컬에서 테스트
cd frontend && streamlit run app.py

# 커밋 + 푸시
git add .
git commit -m "feat: 시험 모드에 타이머 추가"
git push origin feature/add-timer
```

### Step 4~7: PR + 코드 리뷰

```
GitHub에서:
  [New Pull Request]
  base: staging  ←  compare: feature/add-timer

  Title: "feat: 시험 모드에 타이머 추가"
  Description:
    - 시험 시작 시 60분 카운트다운
    - 시간 초과 시 자동 제출
    - 남은 시간 사이드바에 표시

  → 동료가 리뷰:
    "타이머 state가 새로고침하면 리셋되는데, session_state에 시작 시간 저장하면?"
  → 수정 후 재push
  → Approve → Merge
```

### Step 8~9: Staging에서 QA

```
staging에 merge되면 GitHub Actions가 자동 실행:
  → Databricks Staging App에 배포
  → QA팀(또는 본인)이 Staging URL에서 확인:
     ✅ 타이머 동작 OK
     ✅ 기존 연습 모드 깨지지 않음
     ✅ DB 연결 정상
```

### Step 10~14: Production 배포

```
staging → main PR 생성
  → 팀장 Approve
  → Merge
  → GitHub Actions가 자동으로 Production 배포
  → 실서비스 URL에서 최종 확인
```

---

## 긴급 수정 (Hotfix)

```
Production에서 버그 발견!
  "시험 제출 버튼 누르면 500 에러"

일반 흐름 (feature → staging → main) 은 너무 느림.
Hotfix는 빠른 경로를 탄다:

  git checkout -b hotfix/fix-submit-error main    ← main에서 직접 분기
  # 버그 수정
  git push origin hotfix/fix-submit-error

  PR: hotfix/fix-submit-error → main              ← staging 건너뜀
  → 긴급 리뷰 (1명 Approve면 OK)
  → Merge → 즉시 Production 배포

  그 다음:
  main → staging 역머지 (staging에도 수정사항 반영)
```

---

## CI/CD 파이프라인 (이 프로젝트 기준)

### deploy.yml이 2개가 된다

```yaml
# .github/workflows/deploy-staging.yml
name: Deploy to Staging
on:
  push:
    branches: [staging]
# → Databricks Staging App에 배포

# .github/workflows/deploy-prod.yml
name: Deploy to Production
on:
  push:
    branches: [main]
# → Databricks Production App에 배포
```

### Databricks 리소스도 2개

```
Staging 환경:
  App: q-bank-staging
  DB:  q_bank_staging (Lakebase)
  URL: https://q-bank-staging.databricks.app

Production 환경:
  App: q-bank
  DB:  q_bank (Lakebase)
  URL: https://q-bank.databricks.app
```

### GitHub Secrets도 환경별로 분리

```
GitHub → Settings → Environments

[staging] 환경:
  DATABRICKS_APP_NAME = q-bank-staging
  DB_HOST = (staging DB 호스트)
  DB_PASSWORD = (staging DB 비밀번호)
  ...

[prod] 환경:
  DATABRICKS_APP_NAME = q-bank
  DB_HOST = (prod DB 호스트)
  DB_PASSWORD = (prod DB 비밀번호)
  ...
```

---

## 브랜치 보호 규칙

GitHub → Settings → Branches → Branch protection rules

### `main` 브랜치

```
✅ Require pull request before merging
   ✅ Required approvals: 1 (최소 1명 리뷰)
✅ Require status checks to pass
   ✅ lint
   ✅ test
✅ Require branches to be up to date
❌ Allow force pushes                    ← 절대 금지
❌ Allow deletions                       ← 삭제 금지
```

### `staging` 브랜치

```
✅ Require pull request before merging
   ✅ Required approvals: 1
✅ Require status checks to pass
```

---

## 현재 우리 프로젝트 vs 실무 비교

| 항목 | 현재 (간소화) | 실무 |
|------|-------------|------|
| 브랜치 | `master` 하나 | `main` + `staging` + `feature/*` |
| 배포 트리거 | `master`에 push | `main`에 merge (PR 필수) |
| 코드 리뷰 | 없음 | PR에서 필수 |
| 테스트 | 수동 | CI에서 자동 |
| Staging | 없음 | 별도 환경에서 QA |
| 배포 환경 | 1개 (prod) | 2개 (staging + prod) |
| 롤백 | git revert + push | git revert + push (동일) |

> **지금은 혼자 개발하니까 간소화 버전이 맞다.**
> 팀이 2명 이상이 되면 staging + PR 필수로 전환하는 게 좋다.

---

## 한눈에 보기

```
개발자 → feature 브랜치 → PR → staging → QA 확인 → PR → main → Production
          (코드 작성)     (리뷰)  (테스트 서버)        (최종 승인)  (실서비스)

                    ↑ 개발자가 하는 것               ↑ 자동으로 되는 것
                    코드 작성 + PR 생성               CI/CD가 테스트 + 배포
```

**개발자는 코드를 쓰고 PR을 만든다. 나머지는 시스템이 한다.**
