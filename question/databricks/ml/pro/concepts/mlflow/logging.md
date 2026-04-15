# MLflow Logging

## 상위 개념

```
MLflow
└── Tracking
    └── Logging
        ├── log_param
        ├── log_metric
        ├── log_artifact
        └── log_model
```

## 함수 비교

| 함수 | 용도 | 예시 |
|---|---|---|
| `log_param` | 하이퍼파라미터 (학습 전 설정값) | 트리 수, 학습률 |
| `log_metric` | 평가 지표 (학습 결과 수치) | RMSE, accuracy, loss |
| `log_artifact` | 파일 (임의의 파일 저장) | CSV, 이미지, 텍스트 |
| `log_model` | 모델 객체 | sklearn, pytorch 모델 |

## 사용 예시

```python
with mlflow.start_run():
    # 하이퍼파라미터
    mlflow.log_param("n_estimators", 100)
    mlflow.log_param("max_depth", 5)

    # 모델 학습
    model.fit(X_train, y_train)

    # 평가 지표
    rmse = mean_squared_error(y_test, model.predict(X_test), squared=False)
    mlflow.log_metric("rmse", rmse)

    # 파일 아티팩트 (Q4)
    mlflow.log_artifact("feature_importance.csv")

    # 모델
    mlflow.sklearn.log_model(model, "model")
```

## log_artifact 상세 (Q4)

임의의 파일을 MLflow run에 저장할 때 사용.

```python
mlflow.log_artifact(local_path, artifact_path=None)
```

- `local_path`: 로컬 파일 경로
- `artifact_path`: MLflow 내 저장 경로 (선택)

## 관련 문제

- Q4: CSV 파일 로깅 → `log_artifact`
- Q20: RMSE 저장 → `log_metric`
- Q27: 트리 수 저장 → `log_param`
- Q35: 시각화 파일 조회 위치 → Run Artifacts

## 실무 포인트

- **param vs metric 혼동 주의**: 학습 전 설정 → param, 학습 후 결과 → metric
- `log_artifact`는 파일 경로를 받는다. 객체를 직접 전달하지 않음
- 시각화 파일은 `log_figure()` 또는 `log_artifact()`로 저장 후 Run Artifacts 탭에서 확인
