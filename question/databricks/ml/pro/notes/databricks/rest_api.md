# Databricks REST API

## 상위 개념

```
Databricks
└── REST API
    ├── Jobs API
    ├── Clusters API
    ├── DBFS API
    └── MLflow Registry Webhooks API
```

## 정의

Databricks 플랫폼의 리소스를 프로그래밍 방식으로 생성, 수정, 조회, 삭제할 수 있는 HTTP API.

## Jobs API (Q58)

Databricks Job을 프로그래밍 방식으로 생성하려면 **Databricks REST API**를 사용한다.

```python
import requests

token = "dapi..."
host = "https://adb-xxx.azuredatabricks.net"

response = requests.post(
    f"{host}/api/2.1/jobs/create",
    headers={"Authorization": f"Bearer {token}"},
    json={
        "name": "My ML Job",
        "tasks": [...]
    }
)
```

- MLflow API로는 Job 생성 불가
- AutoML API로는 Job 생성 불가

## MLflow Registry Webhooks API (Q59)

```python
# Webhook 목록 조회
GET /api/2.0/mlflow/registry-webhooks/list

# Webhook 생성
POST /api/2.0/mlflow/registry-webhooks/create

# Webhook 삭제
DELETE /api/2.0/mlflow/registry-webhooks/delete
```

목록 조회(list)는 **GET**, 생성/수정은 **POST** 사용.

## HTTP 메서드 기본 원칙

| 메서드 | 용도 |
|---|---|
| **GET** | 조회 (읽기) |
| **POST** | 생성 |
| **PUT** | 전체 수정 |
| **PATCH** | 부분 수정 |
| **DELETE** | 삭제 |

## 관련 문제

- Q58: Databricks Job 프로그래밍 방식 생성 → Databricks REST APIs
- Q59: Webhook 목록 조회 API method → POST → GET으로 변경

## 실무 포인트

- Databricks CLI, SDK도 내부적으로 REST API를 사용
- Python SDK: `databricks-sdk` 패키지로 REST API를 더 편리하게 사용 가능
