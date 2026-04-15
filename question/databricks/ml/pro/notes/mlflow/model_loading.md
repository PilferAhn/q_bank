# MLflow 모델 로딩

## 상위 개념

```
MLflow
└── Models
    └── Model Loading
        ├── sklearn flavor
        ├── pyfunc flavor
        └── 기타 flavor (spark, pytorch 등)
```

## Flavor란

MLflow가 특정 ML 프레임워크의 모델을 로드/저장하는 방식.
같은 모델이라도 어떤 flavor로 로드하느냐에 따라 반환되는 객체가 다르다.

→ [flavors.md](./flavors.md) 참고 (추후 작성)

## 로딩 방법 비교

| 방법 | 반환 객체 | 용도 |
|---|---|---|
| `mlflow.sklearn.load_model(uri)` | sklearn 모델 객체 | sklearn 속성 접근 (`feature_importances_` 등) |
| `mlflow.pyfunc.load_model(uri)` | pyfunc 래퍼 | 배치 추론, 프레임워크 독립적 서빙 |
| `mlflow.spark.load_model(uri)` | Spark MLlib 모델 | Spark 파이프라인 |

## sklearn flavor로 로드 (Q12)

```python
model = mlflow.sklearn.load_model(model_uri)

# sklearn 고유 속성 접근 가능
print(model.feature_importances_)
print(model.n_estimators)
```

## pyfunc flavor로 로드 (Q34)

```python
model = mlflow.pyfunc.load_model(model_uri)

# predict만 가능, sklearn 속성 접근 불가
predictions = model.predict(X_test)
```

## 언제 무엇을 쓰나

| 상황 | 사용할 flavor |
|---|---|
| sklearn 모델 속성 접근 필요 | `mlflow.sklearn.load_model` |
| 배치 추론 (Spark DataFrame) | `mlflow.pyfunc.load_model` |
| 프레임워크 독립적 서빙 | `mlflow.pyfunc.load_model` |

## 관련 문제

- Q12: `feature_importances_` 접근 → `mlflow.sklearn.load_model`
- Q34: 배치 배포용 모델 로드 → `mlflow.pyfunc.load_model`

## 실무 포인트

- sklearn 모델이라도 배포/서빙 목적이면 pyfunc로 로드
- sklearn flavor는 분석/디버깅 목적에 적합
