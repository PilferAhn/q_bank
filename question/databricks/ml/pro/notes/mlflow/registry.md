# MLflow Model Registry

## 상위 개념

```
MLflow
└── Model Registry   ← 여기
    ├── Registered Models
    ├── Model Versions
    ├── Stages
    └── Webhooks
```

## 정의

모델의 버전 관리, 스테이지 전환, 메타데이터 관리를 위한 **중앙 집중식 모델 저장소**. (Q55)
팀 전체가 모델 라이프사이클을 공동으로 관리할 수 있다.

## 4가지 Stage (Q50)

```
None → Staging → Production → Archived
```

| Stage | 설명 |
|---|---|
| **None** | 등록 직후 기본 상태 |
| **Staging** | 테스트/검증 중 |
| **Production** | 운영 배포 중 |
| **Archived** | 더 이상 사용하지 않는 버전 |

## 주요 작업

### 모델 등록 (Q46, Q48)

```python
# 새 모델 등록 또는 기존 모델에 새 버전 추가
mlflow.register_model(model_uri, "model_name")
```

- 동일한 이름으로 등록하면 새 버전이 자동으로 추가됨

### 스테이지 전환 (Q47, Q54)

```python
client = MlflowClient()

# 스테이지 전환
client.transition_model_version_stage(
    name="model_name",
    version=1,
    stage="Production"
)

# 전환 시 기존 Production 버전 자동 Archived (Q54)
client.transition_model_version_stage(
    name="model_name",
    version=2,
    stage="Production",
    archive_existing_versions=True
)
```

### 메타데이터 업데이트 (Q53)

```python
# 등록된 모델 설명 업데이트
client.update_registered_model(
    name="model_name",
    description="새 설명"
)

# 특정 버전 설명 업데이트
client.update_model_version(
    name="model_name",
    version=1,
    description="버전 설명"
)
```

### 모델 삭제 (Q57)

```python
# 특정 버전 삭제
client.delete_model_version(name="model_name", version=1)

# 모델 전체 삭제 (모든 버전 포함)
client.delete_registered_model(name="model_name")
```

## update_registered_model vs update_model_version

| | `update_registered_model` | `update_model_version` |
|---|---|---|
| **대상** | 등록된 모델 전체 | 특정 버전 |
| **용도** | 모델명, 전체 설명 변경 | 버전별 설명 변경 |

## CI/CD 연동 (Q38)

새 모델 버전이 Registry에 등록되면 Webhook을 통해 CI/CD 파이프라인을 자동으로 트리거할 수 있다.
→ [webhooks.md](./webhooks.md) 참고

## 관련 문제

- Q46: 모델 등록 → `mlflow.register_model(model_uri, "best_model")`
- Q47: Staging → Production 전환 → `transition_model_version_stage`
- Q48: 기존 모델에 새 버전 추가 → `mlflow.register_model`
- Q50: Registry stage 목록 → None, Staging, Production, Archived
- Q53: 모델 설명 업데이트 → `update_registered_model` (변경 불필요)
- Q54: Production 전환 + 기존 버전 archive → `archive_existing_versions=True`
- Q55: 중앙 모델 저장소 → Model Registry
- Q57: 모델 삭제 → `delete_registered_model`

## 실무 포인트

- `transition_model_version_stage`의 `from`/`to` 파라미터는 존재하지 않음 — `stage`만 사용
- Production으로 전환 시 `archive_existing_versions=True`를 쓰면 수동 archive 불필요
- 모델 전체 삭제 전 모든 버전을 Archived로 전환 권장
