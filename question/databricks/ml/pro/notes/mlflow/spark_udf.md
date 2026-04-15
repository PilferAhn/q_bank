# MLflow spark_udf — 배치 추론

## 상위 개념

```
MLflow
└── Models
    └── Batch Inference
        └── spark_udf
```

## 정의

MLflow 모델을 Spark UDF(User Defined Function)로 변환하여 Spark DataFrame에 적용하는 방법.
대규모 배치 추론에 사용된다.

## 사용법 (Q41)

```python
predict = mlflow.pyfunc.spark_udf(
    spark,                                      # 첫 번째 인자: Spark 세션
    f"runs:/{run_id}/random_forest_model"       # 두 번째 인자: 모델 URI
)

# Spark DataFrame에 적용
predictions_df = spark_df.withColumn(
    "prediction",
    predict(*feature_columns)
)
```

## 핵심: 첫 번째 인자는 Spark 세션

```python
# ✅ 올바른 사용
mlflow.pyfunc.spark_udf(spark, model_uri)

# ❌ DataFrame을 첫 번째 인자로 전달하면 안됨
mlflow.pyfunc.spark_udf(spark_df, model_uri)
```

## spark_udf vs pyfunc.load_model

| | `spark_udf` | `pyfunc.load_model` |
|---|---|---|
| **적합한 경우** | 대규모 Spark DataFrame 배치 추론 | pandas DataFrame 추론 |
| **분산 처리** | ✅ (Spark 클러스터 활용) | ❌ |
| **사용법** | UDF로 컬럼에 적용 | `model.predict(df)` |

## 관련 문제

- Q41: spark_udf로 배치 추론 함수 생성 → 첫 번째 인자는 `spark` 세션

## 실무 포인트

- 수백만 건 이상의 대규모 배치 추론 시 `spark_udf` 사용
- 소규모 데이터는 `pyfunc.load_model`로 충분
- 모델 URI는 `runs:/`, `models:/` 형식 모두 사용 가능
