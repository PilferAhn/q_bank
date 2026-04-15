# MLflow SHAP

## 상위 개념

```
MLflow
└── Tracking
    └── Artifacts
        └── SHAP (Feature Importance)
```

## 정의

SHAP(SHapley Additive exPlanations)은 모델의 각 피처가 예측에 얼마나 기여했는지를 설명하는 방법.
MLflow는 SHAP 값을 자동으로 계산하고 시각화까지 로깅하는 전용 API를 제공한다.

## mlflow.shap.log_explanation (Q21)

```python
with mlflow.start_run():
    model.fit(X_train, y_train)

    # SHAP 값 자동 계산 + 플롯 로깅
    mlflow.shap.log_explanation(model.predict, X_train)
```

- SHAP 값을 자동으로 계산
- Feature importance 플롯을 아티팩트로 자동 저장
- `model.predict`: 예측 함수를 인자로 전달

## log_explanation vs log_figure vs log_artifact

| | `mlflow.shap.log_explanation` | `mlflow.log_figure` | `mlflow.log_artifact` |
|---|---|---|---|
| **SHAP 계산** | 자동 | 수동 | 수동 |
| **플롯 생성** | 자동 | 수동 | 수동 |
| **용도** | SHAP 전용 | 임의 figure | 임의 파일 |

## 관련 문제

- Q21: SHAP feature importance 자동 계산 및 로깅 → `mlflow.shap.log_explanation`

## 실무 포인트

- SHAP 계산은 비용이 높음 → 전체 학습 데이터 대신 샘플링하여 사용 권장
- 로깅된 SHAP 플롯은 Run Artifacts 탭에서 확인 가능
