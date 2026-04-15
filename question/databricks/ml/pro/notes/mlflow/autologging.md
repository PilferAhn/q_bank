# MLflow Autologging

## 상위 개념

```
MLflow
└── Tracking
    └── Autologging
        ├── 전역 (mlflow.autolog)
        └── 라이브러리별 (mlflow.sklearn.autolog 등)
```

## 정의

MLflow가 지원하는 라이브러리의 학습 과정에서 파라미터, 메트릭, 모델을 **자동으로 로깅**하는 기능.
`log_param`, `log_metric`을 수동으로 호출하지 않아도 된다.

## 전역 vs 라이브러리별

```python
# 전역 활성화 — 지원하는 모든 라이브러리에 적용 (Q19)
mlflow.autolog()

# 특정 라이브러리만 활성화
mlflow.sklearn.autolog()
mlflow.spark.autolog()
mlflow.pytorch.autolog()
```

## 자동으로 로깅되는 것

| 항목 | 예시 |
|---|---|
| Parameters | `n_estimators`, `max_depth` |
| Metrics | `training_accuracy`, `val_loss` |
| Model | 학습된 모델 아티팩트 |
| Signature | 입출력 스키마 |

## Hyperopt + Autologging (Q28)

Autologging 활성화 상태에서 Hyperopt `fmin()` 사용 시, 각 trial이 자동으로 child run으로 기록된다.
parent run을 만들려면 수동으로 `mlflow.start_run()`을 먼저 열어야 한다.

```python
mlflow.autolog()

with mlflow.start_run():        # parent run 수동 생성
    best = fmin(fn=objective, ...)   # 각 trial → child run 자동 생성
```

→ [nested_runs.md](./nested_runs.md) 참고

## 관련 문제

- Q19: 전역 autologging 활성화 → `mlflow.autolog()`
- Q28: Hyperopt + autologging parent/child 구조

## 실무 포인트

- `mlflow.autolog()`은 코드 상단에 한 번만 호출하면 이후 모든 학습에 적용
- 불필요한 로깅을 줄이려면 `disable=True` 파라미터로 선택적 비활성화 가능
- 자동 로깅된 항목도 수동으로 추가 로깅 가능
