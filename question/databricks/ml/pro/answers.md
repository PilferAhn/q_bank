# Databricks ML Professional — Answers & Explanations

---

## Question 1

**Answer: C**

> Concept drift is when there is a change in the relationship between input variables and target variables

**Explanation:**
각 drift 유형의 정의를 구분하는 것이 핵심이다.

| Drift 유형 | 정의 |
|---|---|
| Feature drift | 입력 변수의 분포 변화 |
| Label drift | 타겟 변수의 분포 변화 |
| **Concept drift** | **입력과 타겟 간의 관계 변화** |
| Prediction drift | 모델 예측값의 분포 변화 |

---

## Question 2

**Answer: C**

> Two-way Chi-squared Test

**Explanation:**
결측값의 비율이 시간에 따라 변했는지를 검증하려면, **두 시점의 범주형 데이터 분포를 비교**해야 한다. Two-way (2x2) Chi-squared test는 두 그룹 간의 범주형 변수 비율 차이를 검정하는 데 적합하다.

- KS test: 연속형 변수 분포 비교
- One-way Chi-squared: 단일 분포가 기대치와 일치하는지 검정
- Jensen-Shannon: 두 확률 분포 간의 거리 측정 (연속형에 주로 사용)

---

## Question 3

**Answer: C**

> Remove the `nested=True` argument from the child runs

**Explanation:**
MLflow에서 nested run을 올바르게 구성하려면:

```python
with mlflow.start_run() as parent_run:        # parent: nested 파라미터 불필요
    with mlflow.start_run(nested=True) as child_run:  # child: nested=True 필요
        ...
```

`nested=True`는 **child run**에만 추가해야 한다. parent run에 `nested=True`가 잘못 설정되어 있다면 제거해야 한다.

---

## Question 4

**Answer: D**

> `mlflow.log_artifact(importance_path, "feature-importance.csv")`

**Explanation:**
`mlflow.log_artifact`는 파일 경로를 받아 MLflow run에 아티팩트로 저장한다. CSV, 이미지, 텍스트 파일 등 임의의 파일을 로깅할 때 사용한다.

- `log_model`: 모델 객체 로깅 전용
- `log_metric`: 숫자 메트릭 로깅
- `log_param`: 하이퍼파라미터 로깅
- `log_model_and_data`, `log_data`: 존재하지 않는 함수

---

## Question 5

**Answer: B**

> Summary statistics trends

**Explanation:**
수치형 피처 drift를 모니터링하는 가장 단순하고 비용이 낮은 방법은 **평균, 표준편차, 최솟값, 최댓값 등의 요약 통계량 추이**를 시간에 따라 추적하는 것이다. KS test나 JS distance는 통계적으로 더 엄밀하지만 계산 비용이 높다.

---

## Question 6

**Answer: E**

> Feature drift

**Explanation:**
입력 변수(온도)가 학습 데이터의 범위를 벗어났다. 이는 **Feature drift** (입력 변수의 분포 변화)에 해당한다. 입력과 출력 간의 관계가 바뀐 것이 아니라, 입력값 자체가 학습 범위를 벗어난 것이다.

---

## Question 7

**Answer: A**

> `spark.read.format("delta").load(path).drop("star_rating")`

**Explanation:**
경로(path) 기반으로 Delta 테이블을 읽으려면 `spark.read.format("delta").load(path)`를 사용한다. 이후 `.drop()`으로 컬럼을 제거한다.

- `.table(path)`: 테이블 이름으로 읽을 때 사용 (경로 아님)
- `spark.read.table(path)`: 동일하게 테이블 이름 기반

---

## Question 8

**Answer: E**

> `fs.read_table`

**Explanation:**
Feature Store Client의 주요 메서드:

| 메서드 | 역할 |
|---|---|
| `fs.create_table` | 테이블 생성 |
| `fs.write_table` | 데이터 쓰기 |
| `fs.get_table` | 테이블 메타데이터 반환 (DataFrame 아님) |
| **`fs.read_table`** | **Spark DataFrame 반환** |

---

## Question 9

**Answer: E**

> Compute the evaluation metric using the observed and predicted values

**Explanation:**
Concept drift 모니터링 프로세스:

1. 모델 배포 후 예측값 계산
2. 실제 레이블 수집
3. **예측값과 실제값으로 평가 지표 계산** ← 이 단계가 drift를 감지하는 핵심
4. 성능 저하 감지 시 재학습 등 대응

---

## Question 10

**Answer: E**

> JS does not require any manual threshold or cutoff determinations

**Explanation:**
Jensen-Shannon distance의 장점:

- **0~1 사이로 정규화**되어 있어 별도 임계값 설정 불필요 (0 = 동일 분포, 1 = 완전히 다른 분포)
- KS test는 p-value 기반으로 임계값을 수동 설정해야 함

B는 오답: JS는 실제로 정규화(normalized)되어 있다.

---

## Question 11

**Answer: E**

> `spark.read.format("mlflow-experiment").load(exp_id)`

**Explanation:**
Databricks에서 MLflow 실험 결과를 Spark DataFrame으로 읽는 전용 방법이다.

```python
df = spark.read.format("mlflow-experiment").load(exp_id)
```

- `mlflow.search_runs()`: pandas DataFrame 반환 (Spark DataFrame 아님)
- `client.list_run_infos()`: RunInfo 객체 리스트 반환

---

## Question 12

**Answer: C**

> `mlflow.sklearn.load_model(model_uri)`

**Explanation:**
scikit-learn 모델을 로드하여 `feature_importances_`와 같은 sklearn 고유 속성에 접근하려면, **sklearn flavor**로 로드해야 한다. `mlflow.sklearn.load_model()`은 실제 sklearn 모델 객체를 반환한다.

- `mlflow.pyfunc.load_model()`: 예측 전용 인터페이스만 제공, sklearn 속성 접근 불가

---

## Question 13

**Answer: C**

> Mode, number of unique values, and % missing

**Explanation:**
범주형 피처의 drift를 모니터링하는 간단한 통계량 세트:

- **최빈값 (Mode)**: 주요 범주 변화 감지
- **고유값 수 (Number of unique values)**: 새로운 범주 등장 감지
- **결측 비율 (% missing)**: 데이터 품질 변화 감지

세 가지를 함께 사용하는 것이 효과적이다.

---

## Question 14

**Answer: C**

> All of these

**Explanation:**
Drift에 대한 대응 방안은 상황에 따라 다양하다:

- **최근 데이터로 재학습**: 가장 일반적인 대응
- **레이블 변수 변경**: 더 적합한 타겟으로 교체
- **서비스 종료 (Sunset)**: 모델이 더 이상 유효하지 않을 때

세 가지 모두 유효한 대응이다.

---

## Question 15

**Answer: D**

> `fs.write_table(name="features", df=features_df, mode="overwrite")`

**Explanation:**
Feature Store 테이블에 데이터를 덮어쓰려면 `fs.write_table()`에 `mode="overwrite"`를 사용한다.

- `fs.create_table()`: 테이블을 처음 생성할 때 사용, `mode` 파라미터 없음
- `mode="merge"`: 기존 데이터와 병합 (upsert)
- `mode="overwrite"`: 기존 데이터 완전 교체

---

## Question 16

**Answer: D**

> `DESCRIBE HISTORY`

**Explanation:**
`DESCRIBE HISTORY table_name`은 Delta 테이블의 모든 변경 이력(컬럼 추가/삭제, 데이터 변경 등)을 시간순으로 보여준다.

```sql
DESCRIBE HISTORY delta.`/path/to/table`
```

- `DESCRIBE`: 현재 스키마만 표시
- `HISTORY`: 단독으로는 SQL 명령어가 아님

---

## Question 17

**Answer: E**

> Change in target variable distribution

**Explanation:**
- **Label drift**: 타겟 변수(y)의 분포 변화
- Concept drift: 입력-타겟 관계 변화
- Feature drift: 입력 변수 분포 변화
- Prediction drift: 모델 예측값 분포 변화

---

## Question 18

**Answer: D**

> Batch

**Explanation:**
배치 배포는 주기적으로 대량의 데이터에 대해 예측을 실행하는 방식으로, 실무에서 가장 널리 사용된다. 인프라 요구사항이 낮고 구현이 단순하다.

---

## Question 19

**Answer: E**

> `mlflow.autolog()`

**Explanation:**
`mlflow.autolog()`는 **지원하는 모든 라이브러리**에 대해 전역으로 autologging을 활성화한다.

- `mlflow.sklearn.autolog()`: scikit-learn만 대상
- `mlflow.spark.autolog()`: Spark MLlib만 대상

---

## Question 20

**Answer: C**

> `log_metric`

**Explanation:**
MLflow 로깅 함수 구분:

| 함수 | 용도 |
|---|---|
| `log_param` | 하이퍼파라미터 (학습률, 트리 수 등) |
| **`log_metric`** | **평가 지표 (RMSE, accuracy 등)** |
| `log_artifact` | 파일 (CSV, 이미지 등) |
| `log_model` | 모델 객체 |

RMSE는 평가 지표이므로 `log_metric`을 사용한다.

---

## Question 21

**Answer: A**

> `mlflow.shap.log_explanation`

**Explanation:**
`mlflow.shap.log_explanation()`은 SHAP 값을 자동으로 계산하고 feature importance 플롯을 MLflow에 로깅하는 전용 함수다.

```python
mlflow.shap.log_explanation(model.predict, X_train)
```

- `mlflow.log_figure()`: 직접 생성한 figure를 수동으로 로깅
- `mlflow.shap`: 모듈 이름, 함수 아님

---

## Question 22

**Answer: B**

> `mlflow.models.signature.infer_signature`

**Explanation:**
`infer_signature()`는 모델을 MLflow에 로깅하기 전에 입출력 스키마(signature)를 추론한다.

```python
from mlflow.models.signature import infer_signature

signature = infer_signature(X_train, model.predict(X_train))
mlflow.sklearn.log_model(model, "model", signature=signature)
```

---

## Question 23

**Answer: B**

> All of these statements

**Explanation:**
스트리밍 배포에서 엄격한 데이터 테스트가 중요한 이유:

- **항상 실행 중**: 예외 처리가 없으면 시스템 전체가 중단될 수 있음
- **자동 운영**: 성능 저하를 즉시 디버깅할 담당자가 없음
- **오토스케일링**: 다양한 부하 조건에서 검증 필요

---

## Question 24

**Answer: E**

> Real-time

**Explanation:**
Real-time (온라인) 배포는:
- 단일 레코드에 대한 즉각적인 예측
- 중앙 서버에서 처리
- 낮은 지연시간 (ms 단위)

Edge/on-device는 단일 레코드 처리가 가능하지만 **중앙화된 방식**이 아니다.

---

## Question 25

**Answer: B**

> Structured Streaming

**Explanation:**
Spark Structured Streaming은 연속적인 데이터 스트림을 **마이크로 배치(micro-batch)** 단위로 처리한다. 트리거 간격에 따라 동일한 크기의 배치로 나누어 처리할 수 있다.

---

## Question 26

**Answer: E**

> None, Staging, Production

**Explanation:**
Databricks Model Serving은 등록된 모델의 **None, Staging, Production** 스테이지에 있는 버전을 자동으로 서빙 엔드포인트로 배포한다. **Archived** 스테이지는 자동 배포에서 제외된다.

---

## Question 27

**Answer: D**

> `mlflow.log_param`

**Explanation:**
트리 수(`n_estimators`)는 모델의 **하이퍼파라미터**다. `log_param`은 학습 전에 설정되는 단일 값(하이퍼파라미터)을 로깅하는 데 사용한다.

- `log_metric`: 학습 결과로 측정되는 수치 (손실, 정확도 등)
- `log_param`: 사전에 설정하는 값 (학습률, 트리 수 등)

---

## Question 28

**Answer: A**

> Start a manual parent run before calling `fmin`

**Explanation:**
Hyperopt + MLflow Autologging으로 parent/child run 구조를 만들려면, `fmin()` 호출 전에 수동으로 parent run을 시작해야 한다.

```python
with mlflow.start_run() as parent_run:
    best = fmin(
        fn=objective,
        space=search_space,
        algo=tpe.suggest,
        max_evals=10
    )
```

Autologging은 각 hyperopt trial을 자동으로 child run으로 기록한다.

---

## Question 29

**Answer: A**

> `fs.create_table(name=..., primary_keys=..., df=features_df, description=...)`

**Explanation:**
`fs.create_table()`에 `df` 파라미터를 전달하면 테이블 생성과 동시에 데이터를 채운다.

- `df` 없이 `create_table()`: 빈 테이블 스키마만 생성
- `function` 파라미터: 데이터 생성 함수를 지정하지만, `features_df`를 직접 전달하는 것과 다름

---

## Question 30

**Answer: B**

> Input schema validation during serving

**Explanation:**
Model Signature는 모델의 입출력 스키마를 명시한다. 서빙 시 **입력 데이터가 스키마와 일치하는지 자동으로 검증**하여 잘못된 형식의 요청을 사전에 차단한다.

---

## Question 31

**Answer: D**

> Incremental inference on trigger

**Explanation:**
Spark Structured Streaming을 이용한 모델 배포:
- 트리거(시간 간격 또는 파일 도착) 시 새로 들어온 데이터에 대해서만 추론 실행
- **증분(incremental)** 처리: 전체 데이터가 아닌 새 데이터만 처리

---

## Question 32

**Answer: E**

> `https://<host>/model/recommender/Production/invocations`

**Explanation:**
Databricks Model Serving URI 형식:
```
https://<databricks-host>/model/<model-name>/<stage>/invocations
```

경로에 `model`을 사용하고 스테이지명을 그대로 사용한다.

---

## Question 33

**Answer: D**

> Containers

**Explanation:**
Docker 컨테이너는 애플리케이션 코드와 모든 종속성(라이브러리, 런타임 등)을 패키징하여 어떤 환경에서도 동일하게 실행되도록 한다. MLflow도 모델을 Docker 이미지로 패키징하는 기능을 제공한다.

---

## Question 34

**Answer: D**

> `mlflow.pyfunc.load_model(model_uri)`

**Explanation:**
배치 배포 시 `mlflow.pyfunc.load_model()`을 사용하면 Spark DataFrame에 `.predict()`를 적용할 수 있는 통합 인터페이스를 얻는다.

```python
model = mlflow.pyfunc.load_model(model_uri)
predictions = model.predict(spark_df)
```

pyfunc flavor는 라이브러리에 관계없이 동일한 인터페이스를 제공하여 배치 배포에 적합하다.

---

## Question 35

**Answer: D**

> Run Artifacts

**Explanation:**
`mlflow.log_figure()` 또는 `mlflow.log_artifact()`로 로깅한 시각화 파일은 MLflow UI의 **Run 상세 페이지 > Artifacts** 탭에서 확인할 수 있다.

---

## Question 36

**Answer: B**

> `mlflow.sklearn.log_model(sklearn_model, "model")`

**Explanation:**
scikit-learn 모델을 MLflow run 내에서 로깅하는 올바른 방법이다.

```python
with mlflow.start_run():
    mlflow.sklearn.log_model(sklearn_model, "model")
```

- `track_model`: 존재하지 않는 함수
- `mlflow.spark.log_model`: Spark 모델 전용

---

## Question 37

**Answer: D**

> Help deployment tools understand models

**Explanation:**
MLflow Model Flavor는 특정 ML 프레임워크(sklearn, pytorch, tensorflow 등)로 학습된 모델을 배포 도구가 이해하고 로드할 수 있도록 **프레임워크별 메타데이터와 로딩 방법**을 제공한다.

---

## Question 38

**Answer: E**

> New model version in MLflow Registry

**Explanation:**
MLflow Registry의 Webhook을 통해 새 모델 버전 등록 시 자동으로 CI/CD 파이프라인을 트리거할 수 있다. 이를 통해 자동 테스트, 검증, 스테이지 전환 등을 구현한다.

---

## Question 39

**Answer: A**

> Z-Ordering

**Explanation:**
Z-Ordering은 Delta Lake의 데이터 레이아웃 최적화 기법으로, 관련 데이터를 **동일한 파일에 가깝게 배치(colocate)**하여 쿼리 시 읽어야 하는 파일 수를 최소화한다.

```sql
OPTIMIZE table_name ZORDER BY (column_name)
```

- Bin-packing: 파일 크기 최적화 (OPTIMIZE 기본 동작)
- Data skipping: Z-Ordering의 결과로 얻어지는 효과

---

## Question 40

**Answer: E**

> Stored predictions are faster to query

**Explanation:**
피처가 쿼리 시점보다 1주일 전에 미리 준비된다면, 배치 방식으로 미리 예측값을 계산하여 저장해두는 것이 효율적이다. 실제 쿼리 시에는 저장된 예측값만 조회하면 되므로 응답 속도가 빠르다.

---

## Question 41

**Answer: E**

> `mlflow.pyfunc.spark_udf(spark, f"runs:/{run_id}/random_forest_model")`

**Explanation:**
`mlflow.pyfunc.spark_udf()`의 첫 번째 인자는 **Spark 세션 객체**(`spark`)이고, 두 번째 인자는 모델 URI다.

```python
predict = mlflow.pyfunc.spark_udf(spark, f"runs:/{run_id}/random_forest_model")
predictions_df = spark_df.withColumn("prediction", predict(*feature_columns))
```

A는 오답: `spark_df`(DataFrame)가 아닌 `spark`(세션)를 전달해야 한다.

---

## Question 42

**Answer: E**

> Provide access to artifacts/config (e.g., preprocessing models)

**Explanation:**
Custom pyfunc 모델의 `predict(context, model_input)` 메서드에서 `context` 파라미터는 **`mlflow.pyfunc.PythonModelContext`** 객체로, 로깅된 아티팩트 경로나 모델 설정에 접근할 수 있다.

```python
def predict(self, context, model_input):
    preprocessor = joblib.load(context.artifacts["preprocessor"])
    return self.model.predict(preprocessor.transform(model_input))
```

---

## Question 43

**Answer: E**

> `fs.score_batch(model_uri, spark_df)`

**Explanation:**
`fs.score_batch()`는 Feature Store에 등록된 모델로 배치 추론을 수행한다. `spark_df`에 일부 피처만 있어도 Feature Store에서 `customer_id`를 키로 나머지 피처를 **자동으로 조회**하여 완전한 피처 세트를 구성한다.

---

## Question 44

**Answer: E**

> Real-time

**Explanation:**
요청 시점에 피처가 준비되어 있고, 단일 레코드에 대한 매우 빠른 예측이 필요한 경우 **Real-time 배포**가 적합하다. REST API 엔드포인트를 통해 즉각적인 응답을 제공한다.

---

## Question 45

**Answer: C**

> Replace `spark.read` with `spark.readStream`

**Explanation:**
배치 파이프라인을 스트리밍으로 전환하는 핵심 변경사항은 데이터 읽기 방식이다.

```python
# 배치
df = spark.read.format("delta").load(path)

# 스트리밍
df = spark.readStream.format("delta").load(path)
```

이후 `writeStream`을 사용하여 결과를 출력한다.

---

## Question 46

**Answer: A**

> `mlflow.register_model(model_uri, "best_model")`

**Explanation:**
`mlflow.register_model(model_uri, name)`으로 모델을 레지스트리에 등록한다.

```python
mlflow.register_model(model_uri, "best_model")
```

- 첫 번째 인자: 모델 URI (예: `"runs:/run_id/model"` 또는 `model_uri`)
- 두 번째 인자: 레지스트리에 등록할 모델 이름

---

## Question 47

**Answer: C**

> `client.transition_model_version_stage(name=model, version=model_version, stage="Production")`

**Explanation:**
`transition_model_version_stage()`로 모델 버전의 스테이지를 변경한다.

```python
client.transition_model_version_stage(
    name=model,
    version=model_version,
    stage="Production"
)
```

- `from`/`to` 파라미터는 존재하지 않음
- `transition_model_stage()`는 잘못된 메서드명

---

## Question 48

**Answer: A**

> `mlflow.register_model`

**Explanation:**
이미 존재하는 모델 이름으로 `mlflow.register_model()`을 호출하면 새 버전이 자동으로 추가된다. 새 모델을 생성하는 것이 아니라 기존 registered model에 새 버전이 append된다.

---

## Question 49

**Answer: C**

> Library-agnostic deployment

**Explanation:**
`python_function` (pyfunc) flavor의 핵심 장점은 **라이브러리에 독립적인 배포 인터페이스**를 제공한다는 것이다. sklearn, PyTorch, TensorFlow 등 어떤 프레임워크로 만든 모델이든 동일한 `predict()` 인터페이스로 배포할 수 있다.

---

## Question 50

**Answer: D**

> None, Staging, Production, Archived

**Explanation:**
MLflow Model Registry의 4가지 스테이지:

| 스테이지 | 설명 |
|---|---|
| **None** | 등록 직후 기본 상태 |
| **Staging** | 테스트/검증 중 |
| **Production** | 운영 배포 중 |
| **Archived** | 더 이상 사용하지 않는 버전 |

---

## Question 51

**Answer: E**

> Send Slack message on stage transition

**Explanation:**
HTTP Webhook은 외부 HTTP 엔드포인트로 이벤트를 전송한다. Slack은 Incoming Webhook URL을 통해 HTTP POST 요청을 받아 메시지를 전송하므로, 스테이지 전환 시 Slack 알림을 보내는 것이 HTTP Webhook의 전형적인 사용 사례다.

- 테스트 Job 시작은 Databricks Job Webhook으로 처리

---

## Question 52

**Answer: C**

> Preprocessing applied in predict

**Explanation:**
Custom pyfunc 모델에 전처리 로직을 `predict()` 내부에 포함시키면, 모델 서빙 시 **입력 데이터에 전처리가 자동으로 적용**된다. 별도의 전처리 파이프라인 없이도 일관된 추론이 보장된다.

---

## Question 53

**Answer: B**

> No changes

**Explanation:**
`client.update_registered_model(name=..., description=...)`는 등록된 모델의 설명을 업데이트하는 올바른 코드다. 변경이 필요없다.

- `update_model_version()`: 특정 버전의 메타데이터 업데이트 (모델 전체가 아닌 버전 단위)

---

## Question 54

**Answer: D**

> `client.transition_model_version_stage(..., stage="Production", archive_existing_versions=True)`

**Explanation:**
`archive_existing_versions=True` 파라미터를 사용하면 Production으로 전환할 때 **기존 Production 버전을 자동으로 Archived로 변경**한다.

```python
client.transition_model_version_stage(
    name=model,
    version=model_version,
    stage="Production",
    archive_existing_versions=True
)
```

---

## Question 55

**Answer: B**

> Model Registry

**Explanation:**
MLflow Model Registry는 모델의 버전 관리, 스테이지 전환, 메타데이터 관리를 위한 **중앙 집중식 모델 저장소**다. 팀 전체가 모델 라이프사이클을 공동으로 관리할 수 있다.

---

## Question 56

**Answer: D**

> `"MODEL_VERSION_TRANSITIONED_STAGE"`

**Explanation:**
MLflow Registry Webhook 이벤트 종류:

| 이벤트 | 설명 |
|---|---|
| `MODEL_VERSION_CREATED` | 새 버전 등록 |
| `MODEL_VERSION_TRANSITIONED_STAGE` | **임의의 스테이지 전환** |
| `MODEL_VERSION_TRANSITIONED_TO_STAGING` | Staging으로 전환 |
| `MODEL_VERSION_TRANSITIONED_TO_PRODUCTION` | Production으로 전환 |

모든 스테이지 전환에서 트리거하려면 `MODEL_VERSION_TRANSITIONED_STAGE`를 사용한다.

---

## Question 57

**Answer: E**

> `delete_registered_model`

**Explanation:**
- `delete_registered_model(name)`: 등록된 모델과 모든 버전을 완전히 삭제
- `delete_model_version(name, version)`: 특정 버전만 삭제

모델 전체를 삭제하려면 `delete_registered_model`을 사용한다.

---

## Question 58

**Answer: E**

> Databricks REST APIs

**Explanation:**
Databricks Job은 **Databricks REST API (Jobs API)**를 통해 프로그래밍 방식으로 생성, 수정, 실행할 수 있다. MLflow API는 실험/모델 관리 전용이다.

---

## Question 59

**Answer: C**

> Replace `POST` with `GET`

**Explanation:**
Webhook 목록 조회(`list`)는 **데이터를 읽는 작업**이므로 HTTP `GET` 메서드를 사용해야 한다. `POST`는 새 리소스를 생성할 때 사용한다.

```python
endpoint="/api/2.0/mlflow/registry-webhooks/list"
method="GET"  # POST → GET
```

---

## Question 60

**Answer: E**

> `client.transition_model_version_stage(name=model, ..., stage="Staging")`

**Explanation:**
Webhook이 Staging 전환 시 트리거되려면 실제로 모델 버전을 Staging으로 전환하는 API를 호출해야 한다. 올바른 메서드와 파라미터:

```python
client.transition_model_version_stage(
    name=model,
    version=model_version,
    stage="Staging"
)
```

- `from`/`to` 파라미터는 존재하지 않음
- `transition_model_stage()`: 잘못된 메서드명
