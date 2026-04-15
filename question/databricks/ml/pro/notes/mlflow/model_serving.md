# MLflow Model Serving

## 상위 개념

```
MLflow
└── Model Serving
    ├── 자동 배포 Stage
    └── REST API 엔드포인트
```

## 정의

MLflow Model Registry에 등록된 모델을 REST API 엔드포인트로 자동 배포하는 Databricks 기능.

## 자동 배포 Stage (Q26)

Model Serving은 아래 3가지 Stage의 모델을 자동으로 서빙 엔드포인트에 배포한다:

| Stage | 자동 배포 |
|---|---|
| None | ✅ |
| Staging | ✅ |
| Production | ✅ |
| Archived | ❌ |

## REST API URI 형식 (Q32)

```
https://<databricks-host>/model/<model-name>/<stage>/invocations
```

```python
# 예시
url = "https://adb-xxx.azuredatabricks.net/model/recommender/Production/invocations"
```

- 경로: `/model/` (model-serving 아님)
- stage: `Production`, `Staging`, `None`
- 끝: `/invocations`

## 잘못된 URI 패턴

```
# ❌ model-serving 사용
https://<host>/model-serving/recommender/Production/invocations

# ❌ stage- 접두사 사용
https://<host>/model/recommender/stage-production/invocations

# ❌ 버전 번호 사용
https://<host>/model/recommender/1/invocations
```

## 관련 문제

- Q26: Model Serving 자동 배포 Stage → None, Staging, Production
- Q32: Production 모델 조회 URI → `https://<host>/model/<name>/Production/invocations`

## 실무 포인트

- Archived 모델은 자동 서빙에서 제외
- 버전 번호가 아닌 Stage명으로 엔드포인트가 결정됨
- 여러 버전이 같은 Stage에 있으면 가장 최신 버전이 서빙됨
