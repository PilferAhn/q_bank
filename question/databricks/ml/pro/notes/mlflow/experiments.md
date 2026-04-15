# MLflow Experiments

## 상위 개념

```
MLflow
└── Tracking
    └── Experiments
        └── Runs
```

## 정의

MLflow Experiment는 관련된 Run들을 묶는 단위.
각 Run은 하이퍼파라미터, 메트릭, 아티팩트, 모델을 기록한다.

## 실험 결과를 Spark DataFrame으로 읽기 (Q11)

Databricks에서 MLflow 실험 결과를 Spark DataFrame으로 읽는 전용 방법:

```python
df = spark.read.format("mlflow-experiment").load(exp_id)
```

- `exp_id`: MLflow experiment ID
- 반환값: Run 정보가 담긴 Spark DataFrame

## search_runs vs mlflow-experiment format

| | `mlflow.search_runs()` | `spark.read.format("mlflow-experiment")` |
|---|---|---|
| **반환** | pandas DataFrame | Spark DataFrame |
| **용도** | 소규모 분석 | 대규모 분석, Spark 파이프라인 연동 |
| **Databricks 전용** | 아님 | 예 |

```python
# pandas DataFrame
import mlflow
runs_df = mlflow.search_runs(experiment_ids=[exp_id])

# Spark DataFrame (Databricks 전용)
spark_df = spark.read.format("mlflow-experiment").load(exp_id)
```

## 관련 문제

- Q11: 실험 결과를 Spark DataFrame으로 조회 → `spark.read.format("mlflow-experiment").load(exp_id)`

## 실무 포인트

- Spark DataFrame으로 읽으면 대규모 실험 결과 분석, 시각화 파이프라인 연동 가능
- `client.list_run_infos()`: RunInfo 객체 리스트 반환 (DataFrame 아님)
