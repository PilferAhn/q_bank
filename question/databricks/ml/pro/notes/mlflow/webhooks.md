# MLflow Registry Webhooks

## 상위 개념

```
MLflow
└── Model Registry
    └── Webhooks
        ├── HTTP Webhook
        └── Job Webhook
```

## 정의

Model Registry에서 특정 이벤트 발생 시 외부 시스템에 자동으로 알림을 보내는 기능.
CI/CD 트리거, Slack 알림 등에 활용된다.

## Webhook 종류

| 종류 | 용도 |
|---|---|
| **HTTP Webhook** | 외부 HTTP 엔드포인트 호출 (Slack, 외부 시스템 등) |
| **Job Webhook** | Databricks Job 자동 실행 |

### HTTP Webhook 사용 사례 (Q51)

- Slack 메시지 전송 (Slack Incoming Webhook URL로 HTTP POST)
- 외부 알림 시스템 연동

### Job Webhook 사용 사례

- 새 모델 버전 등록 시 테스트 Job 자동 실행

## 이벤트 종류 (Q56)

| 이벤트 | 트리거 조건 |
|---|---|
| `MODEL_VERSION_CREATED` | 새 버전 등록 |
| `MODEL_VERSION_TRANSITIONED_STAGE` | **임의의 스테이지 전환** |
| `MODEL_VERSION_TRANSITIONED_TO_STAGING` | Staging 전환 |
| `MODEL_VERSION_TRANSITIONED_TO_PRODUCTION` | Production 전환 |

모든 스테이지 전환에서 트리거하려면 `MODEL_VERSION_TRANSITIONED_STAGE` 사용.

## API 호출 (Q59)

```python
# Webhook 목록 조회
endpoint = "/api/2.0/mlflow/registry-webhooks/list"
method = "GET"    # 목록 조회는 GET (POST 아님)
```

## Webhook 트리거 조건 (Q60)

Webhook이 동작하려면 실제로 `transition_model_version_stage()`를 호출해야 한다.

```python
# Staging 전환 → Webhook 트리거
client.transition_model_version_stage(
    name=model,
    version=model_version,
    stage="Staging"
)
```

- `from`/`to` 파라미터는 존재하지 않음
- `transition_model_stage()`는 잘못된 메서드명

## CI/CD 연동 (Q38)

```
새 모델 버전 등록
    → MODEL_VERSION_CREATED Webhook 트리거
        → CI/CD 파이프라인 실행 (테스트, 검증)
            → 통과 시 Staging 전환
```

## 관련 문제

- Q38: CI/CD 트리거 → 새 모델 버전 등록 시
- Q51: HTTP Webhook 사용 사례 → Slack 메시지 전송
- Q56: 모든 스테이지 전환 트리거 이벤트 → `MODEL_VERSION_TRANSITIONED_STAGE`
- Q59: Webhook 목록 조회 API → POST → GET으로 변경
- Q60: Staging 전환 Webhook 트리거 → `transition_model_version_stage(..., stage="Staging")`

## 실무 포인트

- HTTP Webhook은 POST 요청을 외부 URL로 전송
- 목록 조회(list)는 GET, 생성/수정은 POST
- Slack은 Incoming Webhook URL로 HTTP POST → HTTP Webhook으로 구현
