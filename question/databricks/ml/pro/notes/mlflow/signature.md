# MLflow Model Signature

## 상위 개념

```
MLflow
└── Models
    └── Model Signature
        ├── infer_signature (추론)
        └── 서빙 시 스키마 검증
```

## 정의

모델의 입력(input)과 출력(output)의 스키마를 명시적으로 정의한 것.
서빙 시 잘못된 형식의 요청을 사전에 차단하는 역할을 한다.

## infer_signature (Q22)

모델을 로깅하기 전에 입출력 스키마를 자동으로 추론한다.

```python
from mlflow.models.signature import infer_signature

# 입력 데이터와 예측값으로 signature 추론
signature = infer_signature(X_train, model.predict(X_train))

# 모델 로깅 시 signature 포함
mlflow.sklearn.log_model(model, "model", signature=signature)
```

## Signature의 이점 (Q30)

| 이점 | 설명 |
|---|---|
| **입력 스키마 검증** | 서빙 시 잘못된 형식의 요청 자동 차단 |
| **문서화** | 모델이 기대하는 입력/출력 형식을 명시 |
| **타입 불일치 방지** | 컬럼명, 데이터 타입 불일치 조기 감지 |

## Data Quality와 연계

MLflow Signature를 활용하면 서빙 시 스키마 변경(Schema Change)을 자동으로 감지할 수 있다.
→ [data_quality.md](../monitoring/data_quality/data_quality.md) 참고

## 관련 문제

- Q22: 로깅 전 모델의 입출력 스키마 추론 → `mlflow.models.signature.infer_signature`
- Q30: Signature 로깅의 이점 → 서빙 시 입력 스키마 검증

## 실무 포인트

- Signature 없이도 모델 서빙은 가능하지만, 잘못된 입력이 들어와도 에러를 잡지 못함
- `infer_signature`는 학습 데이터 샘플과 예측값이 있어야 추론 가능
- AutoML로 생성된 모델에는 Signature가 자동으로 포함됨
