pg_dump: warning: there are circular foreign-key constraints on this table:
pg_dump: detail: domains
pg_dump: hint: You might not be able to restore the dump without using --disable-triggers or temporarily dropping the constraints.
pg_dump: hint: Consider using a full dump instead of a --data-only dump to avoid this problem.
--
-- PostgreSQL database dump
--

\restrict FVRGs7usp8joXtN3Qg6bBWUpotUPTeIIz5QyxQblZZkMXesbIawiwontVlZou3d

-- Dumped from database version 16.13 (Debian 16.13-1.pgdg13+1)
-- Dumped by pg_dump version 16.13 (Debian 16.13-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: vendors; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.vendors VALUES (1, 'Databricks', 'databricks');


--
-- Data for Name: exams; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.exams VALUES (1, 1, 'Machine Learning', 'ml');


--
-- Data for Name: exam_levels; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.exam_levels VALUES (1, 1, 'Professional', 'pro');


--
-- Data for Name: exam_sets; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.exam_sets VALUES (1, 1, 1);


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.questions VALUES (1, 1, 1, 'Which of the following describes concept drift?');
INSERT INTO public.questions VALUES (2, 1, 2, 'A machine learning engineer is monitoring categorical input variables for a production machine learning application.

The engineer believes that missing values are becoming more prevalent in more recent data for a particular value in one of the categorical input variables.

Which of the following tools can the machine learning engineer use to assess their theory?');
INSERT INTO public.questions VALUES (3, 1, 3, 'A data scientist is using MLflow to track their machine learning experiment.

As part of each MLflow run, they are performing hyperparameter tuning. The data scientist would like to have:

- one parent run for the tuning process
- one child run for each unique combination of hyperparameter values

However, the runs are not nesting correctly in MLflow.

Which of the following changes should be made so that the child runs nest under the parent run?');
INSERT INTO public.questions VALUES (4, 1, 4, 'A machine learning engineer wants to log feature importance data from a CSV file at path `importance_path` with an MLflow run for model `model`.

Which of the following code blocks will accomplish this task inside of an existing MLflow run block?');
INSERT INTO public.questions VALUES (5, 1, 5, 'Which of the following is a simple, low-cost method of monitoring numeric feature drift?');
INSERT INTO public.questions VALUES (6, 1, 6, 'A data scientist has developed a model to predict ice cream sales using:

- expected temperature
- expected number of hours of sun in the day

However, the expected temperature is dropping beneath the range of the input variable on which the model was trained.

Which type of drift is present?');
INSERT INTO public.questions VALUES (7, 1, 7, 'A data scientist wants to remove the `star_rating` column from the Delta table located at `path`.

Which code block accomplishes this task?');
INSERT INTO public.questions VALUES (8, 1, 8, 'Which of the following operations in Feature Store Client (`fs`) can be used to return a Spark DataFrame of a dataset associated with a Feature Store table?');
INSERT INTO public.questions VALUES (9, 1, 9, 'A machine learning engineer is implementing a concept drift monitoring solution using the following steps:

1. Deploy a model to production and compute predicted values
2. Obtain the observed (actual) label values
3. ?

Which step should be completed as Step 3?');
INSERT INTO public.questions VALUES (10, 1, 10, 'Which of the following is a reason for using Jensen-Shannon (JS) distance over a Kolmogorov-Smirnov (KS) test for numeric feature drift detection?');
INSERT INTO public.questions VALUES (11, 1, 11, 'A data scientist is utilizing MLflow to track experiments and wants to programmatically work with run data in a Spark DataFrame.

They have:

- an active MLflow Client `client`
- an active Spark session `spark`

Which code retrieves run-level results for `exp_id`?');
INSERT INTO public.questions VALUES (12, 1, 12, 'A data scientist wants to reload a logged scikit-learn model and access `feature_importances_`.

Which code accomplishes this?');
INSERT INTO public.questions VALUES (13, 1, 13, 'Which is a simple statistic for monitoring categorical feature drift?');
INSERT INTO public.questions VALUES (14, 1, 14, 'What is a probable response to drift?');
INSERT INTO public.questions VALUES (15, 1, 15, 'A data scientist wants to overwrite a Feature Store table `features` with `features_df`.

Which code works?');
INSERT INTO public.questions VALUES (16, 1, 16, 'A team wants to find when a column was dropped from a Delta table.

Which SQL command should be used?');
INSERT INTO public.questions VALUES (17, 1, 17, 'Which describes label drift?');
INSERT INTO public.questions VALUES (18, 1, 18, 'Most common deployment paradigm?');
INSERT INTO public.questions VALUES (19, 1, 19, 'Enable MLflow autologging globally.');
INSERT INTO public.questions VALUES (20, 1, 20, 'Store RMSE (`rmse`) in MLflow:

```python
with mlflow.start_run():
    ...
```

Which function should be used?');
INSERT INTO public.questions VALUES (21, 1, 21, 'Which of the following MLflow operations can be used to automatically calculate and log a Shapley feature importance plot?');
INSERT INTO public.questions VALUES (22, 1, 22, 'A data scientist has developed a scikit-learn random forest model `model`, but they have not yet logged it with MLflow.

They want to obtain the input schema and the output schema of the model.

Which operation can be used to perform this task?');
INSERT INTO public.questions VALUES (23, 1, 23, 'A machine learning engineer and data scientist are converting a batch deployment to an always-on streaming deployment.

Why are strict data tests particularly important for streaming deployments?');
INSERT INTO public.questions VALUES (24, 1, 24, 'Which deployment paradigm can centrally compute predictions for a single record with very fast results?');
INSERT INTO public.questions VALUES (25, 1, 25, 'A team wants continuous data processing into equal-sized batches.

Which tool supports this?');
INSERT INTO public.questions VALUES (26, 1, 26, 'A model is registered in MLflow Model Registry with versions in multiple stages.

Which stages are automatically deployed with Model Serving?');
INSERT INTO public.questions VALUES (27, 1, 27, 'A data scientist logs the number of trees in a random forest.

Which MLflow operation logs single values like this?');
INSERT INTO public.questions VALUES (28, 1, 28, 'A team is using Hyperopt with MLflow Autologging.

How can they create a parent run with child runs per hyperparameter combination?');
INSERT INTO public.questions VALUES (29, 1, 29, 'A function `compute_features` returns a Spark DataFrame `features_df`.

Which code creates and populates a Feature Store table?');
INSERT INTO public.questions VALUES (30, 1, 30, 'What is a benefit of logging a model signature in MLflow?');
INSERT INTO public.questions VALUES (31, 1, 31, 'Which describes streaming with Spark for model deployment?');
INSERT INTO public.questions VALUES (32, 1, 32, 'A model in Production stage needs to be queried via Model Serving.

Which URI is correct?');
INSERT INTO public.questions VALUES (33, 1, 33, 'Which tool packages software with dependencies for real-time deployment?');
INSERT INTO public.questions VALUES (34, 1, 34, 'A registered sklearn model needs to be loaded for batch deployment.

Which operation works?');
INSERT INTO public.questions VALUES (35, 1, 35, 'A data scientist logged visualizations in MLflow.

Where can they view them?');
INSERT INTO public.questions VALUES (36, 1, 36, 'A sklearn model needs to be logged:

```python
with mlflow.start_run():
    ...
```

Which line completes the task?');
INSERT INTO public.questions VALUES (37, 1, 37, 'What are MLflow Model flavors?');
INSERT INTO public.questions VALUES (38, 1, 38, 'What typically triggers CI/CD testing in ML pipelines?');
INSERT INTO public.questions VALUES (39, 1, 39, 'A team has slow queries due to scattered rows.

Which optimization helps colocate similar records?');
INSERT INTO public.questions VALUES (40, 1, 40, 'A model''s features are available one week before query time.

Why use batch serving instead of real-time?');
INSERT INTO public.questions VALUES (41, 1, 41, 'A machine learning engineer logged a scikit-learn random forest model and stored its `run_id`.

They want to perform batch inference on a Spark DataFrame `spark_df`.

Which code creates a predict function?');
INSERT INTO public.questions VALUES (42, 1, 42, 'What is the purpose of the `context` parameter in MLflow Python model `predict` method?');
INSERT INTO public.questions VALUES (43, 1, 43, 'A model is registered with Feature Store and used for batch inference.

Some features are missing in `spark_df`, but available via `customer_id`.

Which code computes predictions?');
INSERT INTO public.questions VALUES (44, 1, 44, 'A deployment requires:

- features available at request time
- very fast single-record predictions

Which deployment strategy fits?');
INSERT INTO public.questions VALUES (45, 1, 45, 'A batch pipeline must work with a streaming source.

What change is required?');
INSERT INTO public.questions VALUES (46, 1, 46, 'A model is identified via `model_uri` and `run_id`.

How to register it as `"best_model"`?');
INSERT INTO public.questions VALUES (47, 1, 47, 'Move model version from Staging → Production.

Which code works?');
INSERT INTO public.questions VALUES (48, 1, 48, 'Add a new version to an existing registered model.

Which operation?');
INSERT INTO public.questions VALUES (49, 1, 49, 'Advantage of `python_function` (pyfunc) flavor?');
INSERT INTO public.questions VALUES (50, 1, 50, 'Which stages exist in MLflow Model Registry?');
INSERT INTO public.questions VALUES (51, 1, 51, 'Which use case requires HTTP Webhook?');
INSERT INTO public.questions VALUES (52, 1, 52, 'A custom pyfunc model includes preprocessing in `fit` and `predict`.

What is the benefit?');
INSERT INTO public.questions VALUES (53, 1, 53, 'Update model description:

```python
client.update_registered_model(
    name="model",
    description=model_description
)
```

What change is needed?');
INSERT INTO public.questions VALUES (54, 1, 54, 'Move model to Production and archive existing versions.

Which code works?');
INSERT INTO public.questions VALUES (55, 1, 55, 'Which is the centralized model store?');
INSERT INTO public.questions VALUES (56, 1, 56, 'Webhook triggers on any stage transition.

What fills the blank?');
INSERT INTO public.questions VALUES (57, 1, 57, 'Which deletes a model from Model Registry?');
INSERT INTO public.questions VALUES (58, 1, 58, 'How to programmatically create a Databricks Job?');
INSERT INTO public.questions VALUES (59, 1, 59, 'List webhooks API call fix:

```python
endpoint="/api/2.0/mlflow/registry-webhooks/list"
method="POST"
```

What change is needed?');
INSERT INTO public.questions VALUES (60, 1, 60, 'Webhook triggers on transition to Staging.

Which action triggers it?');


--
-- Data for Name: answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.answers VALUES (1, 1, 3, 'Concept drift is when there is a change in the relationship between input variables and target variables', '각 drift 유형의 정의를 구분하는 것이 핵심이다.

| Drift 유형 | 정의 |
|---|---|
| Feature drift | 입력 변수의 분포 변화 |
| Label drift | 타겟 변수의 분포 변화 |
| **Concept drift** | **입력과 타겟 간의 관계 변화** |
| Prediction drift | 모델 예측값의 분포 변화 |');
INSERT INTO public.answers VALUES (2, 2, 3, 'Two-way Chi-squared Test', '결측값의 비율이 시간에 따라 변했는지를 검증하려면, **두 시점의 범주형 데이터 분포를 비교**해야 한다. Two-way (2x2) Chi-squared test는 두 그룹 간의 범주형 변수 비율 차이를 검정하는 데 적합하다.

- KS test: 연속형 변수 분포 비교
- One-way Chi-squared: 단일 분포가 기대치와 일치하는지 검정
- Jensen-Shannon: 두 확률 분포 간의 거리 측정 (연속형에 주로 사용)');
INSERT INTO public.answers VALUES (3, 3, 3, 'Remove the `nested=True` argument from the child runs', 'MLflow에서 nested run을 올바르게 구성하려면:

```python
with mlflow.start_run() as parent_run:        # parent: nested 파라미터 불필요
    with mlflow.start_run(nested=True) as child_run:  # child: nested=True 필요
        ...
```

`nested=True`는 **child run**에만 추가해야 한다. parent run에 `nested=True`가 잘못 설정되어 있다면 제거해야 한다.');
INSERT INTO public.answers VALUES (4, 4, 4, '`mlflow.log_artifact(importance_path, "feature-importance.csv")`', '`mlflow.log_artifact`는 파일 경로를 받아 MLflow run에 아티팩트로 저장한다. CSV, 이미지, 텍스트 파일 등 임의의 파일을 로깅할 때 사용한다.

- `log_model`: 모델 객체 로깅 전용
- `log_metric`: 숫자 메트릭 로깅
- `log_param`: 하이퍼파라미터 로깅
- `log_model_and_data`, `log_data`: 존재하지 않는 함수');
INSERT INTO public.answers VALUES (5, 5, 2, 'Summary statistics trends', '수치형 피처 drift를 모니터링하는 가장 단순하고 비용이 낮은 방법은 **평균, 표준편차, 최솟값, 최댓값 등의 요약 통계량 추이**를 시간에 따라 추적하는 것이다. KS test나 JS distance는 통계적으로 더 엄밀하지만 계산 비용이 높다.');
INSERT INTO public.answers VALUES (6, 6, 5, 'Feature drift', '입력 변수(온도)가 학습 데이터의 범위를 벗어났다. 이는 **Feature drift** (입력 변수의 분포 변화)에 해당한다. 입력과 출력 간의 관계가 바뀐 것이 아니라, 입력값 자체가 학습 범위를 벗어난 것이다.');
INSERT INTO public.answers VALUES (7, 7, 1, '`spark.read.format("delta").load(path).drop("star_rating")`', '경로(path) 기반으로 Delta 테이블을 읽으려면 `spark.read.format("delta").load(path)`를 사용한다. 이후 `.drop()`으로 컬럼을 제거한다.

- `.table(path)`: 테이블 이름으로 읽을 때 사용 (경로 아님)
- `spark.read.table(path)`: 동일하게 테이블 이름 기반');
INSERT INTO public.answers VALUES (8, 8, 5, '`fs.read_table`', 'Feature Store Client의 주요 메서드:

| 메서드 | 역할 |
|---|---|
| `fs.create_table` | 테이블 생성 |
| `fs.write_table` | 데이터 쓰기 |
| `fs.get_table` | 테이블 메타데이터 반환 (DataFrame 아님) |
| **`fs.read_table`** | **Spark DataFrame 반환** |');
INSERT INTO public.answers VALUES (9, 9, 5, 'Compute the evaluation metric using the observed and predicted values', 'Concept drift 모니터링 프로세스:

1. 모델 배포 후 예측값 계산
2. 실제 레이블 수집
3. **예측값과 실제값으로 평가 지표 계산** ← 이 단계가 drift를 감지하는 핵심
4. 성능 저하 감지 시 재학습 등 대응');
INSERT INTO public.answers VALUES (10, 10, 5, 'JS does not require any manual threshold or cutoff determinations', 'Jensen-Shannon distance의 장점:

- **0~1 사이로 정규화**되어 있어 별도 임계값 설정 불필요 (0 = 동일 분포, 1 = 완전히 다른 분포)
- KS test는 p-value 기반으로 임계값을 수동 설정해야 함

B는 오답: JS는 실제로 정규화(normalized)되어 있다.');
INSERT INTO public.answers VALUES (11, 11, 5, '`spark.read.format("mlflow-experiment").load(exp_id)`', 'Databricks에서 MLflow 실험 결과를 Spark DataFrame으로 읽는 전용 방법이다.

```python
df = spark.read.format("mlflow-experiment").load(exp_id)
```

- `mlflow.search_runs()`: pandas DataFrame 반환 (Spark DataFrame 아님)
- `client.list_run_infos()`: RunInfo 객체 리스트 반환');
INSERT INTO public.answers VALUES (12, 12, 3, '`mlflow.sklearn.load_model(model_uri)`', 'scikit-learn 모델을 로드하여 `feature_importances_`와 같은 sklearn 고유 속성에 접근하려면, **sklearn flavor**로 로드해야 한다. `mlflow.sklearn.load_model()`은 실제 sklearn 모델 객체를 반환한다.

- `mlflow.pyfunc.load_model()`: 예측 전용 인터페이스만 제공, sklearn 속성 접근 불가');
INSERT INTO public.answers VALUES (13, 13, 3, 'Mode, number of unique values, and % missing', '범주형 피처의 drift를 모니터링하는 간단한 통계량 세트:

- **최빈값 (Mode)**: 주요 범주 변화 감지
- **고유값 수 (Number of unique values)**: 새로운 범주 등장 감지
- **결측 비율 (% missing)**: 데이터 품질 변화 감지

세 가지를 함께 사용하는 것이 효과적이다.');
INSERT INTO public.answers VALUES (14, 14, 3, 'All of these', 'Drift에 대한 대응 방안은 상황에 따라 다양하다:

- **최근 데이터로 재학습**: 가장 일반적인 대응
- **레이블 변수 변경**: 더 적합한 타겟으로 교체
- **서비스 종료 (Sunset)**: 모델이 더 이상 유효하지 않을 때

세 가지 모두 유효한 대응이다.');
INSERT INTO public.answers VALUES (15, 15, 4, '`fs.write_table(name="features", df=features_df, mode="overwrite")`', 'Feature Store 테이블에 데이터를 덮어쓰려면 `fs.write_table()`에 `mode="overwrite"`를 사용한다.

- `fs.create_table()`: 테이블을 처음 생성할 때 사용, `mode` 파라미터 없음
- `mode="merge"`: 기존 데이터와 병합 (upsert)
- `mode="overwrite"`: 기존 데이터 완전 교체');
INSERT INTO public.answers VALUES (16, 16, 4, '`DESCRIBE HISTORY`', '`DESCRIBE HISTORY table_name`은 Delta 테이블의 모든 변경 이력(컬럼 추가/삭제, 데이터 변경 등)을 시간순으로 보여준다.

```sql
DESCRIBE HISTORY delta.`/path/to/table`
```

- `DESCRIBE`: 현재 스키마만 표시
- `HISTORY`: 단독으로는 SQL 명령어가 아님');
INSERT INTO public.answers VALUES (17, 17, 5, 'Change in target variable distribution', '- **Label drift**: 타겟 변수(y)의 분포 변화
- Concept drift: 입력-타겟 관계 변화
- Feature drift: 입력 변수 분포 변화
- Prediction drift: 모델 예측값 분포 변화');
INSERT INTO public.answers VALUES (18, 18, 4, 'Batch', '배치 배포는 주기적으로 대량의 데이터에 대해 예측을 실행하는 방식으로, 실무에서 가장 널리 사용된다. 인프라 요구사항이 낮고 구현이 단순하다.');
INSERT INTO public.answers VALUES (19, 19, 5, '`mlflow.autolog()`', '`mlflow.autolog()`는 **지원하는 모든 라이브러리**에 대해 전역으로 autologging을 활성화한다.

- `mlflow.sklearn.autolog()`: scikit-learn만 대상
- `mlflow.spark.autolog()`: Spark MLlib만 대상');
INSERT INTO public.answers VALUES (20, 20, 3, '`log_metric`', 'MLflow 로깅 함수 구분:

| 함수 | 용도 |
|---|---|
| `log_param` | 하이퍼파라미터 (학습률, 트리 수 등) |
| **`log_metric`** | **평가 지표 (RMSE, accuracy 등)** |
| `log_artifact` | 파일 (CSV, 이미지 등) |
| `log_model` | 모델 객체 |

RMSE는 평가 지표이므로 `log_metric`을 사용한다.');
INSERT INTO public.answers VALUES (21, 21, 1, '`mlflow.shap.log_explanation`', '`mlflow.shap.log_explanation()`은 SHAP 값을 자동으로 계산하고 feature importance 플롯을 MLflow에 로깅하는 전용 함수다.

```python
mlflow.shap.log_explanation(model.predict, X_train)
```

- `mlflow.log_figure()`: 직접 생성한 figure를 수동으로 로깅
- `mlflow.shap`: 모듈 이름, 함수 아님');
INSERT INTO public.answers VALUES (22, 22, 2, '`mlflow.models.signature.infer_signature`', '`infer_signature()`는 모델을 MLflow에 로깅하기 전에 입출력 스키마(signature)를 추론한다.

```python
from mlflow.models.signature import infer_signature

signature = infer_signature(X_train, model.predict(X_train))
mlflow.sklearn.log_model(model, "model", signature=signature)
```');
INSERT INTO public.answers VALUES (23, 23, 2, 'All of these statements', '스트리밍 배포에서 엄격한 데이터 테스트가 중요한 이유:

- **항상 실행 중**: 예외 처리가 없으면 시스템 전체가 중단될 수 있음
- **자동 운영**: 성능 저하를 즉시 디버깅할 담당자가 없음
- **오토스케일링**: 다양한 부하 조건에서 검증 필요');
INSERT INTO public.answers VALUES (24, 24, 5, 'Real-time', 'Real-time (온라인) 배포는:
- 단일 레코드에 대한 즉각적인 예측
- 중앙 서버에서 처리
- 낮은 지연시간 (ms 단위)

Edge/on-device는 단일 레코드 처리가 가능하지만 **중앙화된 방식**이 아니다.');
INSERT INTO public.answers VALUES (25, 25, 2, 'Structured Streaming', 'Spark Structured Streaming은 연속적인 데이터 스트림을 **마이크로 배치(micro-batch)** 단위로 처리한다. 트리거 간격에 따라 동일한 크기의 배치로 나누어 처리할 수 있다.');
INSERT INTO public.answers VALUES (26, 26, 5, 'None, Staging, Production', 'Databricks Model Serving은 등록된 모델의 **None, Staging, Production** 스테이지에 있는 버전을 자동으로 서빙 엔드포인트로 배포한다. **Archived** 스테이지는 자동 배포에서 제외된다.');
INSERT INTO public.answers VALUES (27, 27, 4, '`mlflow.log_param`', '트리 수(`n_estimators`)는 모델의 **하이퍼파라미터**다. `log_param`은 학습 전에 설정되는 단일 값(하이퍼파라미터)을 로깅하는 데 사용한다.

- `log_metric`: 학습 결과로 측정되는 수치 (손실, 정확도 등)
- `log_param`: 사전에 설정하는 값 (학습률, 트리 수 등)');
INSERT INTO public.answers VALUES (28, 28, 1, 'Start a manual parent run before calling `fmin`', 'Hyperopt + MLflow Autologging으로 parent/child run 구조를 만들려면, `fmin()` 호출 전에 수동으로 parent run을 시작해야 한다.

```python
with mlflow.start_run() as parent_run:
    best = fmin(
        fn=objective,
        space=search_space,
        algo=tpe.suggest,
        max_evals=10
    )
```

Autologging은 각 hyperopt trial을 자동으로 child run으로 기록한다.');
INSERT INTO public.answers VALUES (29, 29, 1, '`fs.create_table(name=..., primary_keys=..., df=features_df, description=...)`', '`fs.create_table()`에 `df` 파라미터를 전달하면 테이블 생성과 동시에 데이터를 채운다.

- `df` 없이 `create_table()`: 빈 테이블 스키마만 생성
- `function` 파라미터: 데이터 생성 함수를 지정하지만, `features_df`를 직접 전달하는 것과 다름');
INSERT INTO public.answers VALUES (30, 30, 2, 'Input schema validation during serving', 'Model Signature는 모델의 입출력 스키마를 명시한다. 서빙 시 **입력 데이터가 스키마와 일치하는지 자동으로 검증**하여 잘못된 형식의 요청을 사전에 차단한다.');
INSERT INTO public.answers VALUES (31, 31, 4, 'Incremental inference on trigger', 'Spark Structured Streaming을 이용한 모델 배포:
- 트리거(시간 간격 또는 파일 도착) 시 새로 들어온 데이터에 대해서만 추론 실행
- **증분(incremental)** 처리: 전체 데이터가 아닌 새 데이터만 처리');
INSERT INTO public.answers VALUES (32, 32, 5, '`https://<host>/model/recommender/Production/invocations`', 'Databricks Model Serving URI 형식:
```
https://<databricks-host>/model/<model-name>/<stage>/invocations
```

경로에 `model`을 사용하고 스테이지명을 그대로 사용한다.');
INSERT INTO public.answers VALUES (33, 33, 4, 'Containers', 'Docker 컨테이너는 애플리케이션 코드와 모든 종속성(라이브러리, 런타임 등)을 패키징하여 어떤 환경에서도 동일하게 실행되도록 한다. MLflow도 모델을 Docker 이미지로 패키징하는 기능을 제공한다.');
INSERT INTO public.answers VALUES (34, 34, 4, '`mlflow.pyfunc.load_model(model_uri)`', '배치 배포 시 `mlflow.pyfunc.load_model()`을 사용하면 Spark DataFrame에 `.predict()`를 적용할 수 있는 통합 인터페이스를 얻는다.

```python
model = mlflow.pyfunc.load_model(model_uri)
predictions = model.predict(spark_df)
```

pyfunc flavor는 라이브러리에 관계없이 동일한 인터페이스를 제공하여 배치 배포에 적합하다.');
INSERT INTO public.answers VALUES (35, 35, 4, 'Run Artifacts', '`mlflow.log_figure()` 또는 `mlflow.log_artifact()`로 로깅한 시각화 파일은 MLflow UI의 **Run 상세 페이지 > Artifacts** 탭에서 확인할 수 있다.');
INSERT INTO public.answers VALUES (36, 36, 2, '`mlflow.sklearn.log_model(sklearn_model, "model")`', 'scikit-learn 모델을 MLflow run 내에서 로깅하는 올바른 방법이다.

```python
with mlflow.start_run():
    mlflow.sklearn.log_model(sklearn_model, "model")
```

- `track_model`: 존재하지 않는 함수
- `mlflow.spark.log_model`: Spark 모델 전용');
INSERT INTO public.answers VALUES (37, 37, 4, 'Help deployment tools understand models', 'MLflow Model Flavor는 특정 ML 프레임워크(sklearn, pytorch, tensorflow 등)로 학습된 모델을 배포 도구가 이해하고 로드할 수 있도록 **프레임워크별 메타데이터와 로딩 방법**을 제공한다.');
INSERT INTO public.answers VALUES (38, 38, 5, 'New model version in MLflow Registry', 'MLflow Registry의 Webhook을 통해 새 모델 버전 등록 시 자동으로 CI/CD 파이프라인을 트리거할 수 있다. 이를 통해 자동 테스트, 검증, 스테이지 전환 등을 구현한다.');
INSERT INTO public.answers VALUES (39, 39, 1, 'Z-Ordering', 'Z-Ordering은 Delta Lake의 데이터 레이아웃 최적화 기법으로, 관련 데이터를 **동일한 파일에 가깝게 배치(colocate)**하여 쿼리 시 읽어야 하는 파일 수를 최소화한다.

```sql
OPTIMIZE table_name ZORDER BY (column_name)
```

- Bin-packing: 파일 크기 최적화 (OPTIMIZE 기본 동작)
- Data skipping: Z-Ordering의 결과로 얻어지는 효과');
INSERT INTO public.answers VALUES (40, 40, 5, 'Stored predictions are faster to query', '피처가 쿼리 시점보다 1주일 전에 미리 준비된다면, 배치 방식으로 미리 예측값을 계산하여 저장해두는 것이 효율적이다. 실제 쿼리 시에는 저장된 예측값만 조회하면 되므로 응답 속도가 빠르다.');
INSERT INTO public.answers VALUES (41, 41, 5, '`mlflow.pyfunc.spark_udf(spark, f"runs:/{run_id}/random_forest_model")`', '`mlflow.pyfunc.spark_udf()`의 첫 번째 인자는 **Spark 세션 객체**(`spark`)이고, 두 번째 인자는 모델 URI다.

```python
predict = mlflow.pyfunc.spark_udf(spark, f"runs:/{run_id}/random_forest_model")
predictions_df = spark_df.withColumn("prediction", predict(*feature_columns))
```

A는 오답: `spark_df`(DataFrame)가 아닌 `spark`(세션)를 전달해야 한다.');
INSERT INTO public.answers VALUES (42, 42, 5, 'Provide access to artifacts/config (e.g., preprocessing models)', 'Custom pyfunc 모델의 `predict(context, model_input)` 메서드에서 `context` 파라미터는 **`mlflow.pyfunc.PythonModelContext`** 객체로, 로깅된 아티팩트 경로나 모델 설정에 접근할 수 있다.

```python
def predict(self, context, model_input):
    preprocessor = joblib.load(context.artifacts["preprocessor"])
    return self.model.predict(preprocessor.transform(model_input))
```');
INSERT INTO public.answers VALUES (43, 43, 5, '`fs.score_batch(model_uri, spark_df)`', '`fs.score_batch()`는 Feature Store에 등록된 모델로 배치 추론을 수행한다. `spark_df`에 일부 피처만 있어도 Feature Store에서 `customer_id`를 키로 나머지 피처를 **자동으로 조회**하여 완전한 피처 세트를 구성한다.');
INSERT INTO public.answers VALUES (44, 44, 5, 'Real-time', '요청 시점에 피처가 준비되어 있고, 단일 레코드에 대한 매우 빠른 예측이 필요한 경우 **Real-time 배포**가 적합하다. REST API 엔드포인트를 통해 즉각적인 응답을 제공한다.');
INSERT INTO public.answers VALUES (45, 45, 3, 'Replace `spark.read` with `spark.readStream`', '배치 파이프라인을 스트리밍으로 전환하는 핵심 변경사항은 데이터 읽기 방식이다.

```python
# 배치
df = spark.read.format("delta").load(path)

# 스트리밍
df = spark.readStream.format("delta").load(path)
```

이후 `writeStream`을 사용하여 결과를 출력한다.');
INSERT INTO public.answers VALUES (46, 46, 1, '`mlflow.register_model(model_uri, "best_model")`', '`mlflow.register_model(model_uri, name)`으로 모델을 레지스트리에 등록한다.

```python
mlflow.register_model(model_uri, "best_model")
```

- 첫 번째 인자: 모델 URI (예: `"runs:/run_id/model"` 또는 `model_uri`)
- 두 번째 인자: 레지스트리에 등록할 모델 이름');
INSERT INTO public.answers VALUES (47, 47, 3, '`client.transition_model_version_stage(name=model, version=model_version, stage="Production")`', '`transition_model_version_stage()`로 모델 버전의 스테이지를 변경한다.

```python
client.transition_model_version_stage(
    name=model,
    version=model_version,
    stage="Production"
)
```

- `from`/`to` 파라미터는 존재하지 않음
- `transition_model_stage()`는 잘못된 메서드명');
INSERT INTO public.answers VALUES (48, 48, 1, '`mlflow.register_model`', '이미 존재하는 모델 이름으로 `mlflow.register_model()`을 호출하면 새 버전이 자동으로 추가된다. 새 모델을 생성하는 것이 아니라 기존 registered model에 새 버전이 append된다.');
INSERT INTO public.answers VALUES (49, 49, 3, 'Library-agnostic deployment', '`python_function` (pyfunc) flavor의 핵심 장점은 **라이브러리에 독립적인 배포 인터페이스**를 제공한다는 것이다. sklearn, PyTorch, TensorFlow 등 어떤 프레임워크로 만든 모델이든 동일한 `predict()` 인터페이스로 배포할 수 있다.');
INSERT INTO public.answers VALUES (50, 50, 4, 'None, Staging, Production, Archived', 'MLflow Model Registry의 4가지 스테이지:

| 스테이지 | 설명 |
|---|---|
| **None** | 등록 직후 기본 상태 |
| **Staging** | 테스트/검증 중 |
| **Production** | 운영 배포 중 |
| **Archived** | 더 이상 사용하지 않는 버전 |');
INSERT INTO public.answers VALUES (51, 51, 5, 'Send Slack message on stage transition', 'HTTP Webhook은 외부 HTTP 엔드포인트로 이벤트를 전송한다. Slack은 Incoming Webhook URL을 통해 HTTP POST 요청을 받아 메시지를 전송하므로, 스테이지 전환 시 Slack 알림을 보내는 것이 HTTP Webhook의 전형적인 사용 사례다.

- 테스트 Job 시작은 Databricks Job Webhook으로 처리');
INSERT INTO public.answers VALUES (52, 52, 3, 'Preprocessing applied in predict', 'Custom pyfunc 모델에 전처리 로직을 `predict()` 내부에 포함시키면, 모델 서빙 시 **입력 데이터에 전처리가 자동으로 적용**된다. 별도의 전처리 파이프라인 없이도 일관된 추론이 보장된다.');
INSERT INTO public.answers VALUES (53, 53, 2, 'No changes', '`client.update_registered_model(name=..., description=...)`는 등록된 모델의 설명을 업데이트하는 올바른 코드다. 변경이 필요없다.

- `update_model_version()`: 특정 버전의 메타데이터 업데이트 (모델 전체가 아닌 버전 단위)');
INSERT INTO public.answers VALUES (54, 54, 4, '`client.transition_model_version_stage(..., stage="Production", archive_existing_versions=True)`', '`archive_existing_versions=True` 파라미터를 사용하면 Production으로 전환할 때 **기존 Production 버전을 자동으로 Archived로 변경**한다.

```python
client.transition_model_version_stage(
    name=model,
    version=model_version,
    stage="Production",
    archive_existing_versions=True
)
```');
INSERT INTO public.answers VALUES (55, 55, 2, 'Model Registry', 'MLflow Model Registry는 모델의 버전 관리, 스테이지 전환, 메타데이터 관리를 위한 **중앙 집중식 모델 저장소**다. 팀 전체가 모델 라이프사이클을 공동으로 관리할 수 있다.');
INSERT INTO public.answers VALUES (56, 56, 4, '`"MODEL_VERSION_TRANSITIONED_STAGE"`', 'MLflow Registry Webhook 이벤트 종류:

| 이벤트 | 설명 |
|---|---|
| `MODEL_VERSION_CREATED` | 새 버전 등록 |
| `MODEL_VERSION_TRANSITIONED_STAGE` | **임의의 스테이지 전환** |
| `MODEL_VERSION_TRANSITIONED_TO_STAGING` | Staging으로 전환 |
| `MODEL_VERSION_TRANSITIONED_TO_PRODUCTION` | Production으로 전환 |

모든 스테이지 전환에서 트리거하려면 `MODEL_VERSION_TRANSITIONED_STAGE`를 사용한다.');
INSERT INTO public.answers VALUES (57, 57, 5, '`delete_registered_model`', '- `delete_registered_model(name)`: 등록된 모델과 모든 버전을 완전히 삭제
- `delete_model_version(name, version)`: 특정 버전만 삭제

모델 전체를 삭제하려면 `delete_registered_model`을 사용한다.');
INSERT INTO public.answers VALUES (58, 58, 5, 'Databricks REST APIs', 'Databricks Job은 **Databricks REST API (Jobs API)**를 통해 프로그래밍 방식으로 생성, 수정, 실행할 수 있다. MLflow API는 실험/모델 관리 전용이다.');
INSERT INTO public.answers VALUES (59, 59, 3, 'Replace `POST` with `GET`', 'Webhook 목록 조회(`list`)는 **데이터를 읽는 작업**이므로 HTTP `GET` 메서드를 사용해야 한다. `POST`는 새 리소스를 생성할 때 사용한다.

```python
endpoint="/api/2.0/mlflow/registry-webhooks/list"
method="GET"  # POST → GET
```');
INSERT INTO public.answers VALUES (60, 60, 5, '`client.transition_model_version_stage(name=model, ..., stage="Staging")`', 'Webhook이 Staging 전환 시 트리거되려면 실제로 모델 버전을 Staging으로 전환하는 API를 호출해야 한다. 올바른 메서드와 파라미터:

```python
client.transition_model_version_stage(
    name=model,
    version=model_version,
    stage="Staging"
)
```

- `from`/`to` 파라미터는 존재하지 않음
- `transition_model_stage()`: 잘못된 메서드명');


--
-- Data for Name: domains; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.domains VALUES (1, NULL, 'databricks', 'databricks');
INSERT INTO public.domains VALUES (2, NULL, 'delta_lake', 'delta_lake');
INSERT INTO public.domains VALUES (5, NULL, 'deployment', 'deployment');
INSERT INTO public.domains VALUES (7, NULL, 'feature_store', 'feature_store');
INSERT INTO public.domains VALUES (8, NULL, 'mlflow', 'mlflow');
INSERT INTO public.domains VALUES (21, 20, 'data_quality', 'monitoring__data_quality');
INSERT INTO public.domains VALUES (24, 23, 'detection', 'monitoring__drift__detection');
INSERT INTO public.domains VALUES (20, NULL, 'monitoring', 'monitoring');
INSERT INTO public.domains VALUES (23, 20, 'drift', 'monitoring__drift');
INSERT INTO public.domains VALUES (39, 23, 'types', 'monitoring__drift__types');


--
-- Data for Name: concepts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.concepts VALUES (1, 1, 1, 'Databricks REST API', 'databricks__rest_api', '# Databricks REST API

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
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (2, 1, 2, 'Delta Lake — DESCRIBE HISTORY', 'delta_lake__describe_history', '# Delta Lake — DESCRIBE HISTORY

## 상위 개념

```
Delta Lake
└── Time Travel
    └── DESCRIBE HISTORY   ← 여기
```

## 정의

Delta 테이블의 모든 변경 이력을 조회하는 SQL 명령어.
언제, 무엇이, 어떻게 바뀌었는지를 버전 단위로 확인할 수 있다.

## 사용법

```sql
-- 테이블명으로 조회
DESCRIBE HISTORY table_name

-- 경로로 조회
DESCRIBE HISTORY delta.`/path/to/table`
```

## 반환 정보

| 컬럼 | 설명 |
|---|---|
| version | 버전 번호 |
| timestamp | 변경 시각 |
| operation | 수행된 작업 (WRITE, DELETE, MERGE 등) |
| operationParameters | 작업 파라미터 상세 |
| userMetadata | 사용자 정의 메타데이터 |

## DESCRIBE vs DESCRIBE HISTORY

| | DESCRIBE | DESCRIBE HISTORY |
|---|---|---|
| **용도** | 현재 스키마 조회 | 전체 변경 이력 조회 |
| **결과** | 컬럼명, 타입 | 버전별 작업 내역 |

## 관련 문제

- Q16: 컬럼이 언제 삭제됐는지 확인 → DESCRIBE HISTORY

## 실무 포인트

- 컬럼 삭제, 데이터 변경, 스키마 변경 등의 시점 추적에 활용
- Time Travel (`VERSION AS OF`, `TIMESTAMP AS OF`)과 함께 사용하면 특정 시점 데이터 복원 가능
```sql
SELECT * FROM table_name VERSION AS OF 3
SELECT * FROM table_name TIMESTAMP AS OF ''2024-01-01''
```
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (3, 1, 2, 'Delta Lake — Spark 기본 조작', 'delta_lake__spark_operations', '# Delta Lake — Spark 기본 조작

## 상위 개념

```
Delta Lake
└── Spark Operations
    ├── 읽기 (Read)
    ├── 쓰기 (Write)
    └── 컬럼 조작 (Schema)
```

## Delta 테이블 읽기

### 경로(path) 기반
```python
df = spark.read.format("delta").load("/path/to/table")
```

### 테이블명 기반
```python
df = spark.read.table("database.table_name")
```

> 혼동 주의: `load(path)`는 경로, `table(name)`은 테이블명을 받는다

## 컬럼 삭제 (Q7)

```python
df = spark.read.format("delta").load(path).drop("column_name")
```

- 메모리 상에서 컬럼을 제거한 DataFrame을 반환
- Delta 테이블 자체를 변경하지 않음 → 영구 삭제하려면 write back 필요

```python
# 영구 삭제
spark.read.format("delta").load(path) \
    .drop("column_name") \
    .write.format("delta").mode("overwrite").save(path)
```

## 잘못된 사용 예시

```python
# ❌ table()은 테이블명을 받아야 함, 경로 사용 불가
spark.read.format("delta").table(path).drop("column_name")

# ❌ SQL이지만 FROM에 경로 사용 불가
SELECT * EXCEPT column_name FROM path
```

## 관련 문제

- Q7: 경로 기반 Delta 테이블에서 컬럼 삭제

## 실무 포인트

- Delta Lake 2.0+ 에서는 `ALTER TABLE DROP COLUMN` 지원
- Spark API로 컬럼 제거 후 write back 시 `overwriteSchema=True` 옵션 필요할 수 있음
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (4, 1, 2, 'Delta Lake — Z-Ordering', 'delta_lake__z_ordering', '# Delta Lake — Z-Ordering

## 상위 개념

```
Delta Lake
└── Optimization
    ├── Z-Ordering     ← 여기
    └── Bin-packing
```

## 정의

관련 데이터를 동일한 파일에 가깝게 배치(colocate)하여 쿼리 시 읽어야 하는 파일 수를 최소화하는 최적화 기법. (Q39)

## 사용법

```sql
OPTIMIZE table_name ZORDER BY (column_name)

-- 여러 컬럼
OPTIMIZE table_name ZORDER BY (col1, col2)
```

## Z-Ordering vs Bin-packing

| | Z-Ordering | Bin-packing |
|---|---|---|
| **목적** | 유사 데이터 colocate | 파일 크기 최적화 |
| **효과** | 특정 컬럼 필터 쿼리 속도 향상 | 작은 파일 병합 |
| **명령어** | `OPTIMIZE ... ZORDER BY` | `OPTIMIZE` (기본) |

## Data Skipping과의 관계

Z-Ordering은 Data Skipping을 더 효과적으로 만든다.

```
Z-Ordering으로 유사 데이터 colocate
    → 각 파일의 min/max 통계값이 뚜렷하게 분리
        → 쿼리 시 불필요한 파일 skip 가능 (Data Skipping)
```

## 관련 문제

- Q39: 분산된 행을 모아 유사 레코드를 colocate하는 최적화 → Z-Ordering

## 실무 포인트

- 자주 필터링하는 컬럼에 적용 (예: `date`, `user_id`, `region`)
- OPTIMIZE 작업은 비용이 있으므로 주기적으로 실행 (예: 일 1회)
- 카디널리티가 높은 컬럼(user_id 등)에 특히 효과적
- `OPTIMIZE` 단독 사용은 Bin-packing만 수행
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (5, 1, 5, 'Containers — 배포 패키징', 'deployment__containers', '# Containers — 배포 패키징

## 상위 개념

```
ML Deployment
└── Infrastructure
    └── Containers (Docker)
```

## 정의

애플리케이션 코드와 모든 종속성(라이브러리, 런타임, 설정 등)을 하나의 패키지로 묶어 어떤 환경에서도 동일하게 실행되도록 하는 기술. (Q33)

## 배포에서의 역할

Real-time 서빙이나 스트리밍 배포 시, 모델과 서빙 코드를 컨테이너로 패키징하면:

- 개발 환경과 운영 환경의 차이 제거
- 라이브러리 버전 충돌 방지
- 어디서나 동일한 실행 환경 보장

## MLflow + Docker

MLflow는 모델을 Docker 이미지로 패키징하는 기능을 내장하고 있다.

```bash
# MLflow 모델을 Docker 이미지로 빌드
mlflow models build-docker -m "runs:/<run_id>/model" -n "my-model"

# 컨테이너 실행
docker run -p 5000:8080 my-model
```

## Containers vs 다른 인프라

| | Containers | Cloud Compute | Autoscaling Clusters |
|---|---|---|---|
| **역할** | 소프트웨어 패키징 | 실행 환경 제공 | 트래픽 대응 |
| **종속성 포함** | ✅ | ❌ | ❌ |

## 관련 문제

- Q33: Real-time 배포 시 소프트웨어를 종속성과 함께 패키징하는 도구 → Containers

## 실무 포인트

- REST API + Container 조합이 Real-time 배포의 표준 패턴
- MLflow Model Serving (Databricks)은 내부적으로 컨테이너 기반으로 동작
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (6, 1, 5, '배포 패러다임 (Deployment Paradigms)', 'deployment__paradigms', '# 배포 패러다임 (Deployment Paradigms)

## 상위 개념

```
ML Deployment
└── Deployment Paradigms
    ├── Batch
    ├── Real-time
    ├── Streaming
    └── Edge / On-device
```

## 4가지 패러다임 비교

| | Batch | Real-time | Streaming | Edge/On-device |
|---|---|---|---|---|
| **처리 단위** | 대량 | 단일 레코드 | 마이크로 배치 | 단일 레코드 |
| **응답 속도** | 느림 (분~시간) | 빠름 (ms) | 중간 | 빠름 |
| **위치** | 중앙 서버 | 중앙 서버 | 중앙 서버 | 디바이스 |
| **사용 빈도** | **가장 많음** | 많음 | 중간 | 적음 |
| **인프라 비용** | 낮음 | 높음 | 중간 | 낮음 |

## Batch (Q18, Q40)

- 주기적으로 대량 데이터에 대해 예측 실행
- 예측값을 미리 저장해두고 조회 → **저장된 예측값이 빠르게 조회 가능**
- 피처가 쿼리 시점 이전에 준비되어 있을 때 유리
- **실무에서 가장 일반적인 배포 방식**

```python
# pyfunc로 배치 추론
model = mlflow.pyfunc.load_model(model_uri)
predictions = model.predict(spark_df)
```

## Real-time (Q24, Q44)

- 단일 레코드에 대해 즉각적인 예측 (ms 단위)
- 중앙 서버에서 처리
- 요청 시점에 피처가 준비되어야 함
- REST API 엔드포인트로 서빙

## Streaming (Q25, Q31)

- 연속적인 데이터 스트림을 마이크로 배치로 처리
- Spark Structured Streaming 활용
- 트리거 간격마다 새로 들어온 데이터만 처리 (incremental)

```python
# batch → streaming 전환 핵심 변경
df = spark.readStream.format("delta").load(path)  # spark.read → spark.readStream
```

## Edge / On-device

- 모델이 디바이스에 직접 배포
- 중앙 서버 없이 로컬에서 추론
- 네트워크 연결 불필요

## 관련 문제

- Q18: 가장 일반적인 배포 방식 → Batch
- Q24: 단일 레코드 빠른 중앙 예측 → Real-time
- Q25: 연속 데이터 마이크로 배치 → Structured Streaming
- Q31: Spark 스트리밍 배포 특징 → Incremental inference on trigger
- Q40: 피처가 미리 준비된 경우 Batch 선호 이유 → 저장된 예측값 빠른 조회
- Q44: 요청 시 피처 + 빠른 단일 레코드 → Real-time
- Q45: Batch → Streaming 전환 변경점 → `spark.read` → `spark.readStream`
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (7, 1, 7, 'Feature Store — Overview', 'feature_store__overview', '# Feature Store — Overview

## 상위 개념

```
Databricks
└── Feature Store
    ├── 테이블 생성 (create_table)
    ├── 데이터 쓰기 (write_table)
    ├── 데이터 읽기 (read_table)
    └── 배치 추론 (score_batch)
```

## 정의

피처를 중앙에서 관리하고 재사용할 수 있도록 저장하는 저장소.
학습과 서빙에서 동일한 피처를 사용하도록 보장한다.

## 주요 메서드

| 메서드 | 용도 |
|---|---|
| `fs.create_table()` | 테이블 생성 (최초 1회) |
| `fs.write_table()` | 데이터 쓰기/업데이트 |
| `fs.read_table()` | Spark DataFrame으로 읽기 |
| `fs.get_table()` | 테이블 메타데이터 조회 (DataFrame 아님) |
| `fs.score_batch()` | Feature Store 연동 배치 추론 |

## create_table vs write_table

```python
# 테이블 생성 + 데이터 동시 적재 (df 파라미터 사용)
fs.create_table(
    name="database.table_name",
    primary_keys="id",
    df=features_df,
    description="설명"
)

# 기존 테이블에 데이터 쓰기
fs.write_table(
    name="database.table_name",
    df=features_df,
    mode="overwrite"   # or "merge"
)
```

## write_table modes (Q15)

| mode | 동작 |
|---|---|
| `"overwrite"` | 기존 데이터 전체 교체 |
| `"merge"` | primary_key 기준 upsert |

## read_table vs get_table (Q8)

```python
# Spark DataFrame 반환 ✅
df = fs.read_table(name="database.table_name")

# FeatureTable 메타데이터 객체 반환 (DataFrame 아님) ❌
meta = fs.get_table(name="database.table_name")
```

## 관련 문제

- Q8: Feature Store에서 Spark DataFrame 반환 → `fs.read_table`
- Q15: Feature Store 테이블 덮어쓰기 → `fs.write_table(..., mode="overwrite")`
- Q29: 테이블 생성과 동시에 데이터 적재 → `fs.create_table(..., df=features_df)`
- Q43: Feature Store 연동 배치 추론 → `fs.score_batch()`

## 실무 포인트

- `create_table`은 테이블이 없을 때만 사용, 이후는 `write_table`
- `get_table`과 `read_table` 혼동 주의 — DataFrame이 필요하면 `read_table`
- `score_batch`는 spark_df에 없는 피처를 primary_key로 자동 조회
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (8, 1, 8, 'MLflow Autologging', 'mlflow__autologging', '# MLflow Autologging

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
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (9, 1, 8, 'MLflow Experiments', 'mlflow__experiments', '# MLflow Experiments

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
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (10, 1, 8, 'MLflow Model Flavors', 'mlflow__flavors', '# MLflow Model Flavors

## 상위 개념

```
MLflow
└── Models
    └── Flavors
        ├── sklearn
        ├── pyfunc (python_function)
        ├── spark
        ├── pytorch
        └── tensorflow 등
```

## 정의

배포 도구(serving, batch pipeline 등)가 모델을 이해하고 로드할 수 있도록 프레임워크별 메타데이터와 로딩 방법을 정의한 것. (Q37)

> "Flavor = 배포 도구에게 이 모델을 어떻게 다루는지 알려주는 설명서"

## pyfunc (python_function) Flavor

모든 MLflow 모델이 공통으로 가지는 flavor.
프레임워크에 관계없이 동일한 `predict()` 인터페이스를 제공한다.

### 핵심 장점 (Q49)

**라이브러리 독립적 배포** — sklearn, pytorch, tensorflow 등 어떤 라이브러리로 만든 모델이든 동일한 방식으로 배포 가능

```python
# sklearn 모델이든 pytorch 모델이든 동일한 인터페이스
model = mlflow.pyfunc.load_model(model_uri)
predictions = model.predict(input_data)
```

## Custom pyfunc (Q52)

전처리 로직을 모델에 포함시켜 서빙 시 자동으로 적용되게 하는 패턴.

```python
class CustomModel(mlflow.pyfunc.PythonModel):

    def load_context(self, context):
        # context에서 아티팩트 로드 (Q42)
        self.preprocessor = joblib.load(context.artifacts["preprocessor"])
        self.model = joblib.load(context.artifacts["model"])

    def predict(self, context, model_input):
        # predict 호출 시 전처리 자동 적용 ← 핵심 이점 (Q52)
        processed = self.preprocessor.transform(model_input)
        return self.model.predict(processed)
```

### context 파라미터 (Q42)

`predict(self, context, model_input)`의 `context`는 `PythonModelContext` 객체로,
로깅된 아티팩트 경로나 모델 설정에 접근할 수 있다.

```python
context.artifacts["preprocessor"]   # 아티팩트 경로
context.model_config                 # 모델 설정
```

## Flavor별 사용 시나리오

| Flavor | 사용 시나리오 |
|---|---|
| `sklearn` | sklearn 속성 접근, 분석/디버깅 |
| `pyfunc` | 배포, 서빙, 프레임워크 독립적 추론 |
| `spark` | Spark MLlib 모델, 분산 추론 |

## 관련 문제

- Q37: MLflow Model Flavor의 목적 → 배포 도구가 모델을 이해하도록
- Q42: context 파라미터 목적 → 아티팩트/설정 접근
- Q49: pyfunc의 장점 → 라이브러리 독립적 배포
- Q52: Custom pyfunc의 이점 → predict 시 전처리 자동 적용

## 실무 포인트

- 배포 목적이면 항상 pyfunc flavor 사용
- Custom pyfunc로 전처리를 모델에 포함시키면 서빙 환경에서 별도 전처리 파이프라인 불필요
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (11, 1, 8, 'MLflow Logging', 'mlflow__logging', '# MLflow Logging

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
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (12, 1, 8, 'MLflow 모델 로딩', 'mlflow__model_loading', '# MLflow 모델 로딩

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
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (13, 1, 8, 'MLflow Model Serving', 'mlflow__model_serving', '# MLflow Model Serving

## 상위 개념

```
MLflow
└── Model Serving
    ├── 자동 배포 Stage
    └── REST API 엔드포인트
```

## 정의

MLflow Model Registry에 등록된 모델을 REST API 엔드포인트로 자동 배포하는 Databricks 기능.

## 자동 배포 Stage (Q26)

Model Serving은 아래 3가지 Stage의 모델을 자동으로 서빙 엔드포인트에 배포한다:

| Stage | 자동 배포 |
|---|---|
| None | ✅ |
| Staging | ✅ |
| Production | ✅ |
| Archived | ❌ |

## REST API URI 형식 (Q32)

```
https://<databricks-host>/model/<model-name>/<stage>/invocations
```

```python
# 예시
url = "https://adb-xxx.azuredatabricks.net/model/recommender/Production/invocations"
```

- 경로: `/model/` (model-serving 아님)
- stage: `Production`, `Staging`, `None`
- 끝: `/invocations`

## 잘못된 URI 패턴

```
# ❌ model-serving 사용
https://<host>/model-serving/recommender/Production/invocations

# ❌ stage- 접두사 사용
https://<host>/model/recommender/stage-production/invocations

# ❌ 버전 번호 사용
https://<host>/model/recommender/1/invocations
```

## 관련 문제

- Q26: Model Serving 자동 배포 Stage → None, Staging, Production
- Q32: Production 모델 조회 URI → `https://<host>/model/<name>/Production/invocations`

## 실무 포인트

- Archived 모델은 자동 서빙에서 제외
- 버전 번호가 아닌 Stage명으로 엔드포인트가 결정됨
- 여러 버전이 같은 Stage에 있으면 가장 최신 버전이 서빙됨
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (14, 1, 8, 'MLflow Nested Runs', 'mlflow__nested_runs', '# MLflow Nested Runs

## 상위 개념

```
MLflow
└── Experiments
    └── Runs
        └── Nested Runs (Parent / Child)
```

## 정의

하나의 실험 내에서 **부모 run 아래 자식 run을 계층 구조로 구성**하는 방식.
하이퍼파라미터 튜닝 시 튜닝 프로세스 전체를 parent run으로, 각 trial을 child run으로 관리할 때 주로 사용한다.

## 구조

```python
with mlflow.start_run() as parent_run:          # parent: nested 파라미터 불필요
    with mlflow.start_run(nested=True) as child: # child: nested=True 필수
        mlflow.log_param("n_estimators", 100)
        mlflow.log_metric("rmse", 0.25)
```

## 핵심 규칙

- `nested=True`는 **child run**에만 추가
- parent run에는 `nested=True` 불필요
- child run에 `nested=True` 없으면 에러 발생 (active run 충돌)

## Hyperopt + MLflow (Q28)

Autologging 활성화 상태에서 Hyperopt의 각 trial을 child run으로 만들려면,
**`fmin()` 호출 전에 수동으로 parent run을 시작**해야 한다.

```python
mlflow.autolog()

with mlflow.start_run() as parent_run:
    best = fmin(
        fn=objective,
        space=search_space,
        algo=tpe.suggest,
        max_evals=10
    )
    # 각 trial은 자동으로 child run으로 기록됨
```

## 관련 문제

- Q3: Nested run이 올바르게 동작하지 않을 때 수정 방법
- Q28: Hyperopt + MLflow로 parent/child run 구성

## 실무 포인트

- Hyperopt, Optuna 등 튜닝 프레임워크와 함께 사용 시 parent run을 먼저 열어야 계층 구조가 생김
- MLflow UI에서 parent run을 펼치면 child run 목록이 표시됨
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (15, 1, 8, 'MLflow Model Registry', 'mlflow__registry', '# MLflow Model Registry

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
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (16, 1, 8, 'MLflow SHAP', 'mlflow__shap', '# MLflow SHAP

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
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (17, 1, 8, 'MLflow Model Signature', 'mlflow__signature', '# MLflow Model Signature

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
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (18, 1, 8, 'MLflow spark_udf — 배치 추론', 'mlflow__spark_udf', '# MLflow spark_udf — 배치 추론

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
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (19, 1, 8, 'MLflow Registry Webhooks', 'mlflow__webhooks', '# MLflow Registry Webhooks

## 상위 개념

```
MLflow
└── Model Registry
    └── Webhooks
        ├── HTTP Webhook
        └── Job Webhook
```

## 정의

Model Registry에서 특정 이벤트 발생 시 외부 시스템에 자동으로 알림을 보내는 기능.
CI/CD 트리거, Slack 알림 등에 활용된다.

## Webhook 종류

| 종류 | 용도 |
|---|---|
| **HTTP Webhook** | 외부 HTTP 엔드포인트 호출 (Slack, 외부 시스템 등) |
| **Job Webhook** | Databricks Job 자동 실행 |

### HTTP Webhook 사용 사례 (Q51)

- Slack 메시지 전송 (Slack Incoming Webhook URL로 HTTP POST)
- 외부 알림 시스템 연동

### Job Webhook 사용 사례

- 새 모델 버전 등록 시 테스트 Job 자동 실행

## 이벤트 종류 (Q56)

| 이벤트 | 트리거 조건 |
|---|---|
| `MODEL_VERSION_CREATED` | 새 버전 등록 |
| `MODEL_VERSION_TRANSITIONED_STAGE` | **임의의 스테이지 전환** |
| `MODEL_VERSION_TRANSITIONED_TO_STAGING` | Staging 전환 |
| `MODEL_VERSION_TRANSITIONED_TO_PRODUCTION` | Production 전환 |

모든 스테이지 전환에서 트리거하려면 `MODEL_VERSION_TRANSITIONED_STAGE` 사용.

## API 호출 (Q59)

```python
# Webhook 목록 조회
endpoint = "/api/2.0/mlflow/registry-webhooks/list"
method = "GET"    # 목록 조회는 GET (POST 아님)
```

## Webhook 트리거 조건 (Q60)

Webhook이 동작하려면 실제로 `transition_model_version_stage()`를 호출해야 한다.

```python
# Staging 전환 → Webhook 트리거
client.transition_model_version_stage(
    name=model,
    version=model_version,
    stage="Staging"
)
```

- `from`/`to` 파라미터는 존재하지 않음
- `transition_model_stage()`는 잘못된 메서드명

## CI/CD 연동 (Q38)

```
새 모델 버전 등록
    → MODEL_VERSION_CREATED Webhook 트리거
        → CI/CD 파이프라인 실행 (테스트, 검증)
            → 통과 시 Staging 전환
```

## 관련 문제

- Q38: CI/CD 트리거 → 새 모델 버전 등록 시
- Q51: HTTP Webhook 사용 사례 → Slack 메시지 전송
- Q56: 모든 스테이지 전환 트리거 이벤트 → `MODEL_VERSION_TRANSITIONED_STAGE`
- Q59: Webhook 목록 조회 API → POST → GET으로 변경
- Q60: Staging 전환 Webhook 트리거 → `transition_model_version_stage(..., stage="Staging")`

## 실무 포인트

- HTTP Webhook은 POST 요청을 외부 URL로 전송
- 목록 조회(list)는 GET, 생성/수정은 POST
- Slack은 Incoming Webhook URL로 HTTP POST → HTTP Webhook으로 구현
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (20, 1, 21, 'Data Quality Monitoring', 'monitoring__data_quality__data_quality', '# Data Quality Monitoring

## 상위 개념

```
ML Monitoring
├── Model Drift
└── Data Quality   ← 여기
    ├── 결측값
    ├── 이상값
    └── 스키마 변경
```

## 정의

모델에 입력되는 데이터 자체의 품질이 저하되는 현상.
Drift와 달리 **분포의 변화가 아닌 데이터 자체의 문제**에 초점을 맞춘다.

Data Quality 문제는 Drift보다 먼저 감지되는 경우가 많고,
방치하면 Feature Drift나 Prediction Drift로 이어진다.

---

## 주요 유형

### 결측값 증가 (Missing Values)
특정 피처에서 null/NaN 비율이 시간이 지남에 따라 증가하는 현상.

- 원인: 데이터 수집 파이프라인 오류, 소스 시스템 변경
- 감지: 피처별 결측 비율(% missing) 추이 모니터링
- 범주형 피처의 결측값 증가 감지 → Two-way Chi-squared test (Q2)

### 이상값 (Outliers)
정상 범위를 크게 벗어난 값이 입력으로 들어오는 현상.

- 원인: 센서 오류, 데이터 입력 실수, 시스템 버그
- 감지: IQR, Z-score, 최솟값/최댓값 모니터링
- Feature drift와 구분 필요: 이상값은 일시적, Feature drift는 지속적

### 스키마 변경 (Schema Change)
입력 데이터의 구조가 바뀌는 현상.

- 원인: 업스트림 데이터 파이프라인 변경, 새 피처 추가/삭제, 타입 변경
- 감지: 컬럼 수, 컬럼명, 데이터 타입 모니터링
- MLflow Model Signature로 입력 스키마 검증 가능 (Q30)

---

## Data Quality vs Feature Drift

| | Data Quality | Feature Drift |
|---|---|---|
| **초점** | 데이터 자체의 문제 | 분포의 변화 |
| **원인** | 파이프라인 오류, 시스템 변경 | 실제 세계의 변화 |
| **성격** | 일시적일 수 있음 | 지속적인 추세 |
| **대응** | 파이프라인 수정 | 모델 재학습 |

---

## 감지 도구

| 유형 | 도구 |
|---|---|
| 결측값 | % missing 추이, Two-way Chi-squared |
| 이상값 | IQR, Z-score, Summary statistics |
| 스키마 | MLflow Signature, 스키마 검증 로직 |

---

## 관련 문제

- Q2: 범주형 피처 결측값 증가 감지 → Two-way Chi-squared
- Q30: MLflow Signature로 입력 스키마 검증

## 실무 포인트

- Data Quality 문제는 Drift보다 **파악이 쉽고 빠르게 수정 가능**한 경우가 많음
- 모델 성능 저하 발생 시 Drift보다 Data Quality를 먼저 확인하는 것이 효율적
- 스트리밍 배포에서는 Data Quality 검증이 특히 중요 (Q23) — 항상 실행 중이라 오류 발생 시 전체 파이프라인이 중단될 수 있음
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (21, 1, 24, 'Chi-Squared Test', 'monitoring__drift__detection__chi_squared', '# Chi-Squared Test

## 상위 개념

```
ML Monitoring
└── Drift Detection
    └── 범주형 피처 감지
        └── Chi-Squared Test   ← 여기
```

## 정의

범주형 변수의 분포를 통계적으로 검정하는 방법.
목적에 따라 One-way와 Two-way로 나뉜다.

## One-way vs Two-way

| | One-way Chi-squared | Two-way Chi-squared |
|---|---|---|
| **목적** | 단일 분포가 기대치와 일치하는지 | 두 그룹 간 분포 차이 비교 |
| **사용 시점** | 고정된 기준 분포와 비교 | 과거 vs 현재 비교 |
| **Drift 감지** | 부적합 | **적합** |

## Drift 감지에 Two-way를 사용하는 이유

Drift 감지는 **두 시점(과거 vs 현재)의 분포를 비교**하는 것이므로 Two-way Chi-squared가 적합하다.

```
과거 데이터 분포  ┐
                  ├─ Two-way Chi-squared → drift 여부 판단
현재 데이터 분포  ┘
```

## 적용 예시 (Q2)

범주형 피처에서 결측값 비율이 증가했는지 확인:
- 과거 구간의 결측/비결측 빈도
- 현재 구간의 결측/비결측 빈도
- Two-way Chi-squared로 두 분포 차이 검정

## 한계

- 수치형 피처에는 사용 불가 (범주형 전용)
- 충분한 샘플 수가 필요 (각 셀 기대 빈도 ≥ 5 권장)

## 관련 문제

- Q2: 범주형 결측값 증가 감지 → Two-way Chi-squared

## 실무 포인트

- 범주형 피처 drift 감지의 표준적인 통계 방법
- One-way와 혼동 주의 — drift 감지에는 항상 Two-way
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (22, 1, 24, 'Drift 감지 도구', 'monitoring__drift__detection__drift_detection', '# Drift 감지 도구

## 상위 개념

```
ML Monitoring
└── Drift Detection
    ├── 수치형 피처: KS test, JS distance, Summary statistics
    └── 범주형 피처: Chi-squared test, Summary statistics
```

## 도구 비교

| 도구 | 대상 | 특징 | 단점 |
|---|---|---|---|
| **Summary Statistics** | 수치형 + 범주형 | 단순, 저비용, 직관적 | 분포 전체를 반영 못함 |
| **KS Test** | 수치형 | 통계적으로 엄밀 | 임계값 수동 설정 필요 |
| **JS Distance** | 수치형 | 0~1 정규화, 임계값 불필요 | 계산 비용 높음 |
| **Two-way Chi-squared** | 범주형 | 두 시점 간 분포 비교 | 샘플 수 충분해야 함 |
| **One-way Chi-squared** | 범주형 | 단일 분포가 기대치와 일치하는지 | drift 감지 목적과 다름 |

## 수치형 피처 감지

### Summary Statistics (Q5)
가장 단순하고 저비용. 평균, 표준편차, 최솟값, 최댓값의 **추이**를 시간에 따라 추적.

### KS Test
두 분포가 같은지 통계적으로 검정. p-value로 판단하므로 **임계값 수동 설정** 필요.

### JS Distance (Q10)
- 0~1 사이로 정규화 → 임계값 설정 불필요 (0 = 동일, 1 = 완전히 다름)
- KS test보다 임계값 판단이 직관적

## 범주형 피처 감지

### Two-way Chi-squared (Q2)
두 시점(과거 vs 현재)의 범주형 분포를 비교할 때 사용.
결측값 비율 변화, 새로운 범주 등장 등을 감지하는 데 적합.

### Summary Statistics for Categorical (Q13)
- **최빈값 (Mode)**
- **고유값 수 (Number of unique values)**
- **결측 비율 (% missing)**

세 가지를 함께 모니터링하는 것이 효과적.

## 관련 문제

- Q2: 범주형 결측값 증가 감지 → Two-way Chi-squared
- Q5: 수치형 drift 단순 저비용 방법 → Summary statistics
- Q10: JS vs KS 비교

## 실무 포인트

- 빠른 모니터링이 목적이면 **Summary statistics**부터 시작
- 통계적 엄밀성이 필요하면 **KS test** 또는 **JS distance**
- 범주형은 **Two-way Chi-squared**, 수치형은 **KS / JS**
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (23, 1, 24, 'Jensen-Shannon (JS) Distance', 'monitoring__drift__detection__js_distance', '# Jensen-Shannon (JS) Distance

## 상위 개념

```
ML Monitoring
└── Drift Detection
    └── 수치형 피처 감지
        └── JS Distance   ← 여기
```

## 정의

두 확률 분포 간의 유사도를 측정하는 거리 지표.
KL Divergence를 대칭적으로 개선한 버전이다.

## 특징

- **0~1 사이로 정규화**: 0이면 동일한 분포, 1이면 완전히 다른 분포
- **임계값 설정 불필요**: 값 자체가 직관적으로 해석 가능
- **대칭적**: JS(P, Q) = JS(Q, P)

## KS Test와 비교

→ [ks_test.md](./ks_test.md) 참고

## 한계

- KS test보다 **계산 비용이 높음**
- 연속형 분포에서는 이산화(binning) 과정이 필요

## 관련 문제

- Q10: JS distance를 KS test보다 선호하는 이유 → 임계값 불필요

## 실무 포인트

- 운영 환경에서 자동화된 drift 알람을 설정할 때 유리 (임계값 튜닝 불필요)
- 0.1 이하: 분포 유사, 0.2 이상: drift 의심 (일반적인 기준, 도메인마다 다름)
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (24, 1, 24, 'Kolmogorov-Smirnov (KS) Test', 'monitoring__drift__detection__ks_test', '# Kolmogorov-Smirnov (KS) Test

## 상위 개념

```
ML Monitoring
└── Drift Detection
    └── 수치형 피처 감지
        └── KS Test   ← 여기
```

## 정의

두 확률 분포가 동일한지를 검정하는 비모수 통계 검정.
수치형 피처의 과거 분포와 현재 분포를 비교할 때 사용한다.

## 동작 방식

두 분포의 누적분포함수(CDF)를 비교하여 최대 차이(D-statistic)를 계산한다.

```
D = max|F1(x) - F2(x)|
```

- D가 클수록 두 분포가 다름
- p-value가 임계값(e.g. 0.05) 이하이면 drift로 판단

## JS Distance와 비교

| | KS Test | JS Distance |
|---|---|---|
| **결과값** | p-value (0~1) | 거리값 (0~1) |
| **임계값** | 수동 설정 필요 | 불필요 (0=동일, 1=완전히 다름) |
| **해석** | 통계적 유의성 | 직관적 거리 |
| **대상** | 수치형 | 수치형 |

## 한계

- p-value 기반이므로 **임계값을 수동으로 설정**해야 함
- 샘플 크기에 민감 — 데이터가 많으면 미세한 차이도 유의하게 나올 수 있음

## 관련 문제

- Q2: 범주형 변수에는 KS test 사용 불가 (수치형 전용)
- Q10: JS distance와 KS test 비교

## 실무 포인트

- 수치형 피처 drift 감지의 표준적인 방법
- Summary statistics보다 통계적으로 엄밀하지만 임계값 설정 부담 존재
- JS distance가 임계값 설정이 불필요해 운영 편의성이 높음
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (25, 1, 24, 'Summary Statistics', 'monitoring__drift__detection__summary_statistics', '# Summary Statistics

## 상위 개념

```
ML Monitoring
└── Drift Detection
    ├── 수치형 피처 감지
    │   └── Summary Statistics   ← 여기
    └── 범주형 피처 감지
        └── Summary Statistics   ← 여기도
```

## 정의

피처의 요약 통계량을 시간에 따라 추적하여 drift를 감지하는 방법.
가장 단순하고 비용이 낮은 방식이다.

## 수치형 피처 통계량

| 통계량 | 감지 가능한 변화 |
|---|---|
| 평균 (Mean) | 전체적인 수준 변화 |
| 표준편차 (Std) | 분산 변화 |
| 최솟값 / 최댓값 | 범위 이탈 |
| 중앙값 (Median) | 이상값에 강건한 중심 변화 |

## 범주형 피처 통계량

| 통계량 | 감지 가능한 변화 |
|---|---|
| 최빈값 (Mode) | 주요 범주 변화 |
| 고유값 수 | 새로운 범주 등장 |
| 결측 비율 (% missing) | 데이터 품질 변화 |

## 다른 방법과 비교

| | Summary Statistics | KS Test | JS Distance |
|---|---|---|---|
| **비용** | 낮음 | 중간 | 높음 |
| **엄밀성** | 낮음 | 높음 | 높음 |
| **임계값** | 직관적 설정 | 수동 설정 | 불필요 |
| **대상** | 수치형 + 범주형 | 수치형 | 수치형 |

## 관련 문제

- Q5: 수치형 피처 drift의 단순 저비용 방법 → Summary statistics
- Q13: 범주형 피처 drift 감지 통계량 → Mode, 고유값 수, % missing

## 임계값(Threshold) 설정 — 사람이 직접 정해야 함

Summary Statistics는 drift 여부를 자동으로 판단하지 못한다.
사람이 기준을 정하고, 그 기준으로 판단한다. (단점)

### 임계값 설정 방법 3가지

**1. 절대 임계값** — 단순하게 기준 고정
```
% missing > 5% 넘으면 알람
```

**2. 변화율** — 값 자체가 아니라 변화 속도를 감지
```
어제 대비 0.5% 이상 갑자기 오르면 알람
→ 매일 0.1%씩 천천히 오르는 건 통과
→ 갑자기 하루에 2% 오르면 알람
```

**3. 통계적 기준** — 과거 데이터 기반으로 자동 조정
```
과거 30일 평균 ± 3 표준편차 벗어나면 알람
→ 매일 0.1%씩 오르면 기준도 같이 올라감 → 알람 안 뜸
→ 갑자기 튀면 기준 벗어남 → 알람
```

### 왜 JS Distance는 임계값이 불필요한가

| | Summary Statistics | KS Test | JS Distance |
|---|---|---|---|
| **임계값** | 직관적 설정 (사람) | 수동 설정 (사람) | **불필요 (자동)** |

JS Distance는 0~1 사이로 정규화되어 있어 값 자체가 의미를 가진다.
→ 임계값 없이도 drift 정도를 직접 비교 가능. 그래서 더 발전된 방법.

## 실무 포인트

- 모니터링 시작 단계에서 가장 먼저 적용하기 좋은 방법
- 이상 징후 감지 후 KS test나 JS distance로 심층 분석
- 범주형과 수치형 모두 적용 가능한 유일한 방법
- Summary Statistics는 결국 사람이 임계값을 정해야 해서 엄밀성이 낮음
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (26, 1, 39, 'Concept Drift', 'monitoring__drift__types__concept_drift', '# Concept Drift

## 상위 개념

```
ML Monitoring
└── Model Drift
    ├── Concept Drift      ← 여기
    ├── Feature Drift
    ├── Label Drift
    └── Prediction Drift
```

## 정의

입력 변수(X)와 타겟 변수(y) 사이의 **관계 자체가 변화**하는 현상.
모델이 학습한 패턴이 더 이상 현실을 반영하지 못하게 된다.

> "같은 입력인데 결과가 달라진다"

## 비슷한 개념 비교

| | 정의 | 예시 |
|---|---|---|
| **Concept Drift** | X → y 관계 변화 | 코로나 이후 구매 패턴이 바뀌어 기존 추천 모델이 맞지 않음 |
| Feature Drift | X 분포 변화 | 사용자 연령대가 점점 낮아짐 |
| Label Drift | y 분포 변화 | 사기 거래 비율이 전체적으로 증가 |
| Prediction Drift | 모델 예측값 분포 변화 | 모델이 특정 클래스만 계속 예측함 |

## 감지 방법

Concept drift는 **입력이 아닌 성능 지표**로 감지한다.

1. 예측값 계산
2. 실제 레이블 수집 (지연 발생 가능)
3. 평가 지표(RMSE, accuracy 등) 추이 모니터링
4. 성능 저하 감지 → drift 의심

## 대응 방법

- 최근 데이터로 **재학습**
- 레이블 변수 재정의
- 서비스 종료 (Sunset)

## 관련 문제

- Q1: Concept drift 정의
- Q9: Concept drift 모니터링 3단계

## 실무 포인트

- Feature drift와 혼동 주의: 입력값 범위가 벗어난 건 **Feature drift**, 관계가 바뀐 건 **Concept drift**
- 실제 레이블 수집에 시간이 걸리기 때문에 감지가 늦어질 수 있음
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (27, 1, 39, 'Feature Drift', 'monitoring__drift__types__feature_drift', '# Feature Drift

## 상위 개념

```
ML Monitoring
└── Model Drift
    ├── Concept Drift
    ├── Feature Drift      ← 여기
    ├── Label Drift
    └── Prediction Drift
```

## 정의

입력 변수(X)의 **분포 자체가 변화**하는 현상.
모델이 학습한 입력 범위를 벗어난 데이터가 들어오거나, 입력값의 패턴이 달라진다.

> "입력값이 달라진다"

## 비슷한 개념 비교

→ [concept_drift.md](./concept_drift.md) 참고

## 감지 방법

수치형 피처: Summary statistics, KS test, JS distance
범주형 피처: Two-way Chi-squared, Summary statistics

→ [drift_detection.md](./drift_detection.md) 참고

## 실무 예시

- 아이스크림 판매 예측 모델에서 기온이 학습 데이터 범위 이하로 내려감 (Q6)
- 사용자 연령대가 점점 낮아져 기존 분포와 달라짐
- 특정 범주형 변수에서 결측값 비율이 증가 (Q2)

## 관련 문제

- Q2: 범주형 피처 결측값 증가 감지
- Q6: 입력 변수가 학습 범위를 벗어난 경우

## 실무 포인트

- 입력값 범위 이탈 = Feature drift, 입력-출력 관계 변화 = Concept drift
- Feature drift가 발생해도 모델 성능이 바로 떨어지지 않을 수 있음 (관계가 유지되는 경우)
- 하지만 학습 범위를 벗어난 입력은 모델 신뢰도를 낮춤
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (28, 1, 39, 'Label Drift', 'monitoring__drift__types__label_drift', '# Label Drift

## 상위 개념

```
ML Monitoring
└── Model Drift
    ├── Concept Drift
    ├── Feature Drift
    ├── Label Drift        ← 여기
    └── Prediction Drift
```

## 정의

타겟 변수(y)의 **분포 자체가 변화**하는 현상.
입력과 출력의 관계는 유지되지만, 타겟값의 전체적인 분포가 달라진다.

> "정답 레이블의 비율이 달라진다"

## 비슷한 개념 비교

→ [concept_drift.md](./concept_drift.md) 참고

## 실무 예시

- 사기 탐지 모델에서 전체 사기 거래 비율이 증가
- 감성 분석 모델에서 부정 리뷰 비율이 급증
- 클래스 불균형이 시간에 따라 변화

## 감지 방법

타겟 변수의 분포를 직접 모니터링:
- 클래스별 비율 추이
- 평균, 분산 추이 (수치형 타겟)

## 관련 문제

- Q17: Label drift 정의

## 실무 포인트

- Label drift는 모델 자체의 문제가 아니라 **세상이 바뀐 것**
- 재학습 시 최근 데이터의 레이블 분포를 반영해야 함
- Concept drift와 혼동 주의: 레이블 분포만 바뀐 건 Label drift, 입력-레이블 관계가 바뀐 건 Concept drift
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (29, 1, 39, 'Model Drift — Overview', 'monitoring__drift__types__model_drift', '# Model Drift — Overview

## 상위 개념

```
ML Monitoring
└── Model Drift   ← 여기
    ├── Concept Drift
    ├── Feature Drift
    ├── Label Drift
    └── Prediction Drift
```

## 정의

배포된 모델의 성능이 시간이 지남에 따라 저하되는 현상의 총칭.
학습 시점과 서빙 시점의 데이터 환경이 달라지면서 발생한다.

---

## 4가지 Drift 유형

### Concept Drift
입력(X)과 타겟(y) 사이의 **관계 자체**가 변화.
모델이 학습한 패턴이 현실을 반영하지 못하게 된다.

- 예: 코로나 이후 소비 패턴이 바뀌어 기존 추천 모델이 맞지 않음
- 감지: 예측값 vs 실제값 평가 지표 추이
- → [concept_drift.md](./concept_drift.md)

### Feature Drift
입력 변수(X)의 **분포**가 변화.
모델이 학습한 입력 범위를 벗어난 데이터가 들어오거나 패턴이 달라진다.

- 예: 기온이 학습 데이터 범위 이하로 내려감
- 감지: KS test, JS distance, Summary statistics, Chi-squared
- → [feature_drift.md](./feature_drift.md)

### Label Drift
타겟 변수(y)의 **분포**가 변화.
입력-출력 관계는 유지되지만 정답 레이블의 비율이 달라진다.

- 예: 사기 거래 비율이 전체적으로 증가
- 감지: 클래스별 비율 추이, 타겟 분포 모니터링
- → [label_drift.md](./label_drift.md)

### Prediction Drift
모델 **예측값의 분포**가 변화.
실제 레이블 없이도 감지할 수 있어 가장 빠른 초기 신호가 된다.

- 예: 분류 모델이 특정 클래스만 집중적으로 예측하기 시작
- 감지: 예측값 분포, 클래스별 예측 비율 추이
- → [prediction_drift.md](./prediction_drift.md)

---

## 4가지 비교

| | 무엇이 변하나 | 실제 레이블 필요 | 감지 시점 |
|---|---|---|---|
| **Concept Drift** | X → y 관계 | 필요 | 느림 |
| **Feature Drift** | X 분포 | 불필요 | 빠름 |
| **Label Drift** | y 분포 | 필요 | 중간 |
| **Prediction Drift** | 예측값 분포 | 불필요 | 가장 빠름 |

---

## Drift 발생 순서 (일반적)

```
Feature Drift 발생
    → Prediction Drift 변화 (즉시 감지 가능)
        → 실제 레이블 수집 후 Concept/Label Drift 확인
            → 성능 저하 확인 → 대응
```

## 대응 방법

- **재학습**: 최근 데이터로 모델 재학습 (가장 일반적)
- **레이블 재정의**: 타겟 변수 자체를 재설계
- **서비스 종료**: 모델이 더 이상 유효하지 않을 때

## 관련 문제

- Q1: Concept drift 정의
- Q6: Feature drift 실무 예시
- Q9: Concept drift 모니터링 단계
- Q14: Drift 대응 방법
- Q17: Label drift 정의
', '2026-04-15 08:40:38.88699+00');
INSERT INTO public.concepts VALUES (30, 1, 39, 'Prediction Drift', 'monitoring__drift__types__prediction_drift', '# Prediction Drift

## 상위 개념

```
ML Monitoring
└── Model Drift
    ├── Concept Drift
    ├── Feature Drift
    ├── Label Drift
    └── Prediction Drift   ← 여기
```

## 정의

모델이 출력하는 **예측값의 분포가 변화**하는 현상.
실제 레이블 없이도 감지할 수 있다는 점이 다른 drift와의 차이점이다.

> "모델이 예측하는 값의 패턴이 달라진다"

## 비슷한 개념 비교

→ [concept_drift.md](./concept_drift.md) 참고

## 실무 예시

- 추천 모델이 특정 아이템만 계속 추천하기 시작
- 분류 모델이 특정 클래스만 집중적으로 예측
- 예측 점수의 평균이 시간이 지나면서 한쪽으로 치우침

## 감지 방법

실제 레이블 없이 **예측값만으로** 모니터링 가능:
- 예측값 분포 추이
- 클래스별 예측 비율
- 예측 점수 평균/분산

## 왜 중요한가

실제 레이블(정답)은 수집에 시간이 걸리지만,
예측값은 즉시 확인 가능 → **가장 빠르게 감지할 수 있는 drift 신호**

## 관련 문제

- Q1: Prediction drift 정의 (오답 선지로 등장)

## 실무 포인트

- Label drift나 Concept drift의 **초기 신호**로 활용 가능
- 예측 분포가 바뀌었다고 바로 재학습하는 건 위험 → 원인 파악 후 대응
', '2026-04-15 08:40:38.88699+00');


--
-- Data for Name: question_concepts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.question_concepts VALUES (58, 1, 'Databricks Job 프로그래밍 방식 생성 → Databricks REST APIs');
INSERT INTO public.question_concepts VALUES (59, 1, 'Webhook 목록 조회 API method → POST → GET으로 변경');
INSERT INTO public.question_concepts VALUES (16, 2, '컬럼이 언제 삭제됐는지 확인 → DESCRIBE HISTORY');
INSERT INTO public.question_concepts VALUES (7, 3, '경로 기반 Delta 테이블에서 컬럼 삭제');
INSERT INTO public.question_concepts VALUES (39, 4, '분산된 행을 모아 유사 레코드를 colocate하는 최적화 → Z-Ordering');
INSERT INTO public.question_concepts VALUES (33, 5, 'Real-time 배포 시 소프트웨어를 종속성과 함께 패키징하는 도구 → Containers');
INSERT INTO public.question_concepts VALUES (18, 6, '가장 일반적인 배포 방식 → Batch');
INSERT INTO public.question_concepts VALUES (24, 6, '단일 레코드 빠른 중앙 예측 → Real-time');
INSERT INTO public.question_concepts VALUES (25, 6, '연속 데이터 마이크로 배치 → Structured Streaming');
INSERT INTO public.question_concepts VALUES (31, 6, 'Spark 스트리밍 배포 특징 → Incremental inference on trigger');
INSERT INTO public.question_concepts VALUES (40, 6, '피처가 미리 준비된 경우 Batch 선호 이유 → 저장된 예측값 빠른 조회');
INSERT INTO public.question_concepts VALUES (44, 6, '요청 시 피처 + 빠른 단일 레코드 → Real-time');
INSERT INTO public.question_concepts VALUES (45, 6, 'Batch → Streaming 전환 변경점 → `spark.read` → `spark.readStream`');
INSERT INTO public.question_concepts VALUES (8, 7, 'Feature Store에서 Spark DataFrame 반환 → `fs.read_table`');
INSERT INTO public.question_concepts VALUES (15, 7, 'Feature Store 테이블 덮어쓰기 → `fs.write_table(..., mode="overwrite")`');
INSERT INTO public.question_concepts VALUES (29, 7, '테이블 생성과 동시에 데이터 적재 → `fs.create_table(..., df=features_df)`');
INSERT INTO public.question_concepts VALUES (43, 7, 'Feature Store 연동 배치 추론 → `fs.score_batch()`');
INSERT INTO public.question_concepts VALUES (19, 8, '전역 autologging 활성화 → `mlflow.autolog()`');
INSERT INTO public.question_concepts VALUES (28, 8, 'Hyperopt + autologging parent/child 구조');
INSERT INTO public.question_concepts VALUES (11, 9, '실험 결과를 Spark DataFrame으로 조회 → `spark.read.format("mlflow-experiment").load(exp_id)`');
INSERT INTO public.question_concepts VALUES (37, 10, 'MLflow Model Flavor의 목적 → 배포 도구가 모델을 이해하도록');
INSERT INTO public.question_concepts VALUES (42, 10, 'context 파라미터 목적 → 아티팩트/설정 접근');
INSERT INTO public.question_concepts VALUES (49, 10, 'pyfunc의 장점 → 라이브러리 독립적 배포');
INSERT INTO public.question_concepts VALUES (52, 10, 'Custom pyfunc의 이점 → predict 시 전처리 자동 적용');
INSERT INTO public.question_concepts VALUES (4, 11, 'CSV 파일 로깅 → `log_artifact`');
INSERT INTO public.question_concepts VALUES (20, 11, 'RMSE 저장 → `log_metric`');
INSERT INTO public.question_concepts VALUES (27, 11, '트리 수 저장 → `log_param`');
INSERT INTO public.question_concepts VALUES (35, 11, '시각화 파일 조회 위치 → Run Artifacts');
INSERT INTO public.question_concepts VALUES (12, 12, '`feature_importances_` 접근 → `mlflow.sklearn.load_model`');
INSERT INTO public.question_concepts VALUES (34, 12, '배치 배포용 모델 로드 → `mlflow.pyfunc.load_model`');
INSERT INTO public.question_concepts VALUES (26, 13, 'Model Serving 자동 배포 Stage → None, Staging, Production');
INSERT INTO public.question_concepts VALUES (32, 13, 'Production 모델 조회 URI → `https://<host>/model/<name>/Production/invocations`');
INSERT INTO public.question_concepts VALUES (3, 14, 'Nested run이 올바르게 동작하지 않을 때 수정 방법');
INSERT INTO public.question_concepts VALUES (28, 14, 'Hyperopt + MLflow로 parent/child run 구성');
INSERT INTO public.question_concepts VALUES (46, 15, '모델 등록 → `mlflow.register_model(model_uri, "best_model")`');
INSERT INTO public.question_concepts VALUES (47, 15, 'Staging → Production 전환 → `transition_model_version_stage`');
INSERT INTO public.question_concepts VALUES (48, 15, '기존 모델에 새 버전 추가 → `mlflow.register_model`');
INSERT INTO public.question_concepts VALUES (50, 15, 'Registry stage 목록 → None, Staging, Production, Archived');
INSERT INTO public.question_concepts VALUES (53, 15, '모델 설명 업데이트 → `update_registered_model` (변경 불필요)');
INSERT INTO public.question_concepts VALUES (54, 15, 'Production 전환 + 기존 버전 archive → `archive_existing_versions=True`');
INSERT INTO public.question_concepts VALUES (55, 15, '중앙 모델 저장소 → Model Registry');
INSERT INTO public.question_concepts VALUES (57, 15, '모델 삭제 → `delete_registered_model`');
INSERT INTO public.question_concepts VALUES (21, 16, 'SHAP feature importance 자동 계산 및 로깅 → `mlflow.shap.log_explanation`');
INSERT INTO public.question_concepts VALUES (22, 17, '로깅 전 모델의 입출력 스키마 추론 → `mlflow.models.signature.infer_signature`');
INSERT INTO public.question_concepts VALUES (30, 17, 'Signature 로깅의 이점 → 서빙 시 입력 스키마 검증');
INSERT INTO public.question_concepts VALUES (41, 18, 'spark_udf로 배치 추론 함수 생성 → 첫 번째 인자는 `spark` 세션');
INSERT INTO public.question_concepts VALUES (38, 19, 'CI/CD 트리거 → 새 모델 버전 등록 시');
INSERT INTO public.question_concepts VALUES (51, 19, 'HTTP Webhook 사용 사례 → Slack 메시지 전송');
INSERT INTO public.question_concepts VALUES (56, 19, '모든 스테이지 전환 트리거 이벤트 → `MODEL_VERSION_TRANSITIONED_STAGE`');
INSERT INTO public.question_concepts VALUES (59, 19, 'Webhook 목록 조회 API → POST → GET으로 변경');
INSERT INTO public.question_concepts VALUES (60, 19, 'Staging 전환 Webhook 트리거 → `transition_model_version_stage(..., stage="Staging")`');
INSERT INTO public.question_concepts VALUES (2, 20, '범주형 피처 결측값 증가 감지 → Two-way Chi-squared');
INSERT INTO public.question_concepts VALUES (30, 20, 'MLflow Signature로 입력 스키마 검증');
INSERT INTO public.question_concepts VALUES (2, 21, '범주형 결측값 증가 감지 → Two-way Chi-squared');
INSERT INTO public.question_concepts VALUES (2, 22, '범주형 결측값 증가 감지 → Two-way Chi-squared');
INSERT INTO public.question_concepts VALUES (5, 22, '수치형 drift 단순 저비용 방법 → Summary statistics');
INSERT INTO public.question_concepts VALUES (10, 22, 'JS vs KS 비교');
INSERT INTO public.question_concepts VALUES (10, 23, 'JS distance를 KS test보다 선호하는 이유 → 임계값 불필요');
INSERT INTO public.question_concepts VALUES (2, 24, '범주형 변수에는 KS test 사용 불가 (수치형 전용)');
INSERT INTO public.question_concepts VALUES (10, 24, 'JS distance와 KS test 비교');
INSERT INTO public.question_concepts VALUES (5, 25, '수치형 피처 drift의 단순 저비용 방법 → Summary statistics');
INSERT INTO public.question_concepts VALUES (13, 25, '범주형 피처 drift 감지 통계량 → Mode, 고유값 수, % missing');
INSERT INTO public.question_concepts VALUES (1, 26, 'Concept drift 정의');
INSERT INTO public.question_concepts VALUES (9, 26, 'Concept drift 모니터링 3단계');
INSERT INTO public.question_concepts VALUES (2, 27, '범주형 피처 결측값 증가 감지');
INSERT INTO public.question_concepts VALUES (6, 27, '입력 변수가 학습 범위를 벗어난 경우');
INSERT INTO public.question_concepts VALUES (17, 28, 'Label drift 정의');
INSERT INTO public.question_concepts VALUES (1, 29, 'Concept drift 정의');
INSERT INTO public.question_concepts VALUES (6, 29, 'Feature drift 실무 예시');
INSERT INTO public.question_concepts VALUES (9, 29, 'Concept drift 모니터링 단계');
INSERT INTO public.question_concepts VALUES (14, 29, 'Drift 대응 방법');
INSERT INTO public.question_concepts VALUES (17, 29, 'Label drift 정의');
INSERT INTO public.question_concepts VALUES (1, 30, 'Prediction drift 정의 (오답 선지로 등장)');


--
-- Data for Name: question_options; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.question_options VALUES (1, 1, 1, 'Concept drift is when there is a change in the distribution of an input variable');
INSERT INTO public.question_options VALUES (2, 1, 2, 'Concept drift is when there is a change in the distribution of a target variable');
INSERT INTO public.question_options VALUES (3, 1, 3, 'Concept drift is when there is a change in the relationship between input variables and target variables');
INSERT INTO public.question_options VALUES (4, 1, 4, 'Concept drift is when there is a change in the distribution of the predicted target given by the model');
INSERT INTO public.question_options VALUES (5, 1, 5, 'None of these describe Concept drift');
INSERT INTO public.question_options VALUES (6, 2, 1, 'Kolmogorov-Smirnov (KS) test');
INSERT INTO public.question_options VALUES (7, 2, 2, 'One-way Chi-squared Test');
INSERT INTO public.question_options VALUES (8, 2, 3, 'Two-way Chi-squared Test');
INSERT INTO public.question_options VALUES (9, 2, 4, 'Jensen-Shannon distance');
INSERT INTO public.question_options VALUES (10, 2, 5, 'None of these');
INSERT INTO public.question_options VALUES (11, 3, 1, 'Indent the child run blocks within the parent run block');
INSERT INTO public.question_options VALUES (12, 3, 2, 'Add the `nested=True` argument to the parent run');
INSERT INTO public.question_options VALUES (13, 3, 3, 'Remove the `nested=True` argument from the child runs');
INSERT INTO public.question_options VALUES (14, 3, 4, 'Provide the same name to the `run_name` parameter for all run blocks');
INSERT INTO public.question_options VALUES (15, 3, 5, 'Add `nested=True` to the parent run and remove `nested=True` from the child runs');
INSERT INTO public.question_options VALUES (16, 4, 1, '```python
mlflow.log_model_and_data(
    model,
    importance_path,
    "feature-importance.csv"
)
```');
INSERT INTO public.question_options VALUES (17, 4, 2, '```python
mlflow.log_model(
    model,
    importance_path,
    "feature-importance.csv"
)
```');
INSERT INTO public.question_options VALUES (18, 4, 3, '```python
mlflow.log_data(importance_path, "feature-importance.csv")
```');
INSERT INTO public.question_options VALUES (19, 4, 4, '```python
mlflow.log_artifact(importance_path, "feature-importance.csv")
```');
INSERT INTO public.question_options VALUES (20, 4, 5, 'None of these');
INSERT INTO public.question_options VALUES (21, 5, 1, 'Jensen-Shannon test');
INSERT INTO public.question_options VALUES (22, 5, 2, 'Summary statistics trends');
INSERT INTO public.question_options VALUES (23, 5, 3, 'Chi-squared test');
INSERT INTO public.question_options VALUES (24, 5, 4, 'None of these can be used to monitor feature drift');
INSERT INTO public.question_options VALUES (25, 5, 5, 'Kolmogorov-Smirnov (KS) test');
INSERT INTO public.question_options VALUES (26, 6, 1, 'Label drift');
INSERT INTO public.question_options VALUES (27, 6, 2, 'None of these');
INSERT INTO public.question_options VALUES (28, 6, 3, 'Concept drift');
INSERT INTO public.question_options VALUES (29, 6, 4, 'Prediction drift');
INSERT INTO public.question_options VALUES (30, 6, 5, 'Feature drift');
INSERT INTO public.question_options VALUES (31, 7, 1, '```python
spark.read.format("delta").load(path).drop("star_rating")
```');
INSERT INTO public.question_options VALUES (32, 7, 2, '```python
spark.read.format("delta").table(path).drop("star_rating")
```');
INSERT INTO public.question_options VALUES (33, 7, 3, 'Delta tables cannot be modified');
INSERT INTO public.question_options VALUES (34, 7, 4, '```python
spark.read.table(path).drop("star_rating")
```');
INSERT INTO public.question_options VALUES (35, 7, 5, '```sql
SELECT * EXCEPT star_rating FROM path
```');
INSERT INTO public.question_options VALUES (36, 8, 1, '`fs.create_table`');
INSERT INTO public.question_options VALUES (37, 8, 2, '`fs.write_table`');
INSERT INTO public.question_options VALUES (38, 8, 3, '`fs.get_table`');
INSERT INTO public.question_options VALUES (39, 8, 4, 'There is no way to accomplish this task with `fs`');
INSERT INTO public.question_options VALUES (40, 8, 5, '`fs.read_table`');
INSERT INTO public.question_options VALUES (41, 9, 1, 'Obtain the observed feature values');
INSERT INTO public.question_options VALUES (42, 9, 2, 'Measure the latency of the prediction time');
INSERT INTO public.question_options VALUES (43, 9, 3, 'Retrain the model');
INSERT INTO public.question_options VALUES (44, 9, 4, 'None of these should be completed as Step 3');
INSERT INTO public.question_options VALUES (45, 9, 5, 'Compute the evaluation metric using the observed and predicted values');
INSERT INTO public.question_options VALUES (46, 10, 1, 'All of these reasons');
INSERT INTO public.question_options VALUES (47, 10, 2, 'JS is not normalized or smoothed');
INSERT INTO public.question_options VALUES (48, 10, 3, 'None of these reasons');
INSERT INTO public.question_options VALUES (49, 10, 4, 'JS is more robust when working with large datasets');
INSERT INTO public.question_options VALUES (50, 10, 5, 'JS does not require any manual threshold or cutoff determinations');
INSERT INTO public.question_options VALUES (51, 11, 1, '`client.list_run_infos(exp_id)`');
INSERT INTO public.question_options VALUES (52, 11, 2, '`spark.read.format("delta").load(exp_id)`');
INSERT INTO public.question_options VALUES (53, 11, 3, 'There is no way to programmatically return row-level results');
INSERT INTO public.question_options VALUES (54, 11, 4, '`mlflow.search_runs(exp_id)`');
INSERT INTO public.question_options VALUES (55, 11, 5, '`spark.read.format("mlflow-experiment").load(exp_id)`');
INSERT INTO public.question_options VALUES (56, 12, 1, '`mlflow.load_model(model_uri)`');
INSERT INTO public.question_options VALUES (57, 12, 2, '`client.list_artifacts(run_id)["feature-importances.csv"]`');
INSERT INTO public.question_options VALUES (58, 12, 3, '`mlflow.sklearn.load_model(model_uri)`');
INSERT INTO public.question_options VALUES (59, 12, 4, 'Only available in UI');
INSERT INTO public.question_options VALUES (60, 12, 5, '`client.pyfunc.load_model(model_uri)`');
INSERT INTO public.question_options VALUES (61, 13, 1, 'Mode');
INSERT INTO public.question_options VALUES (62, 13, 2, 'None');
INSERT INTO public.question_options VALUES (63, 13, 3, 'Mode, number of unique values, and % missing');
INSERT INTO public.question_options VALUES (64, 13, 4, '% missing');
INSERT INTO public.question_options VALUES (65, 13, 5, 'Number of unique values');
INSERT INTO public.question_options VALUES (66, 14, 1, 'None');
INSERT INTO public.question_options VALUES (67, 14, 2, 'Retrain on recent data');
INSERT INTO public.question_options VALUES (68, 14, 3, 'All of these');
INSERT INTO public.question_options VALUES (69, 14, 4, 'Change label variable');
INSERT INTO public.question_options VALUES (70, 14, 5, 'Sunset application');
INSERT INTO public.question_options VALUES (71, 15, 1, '```python
fs.create_table(
    name="features",
    df=features_df,
    mode="overwrite"
)
```');
INSERT INTO public.question_options VALUES (72, 15, 2, '```python
fs.write_table(
    name="features",
    df=features_df
)
```');
INSERT INTO public.question_options VALUES (73, 15, 3, '```python
fs.write_table(
    name="features",
    df=features_df,
    mode="merge"
)
```');
INSERT INTO public.question_options VALUES (74, 15, 4, '```python
fs.write_table(
    name="features",
    df=features_df,
    mode="overwrite"
)
```');
INSERT INTO public.question_options VALUES (75, 15, 5, '```python
fs.create_table(
    name="features",
    df=features_df,
    mode="merge"
)
```');
INSERT INTO public.question_options VALUES (76, 16, 1, '`VERSION`');
INSERT INTO public.question_options VALUES (77, 16, 2, '`DESCRIBE`');
INSERT INTO public.question_options VALUES (78, 16, 3, '`HISTORY`');
INSERT INTO public.question_options VALUES (79, 16, 4, '`DESCRIBE HISTORY`');
INSERT INTO public.question_options VALUES (80, 16, 5, '`TIMESTAMP`');
INSERT INTO public.question_options VALUES (81, 17, 1, 'Change in predicted target distribution');
INSERT INTO public.question_options VALUES (82, 17, 2, 'None');
INSERT INTO public.question_options VALUES (83, 17, 3, 'Change in input variable distribution');
INSERT INTO public.question_options VALUES (84, 17, 4, 'Change in relationship between inputs and target');
INSERT INTO public.question_options VALUES (85, 17, 5, 'Change in target variable distribution');
INSERT INTO public.question_options VALUES (86, 18, 1, 'On-device');
INSERT INTO public.question_options VALUES (87, 18, 2, 'Streaming');
INSERT INTO public.question_options VALUES (88, 18, 3, 'Real-time');
INSERT INTO public.question_options VALUES (89, 18, 4, 'Batch');
INSERT INTO public.question_options VALUES (90, 18, 5, 'None');
INSERT INTO public.question_options VALUES (91, 19, 1, '`mlflow.sklearn.autolog()`');
INSERT INTO public.question_options VALUES (92, 19, 2, '`mlflow.spark.autolog()`');
INSERT INTO public.question_options VALUES (93, 19, 3, '`spark.conf.set("autologging", True)`');
INSERT INTO public.question_options VALUES (94, 19, 4, 'Not possible');
INSERT INTO public.question_options VALUES (95, 19, 5, '`mlflow.autolog()`');
INSERT INTO public.question_options VALUES (96, 20, 1, '`log_artifact`');
INSERT INTO public.question_options VALUES (97, 20, 2, '`log_model`');
INSERT INTO public.question_options VALUES (98, 20, 3, '`log_metric`');
INSERT INTO public.question_options VALUES (99, 20, 4, '`log_param`');
INSERT INTO public.question_options VALUES (100, 20, 5, 'Not possible');
INSERT INTO public.question_options VALUES (101, 21, 1, '`mlflow.shap.log_explanation`');
INSERT INTO public.question_options VALUES (102, 21, 2, 'None of these operations can accomplish the task.');
INSERT INTO public.question_options VALUES (103, 21, 3, '`mlflow.shap`');
INSERT INTO public.question_options VALUES (104, 21, 4, '`mlflow.log_figure`');
INSERT INTO public.question_options VALUES (105, 21, 5, '`client.log_artifact`');
INSERT INTO public.question_options VALUES (106, 22, 1, '`mlflow.models.schema.infer_schema`');
INSERT INTO public.question_options VALUES (107, 22, 2, '`mlflow.models.signature.infer_signature`');
INSERT INTO public.question_options VALUES (108, 22, 3, '`mlflow.models.Model.get_input_schema`');
INSERT INTO public.question_options VALUES (109, 22, 4, '`mlflow.models.Model.signature`');
INSERT INTO public.question_options VALUES (110, 22, 5, 'There is no way to obtain the schema of an unlogged model');
INSERT INTO public.question_options VALUES (111, 23, 1, 'Because the streaming deployment is always on, all types of data must be handled without producing an error');
INSERT INTO public.question_options VALUES (112, 23, 2, 'All of these statements');
INSERT INTO public.question_options VALUES (113, 23, 3, 'Because there is no practitioner to debug poor model performance');
INSERT INTO public.question_options VALUES (114, 23, 4, 'Because autoscaling must be validated');
INSERT INTO public.question_options VALUES (115, 23, 5, 'None of these statements');
INSERT INTO public.question_options VALUES (116, 24, 1, 'Streaming');
INSERT INTO public.question_options VALUES (117, 24, 2, 'Batch');
INSERT INTO public.question_options VALUES (118, 24, 3, 'Edge/on-device');
INSERT INTO public.question_options VALUES (119, 24, 4, 'None of these');
INSERT INTO public.question_options VALUES (120, 24, 5, 'Real-time');
INSERT INTO public.question_options VALUES (121, 25, 1, 'Spark UDFs');
INSERT INTO public.question_options VALUES (122, 25, 2, 'Structured Streaming');
INSERT INTO public.question_options VALUES (123, 25, 3, 'MLflow');
INSERT INTO public.question_options VALUES (124, 25, 4, 'Delta Lake');
INSERT INTO public.question_options VALUES (125, 25, 5, 'AutoML');
INSERT INTO public.question_options VALUES (126, 26, 1, 'Staging, Production, Archived');
INSERT INTO public.question_options VALUES (127, 26, 2, 'Production');
INSERT INTO public.question_options VALUES (128, 26, 3, 'None, Staging, Production, Archived');
INSERT INTO public.question_options VALUES (129, 26, 4, 'Staging, Production');
INSERT INTO public.question_options VALUES (130, 26, 5, 'None, Staging, Production');
INSERT INTO public.question_options VALUES (131, 27, 1, '`mlflow.log_artifact`');
INSERT INTO public.question_options VALUES (132, 27, 2, '`mlflow.log_model`');
INSERT INTO public.question_options VALUES (133, 27, 3, '`mlflow.log_metric`');
INSERT INTO public.question_options VALUES (134, 27, 4, '`mlflow.log_param`');
INSERT INTO public.question_options VALUES (135, 27, 5, 'Not possible');
INSERT INTO public.question_options VALUES (136, 28, 1, 'Start a manual parent run before calling `fmin`');
INSERT INTO public.question_options VALUES (137, 28, 2, 'Use built-in model flavor');
INSERT INTO public.question_options VALUES (138, 28, 3, 'Start a child run in `objective_function`');
INSERT INTO public.question_options VALUES (139, 28, 4, 'Not possible');
INSERT INTO public.question_options VALUES (140, 28, 5, 'Autologging automatically handles it');
INSERT INTO public.question_options VALUES (141, 29, 1, '```python
fs.create_table(
    name="new_table",
    primary_keys="customer_id",
    df=features_df,
    description="Customer features"
)
```');
INSERT INTO public.question_options VALUES (142, 29, 2, '```python
fs.create_table(
    name="new_table",
    primary_keys="customer_id",
    description="Customer features"
)
```');
INSERT INTO public.question_options VALUES (143, 29, 3, '```python
features_df.write.mode("fs").path("new_table")
```');
INSERT INTO public.question_options VALUES (144, 29, 4, '```python
fs.create_table(
    name="new_table",
    primary_keys="customer_id",
    function=compute_features,
    description="Customer features"
)
```');
INSERT INTO public.question_options VALUES (145, 29, 5, '```python
features_df.write.mode("feature").path("new_table")
```');
INSERT INTO public.question_options VALUES (146, 30, 1, 'Unique identifier in experiment');
INSERT INTO public.question_options VALUES (147, 30, 2, 'Input schema validation during serving');
INSERT INTO public.question_options VALUES (148, 30, 3, 'Enables real-time deployment');
INSERT INTO public.question_options VALUES (149, 30, 4, 'Secures the model');
INSERT INTO public.question_options VALUES (150, 30, 5, 'Automatically converts schema');
INSERT INTO public.question_options VALUES (151, 31, 1, 'Batch inference on trigger');
INSERT INTO public.question_options VALUES (152, 31, 2, 'Real-time inference for all data');
INSERT INTO public.question_options VALUES (153, 31, 3, 'Batch inference on job run');
INSERT INTO public.question_options VALUES (154, 31, 4, 'Incremental inference on trigger');
INSERT INTO public.question_options VALUES (155, 31, 5, 'Incremental inference on job run');
INSERT INTO public.question_options VALUES (156, 32, 1, '`https://<host>/model-serving/recommender/Production/invocations`');
INSERT INTO public.question_options VALUES (157, 32, 2, 'Requires version number');
INSERT INTO public.question_options VALUES (158, 32, 3, '`https://<host>/model/recommender/stage-production/invocations`');
INSERT INTO public.question_options VALUES (159, 32, 4, '`https://<host>/model-serving/recommender/stage-production/invocations`');
INSERT INTO public.question_options VALUES (160, 32, 5, '`https://<host>/model/recommender/Production/invocations`');
INSERT INTO public.question_options VALUES (161, 33, 1, 'Cloud compute');
INSERT INTO public.question_options VALUES (162, 33, 2, 'None');
INSERT INTO public.question_options VALUES (163, 33, 3, 'REST APIs');
INSERT INTO public.question_options VALUES (164, 33, 4, 'Containers');
INSERT INTO public.question_options VALUES (165, 33, 5, 'Autoscaling clusters');
INSERT INTO public.question_options VALUES (166, 34, 1, '`mlflow.spark.load_model(model_uri)`');
INSERT INTO public.question_options VALUES (167, 34, 2, '`mlflow.pyfunc.read_model(model_uri)`');
INSERT INTO public.question_options VALUES (168, 34, 3, '`mlflow.sklearn.read_model(model_uri)`');
INSERT INTO public.question_options VALUES (169, 34, 4, '`mlflow.pyfunc.load_model(model_uri)`');
INSERT INTO public.question_options VALUES (170, 34, 5, '`mlflow.sklearn.load_model(model_uri)`');
INSERT INTO public.question_options VALUES (171, 35, 1, 'Model Registry page');
INSERT INTO public.question_options VALUES (172, 35, 2, 'Experiment Artifacts');
INSERT INTO public.question_options VALUES (173, 35, 3, 'Cannot view');
INSERT INTO public.question_options VALUES (174, 35, 4, 'Run Artifacts');
INSERT INTO public.question_options VALUES (175, 35, 5, 'Run Figures');
INSERT INTO public.question_options VALUES (176, 36, 1, '`mlflow.spark.track_model(sklearn_model, "model")`');
INSERT INTO public.question_options VALUES (177, 36, 2, '`mlflow.sklearn.log_model(sklearn_model, "model")`');
INSERT INTO public.question_options VALUES (178, 36, 3, '`mlflow.spark.log_model(sklearn_model, "model")`');
INSERT INTO public.question_options VALUES (179, 36, 4, '`mlflow.sklearn.load_model("model")`');
INSERT INTO public.question_options VALUES (180, 36, 5, '`mlflow.sklearn.track_model(sklearn_model, "model")`');
INSERT INTO public.question_options VALUES (181, 37, 1, 'Wrap preprocessing logic');
INSERT INTO public.question_options VALUES (182, 37, 2, 'Version models');
INSERT INTO public.question_options VALUES (183, 37, 3, 'Organize runs');
INSERT INTO public.question_options VALUES (184, 37, 4, 'Help deployment tools understand models');
INSERT INTO public.question_options VALUES (185, 37, 5, 'Organize models');
INSERT INTO public.question_options VALUES (186, 38, 1, 'New SQL endpoint');
INSERT INTO public.question_options VALUES (187, 38, 2, 'Not needed');
INSERT INTO public.question_options VALUES (188, 38, 3, 'New feature table');
INSERT INTO public.question_options VALUES (189, 38, 4, 'New cluster');
INSERT INTO public.question_options VALUES (190, 38, 5, 'New model version in MLflow Registry');
INSERT INTO public.question_options VALUES (191, 39, 1, 'Z-Ordering');
INSERT INTO public.question_options VALUES (192, 39, 2, 'Bin-packing');
INSERT INTO public.question_options VALUES (193, 39, 3, 'Parquet');
INSERT INTO public.question_options VALUES (194, 39, 4, 'Data skipping');
INSERT INTO public.question_options VALUES (195, 39, 5, 'File size tuning');
INSERT INTO public.question_options VALUES (196, 40, 1, 'Built-in Databricks support');
INSERT INTO public.question_options VALUES (197, 40, 2, 'No advantage');
INSERT INTO public.question_options VALUES (198, 40, 3, 'More up-to-date results');
INSERT INTO public.question_options VALUES (199, 40, 4, 'Real-time cannot be tested');
INSERT INTO public.question_options VALUES (200, 40, 5, 'Stored predictions are faster to query');
INSERT INTO public.question_options VALUES (201, 41, 1, '```python
predict = mlflow.pyfunc.spark_udf(
    spark_df,
    f"runs:/{run_id}/random_forest_model"
)
```');
INSERT INTO public.question_options VALUES (202, 41, 2, 'It is not possible');
INSERT INTO public.question_options VALUES (203, 41, 3, '```python
predict = sklearn.spark_udf(
    spark_df,
    f"runs:/{run_id}/random_forest_model"
)
```');
INSERT INTO public.question_options VALUES (204, 41, 4, '```python
predict = spark.spark_udf(
    f"runs:/{run_id}/random_forest_model"
)
```');
INSERT INTO public.question_options VALUES (205, 41, 5, '```python
predict = mlflow.pyfunc.spark_udf(
    spark,
    f"runs:/{run_id}/random_forest_model"
)
```');
INSERT INTO public.question_options VALUES (206, 42, 1, 'Specify model version');
INSERT INTO public.question_options VALUES (207, 42, 2, 'Log performance');
INSERT INTO public.question_options VALUES (208, 42, 3, 'Document business context');
INSERT INTO public.question_options VALUES (209, 42, 4, 'Add custom logic');
INSERT INTO public.question_options VALUES (210, 42, 5, 'Provide access to artifacts/config (e.g., preprocessing models)');
INSERT INTO public.question_options VALUES (211, 43, 1, '```python
df = fs.get_missing_features(spark_df, model_uri)
fs.score_model(model_uri, df)
```');
INSERT INTO public.question_options VALUES (212, 43, 2, '```python
fs.score_model(model_uri, spark_df)
```');
INSERT INTO public.question_options VALUES (213, 43, 3, '```python
df = fs.get_missing_features(spark_df, model_uri)
fs.score_batch(model_uri, df)
```');
INSERT INTO public.question_options VALUES (214, 43, 4, '```python
df = fs.get_missing_features(spark_df)
fs.score_batch(model_uri, df)
```');
INSERT INTO public.question_options VALUES (215, 43, 5, '```python
fs.score_batch(model_uri, spark_df)
```');
INSERT INTO public.question_options VALUES (216, 44, 1, 'Edge/on-device');
INSERT INTO public.question_options VALUES (217, 44, 2, 'Streaming');
INSERT INTO public.question_options VALUES (218, 44, 3, 'None');
INSERT INTO public.question_options VALUES (219, 44, 4, 'Batch');
INSERT INTO public.question_options VALUES (220, 44, 5, 'Real-time');
INSERT INTO public.question_options VALUES (221, 45, 1, 'Replace table name with path');
INSERT INTO public.question_options VALUES (222, 45, 2, 'Replace schema with `maxFilesPerTrigger`');
INSERT INTO public.question_options VALUES (223, 45, 3, 'Replace `spark.read` with `spark.readStream`');
INSERT INTO public.question_options VALUES (224, 45, 4, 'Replace format with `"stream"`');
INSERT INTO public.question_options VALUES (225, 45, 5, 'Replace predict function');
INSERT INTO public.question_options VALUES (226, 46, 1, '`mlflow.register_model(model_uri, "best_model")`');
INSERT INTO public.question_options VALUES (227, 46, 2, '`mlflow.register_model(run_id, "best_model")`');
INSERT INTO public.question_options VALUES (228, 46, 3, '`mlflow.register_model(f"runs:/{run_id}/best_model", "model")`');
INSERT INTO public.question_options VALUES (229, 46, 4, '`mlflow.register_model(model_uri, "model")`');
INSERT INTO public.question_options VALUES (230, 46, 5, '`mlflow.register_model(f"runs:/{run_id}/model")`');
INSERT INTO public.question_options VALUES (231, 47, 1, '```python
client.transition_model_version_stage(
    name=model,
    version=model_version,
    stage="Staging"
)
```');
INSERT INTO public.question_options VALUES (232, 47, 2, '```python
client.transition_model_stage(
    name=model,
    version=model_version,
    stage="Production"
)
```');
INSERT INTO public.question_options VALUES (233, 47, 3, '```python
client.transition_model_version_stage(
    name=model,
    version=model_version,
    stage="Production"
)
```');
INSERT INTO public.question_options VALUES (234, 47, 4, '```python
client.transition_model__stage(
    name=model,
    version=model_version,
    from="Staging",
    to="Production"
)
```');
INSERT INTO public.question_options VALUES (235, 47, 5, '```python
client.transition_model_version_stage(
    name=model,
    version=model_version,
    from="Staging",
    to="Production"
)
```');
INSERT INTO public.question_options VALUES (236, 48, 1, '`mlflow.register_model`');
INSERT INTO public.question_options VALUES (237, 48, 2, '`MlflowClient.update_registered_model`');
INSERT INTO public.question_options VALUES (238, 48, 3, '`mlflow.add_model_version`');
INSERT INTO public.question_options VALUES (239, 48, 4, '`MlflowClient.get_model_version`');
INSERT INTO public.question_options VALUES (240, 48, 5, 'Create new model');
INSERT INTO public.question_options VALUES (241, 49, 1, 'No benefits');
INSERT INTO public.question_options VALUES (242, 49, 2, 'Parallel deployment');
INSERT INTO public.question_options VALUES (243, 49, 3, 'Library-agnostic deployment');
INSERT INTO public.question_options VALUES (244, 49, 4, 'Stores in MLmodel file');
INSERT INTO public.question_options VALUES (245, 49, 5, 'Deployment-type agnostic');
INSERT INTO public.question_options VALUES (246, 50, 1, 'Development, Staging, Production');
INSERT INTO public.question_options VALUES (247, 50, 2, 'None, Staging, Production');
INSERT INTO public.question_options VALUES (248, 50, 3, 'Staging, Production, Archived');
INSERT INTO public.question_options VALUES (249, 50, 4, 'None, Staging, Production, Archived');
INSERT INTO public.question_options VALUES (250, 50, 5, 'Development, Staging, Production, Archived');
INSERT INTO public.question_options VALUES (251, 51, 1, 'Start testing job on new model');
INSERT INTO public.question_options VALUES (252, 51, 2, 'Update dashboard data');
INSERT INTO public.question_options VALUES (253, 51, 3, 'Email alert');
INSERT INTO public.question_options VALUES (254, 51, 4, 'None');
INSERT INTO public.question_options VALUES (255, 51, 5, 'Send Slack message on stage transition');
INSERT INTO public.question_options VALUES (256, 52, 1, 'Parallel deployment');
INSERT INTO public.question_options VALUES (257, 52, 2, 'Preprocessing applied in fit');
INSERT INTO public.question_options VALUES (258, 52, 3, 'Preprocessing applied in predict');
INSERT INTO public.question_options VALUES (259, 52, 4, 'No impact');
INSERT INTO public.question_options VALUES (260, 52, 5, 'No need for pipelines');
INSERT INTO public.question_options VALUES (261, 53, 1, 'Replace with `update_model_version`');
INSERT INTO public.question_options VALUES (262, 53, 2, 'No changes');
INSERT INTO public.question_options VALUES (263, 53, 3, 'Replace `description` with `artifact`');
INSERT INTO public.question_options VALUES (264, 53, 4, 'Replace `client` with `mlflow`');
INSERT INTO public.question_options VALUES (265, 53, 5, 'Add Python model');
INSERT INTO public.question_options VALUES (266, 54, 1, '```python
client.transition_model_version_stage(..., stage="Archived")
client.transition_model_version_stage(..., stage="Production")
```');
INSERT INTO public.question_options VALUES (267, 54, 2, '```python
client.transition_model_stage(...)
```');
INSERT INTO public.question_options VALUES (268, 54, 3, '```python
client.transition_model_stage(..., archive_existing_versions=True)
```');
INSERT INTO public.question_options VALUES (269, 54, 4, '```python
client.transition_model_version_stage(
    name=model,
    version=model_version,
    stage="Production",
    archive_existing_versions=True
)
```');
INSERT INTO public.question_options VALUES (270, 55, 1, 'Models');
INSERT INTO public.question_options VALUES (271, 55, 2, 'Model Registry');
INSERT INTO public.question_options VALUES (272, 55, 3, 'Model Serving');
INSERT INTO public.question_options VALUES (273, 55, 4, 'Feature Store');
INSERT INTO public.question_options VALUES (274, 55, 5, 'Experiments');
INSERT INTO public.question_options VALUES (275, 56, 1, '`"MODEL_VERSION_CREATED"`');
INSERT INTO public.question_options VALUES (276, 56, 2, '`"MODEL_VERSION_TRANSITIONED_TO_PRODUCTION"`');
INSERT INTO public.question_options VALUES (277, 56, 3, '`"MODEL_VERSION_TRANSITIONED_TO_STAGING"`');
INSERT INTO public.question_options VALUES (278, 56, 4, '`"MODEL_VERSION_TRANSITIONED_STAGE"`');
INSERT INTO public.question_options VALUES (279, 56, 5, 'Multiple specific events');
INSERT INTO public.question_options VALUES (280, 57, 1, '`transition_model_version_stage`');
INSERT INTO public.question_options VALUES (281, 57, 2, '`delete_model_version`');
INSERT INTO public.question_options VALUES (282, 57, 3, '`update_registered_model`');
INSERT INTO public.question_options VALUES (283, 57, 4, '`delete_model`');
INSERT INTO public.question_options VALUES (284, 57, 5, '`delete_registered_model`');
INSERT INTO public.question_options VALUES (285, 58, 1, 'MLflow APIs');
INSERT INTO public.question_options VALUES (286, 58, 2, 'AutoML APIs');
INSERT INTO public.question_options VALUES (287, 58, 3, 'MLflow Client');
INSERT INTO public.question_options VALUES (288, 58, 4, 'Not possible');
INSERT INTO public.question_options VALUES (289, 58, 5, 'Databricks REST APIs');
INSERT INTO public.question_options VALUES (290, 59, 1, 'No change');
INSERT INTO public.question_options VALUES (291, 59, 2, 'Replace `list` with `view`');
INSERT INTO public.question_options VALUES (292, 59, 3, 'Replace `POST` with `GET`');
INSERT INTO public.question_options VALUES (293, 59, 4, 'Replace `list` with `webhooks`');
INSERT INTO public.question_options VALUES (294, 59, 5, 'Replace `POST` with `PUT`');
INSERT INTO public.question_options VALUES (295, 60, 1, '```python
client.transition_model_version_stage(..., from="None", to="Staging")
```');
INSERT INTO public.question_options VALUES (296, 60, 2, '```python
client.transition_model_version_stage(..., stage="Staging")
```');
INSERT INTO public.question_options VALUES (297, 60, 3, '```python
client.transition_model_version_stage(name=model, ..., from="None", to="Staging")
```');
INSERT INTO public.question_options VALUES (298, 60, 4, '```python
client.transition_model_stage(...)
```');
INSERT INTO public.question_options VALUES (299, 60, 5, '```python
client.transition_model_version_stage(name=model, ..., stage="Staging")
```');


--
-- Name: answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.answers_id_seq', 60, true);


--
-- Name: concepts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.concepts_id_seq', 30, true);


--
-- Name: domains_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.domains_id_seq', 51, true);


--
-- Name: exam_levels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exam_levels_id_seq', 1, true);


--
-- Name: exam_sets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exam_sets_id_seq', 1, true);


--
-- Name: exams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exams_id_seq', 1, true);


--
-- Name: question_options_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.question_options_id_seq', 299, true);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questions_id_seq', 60, true);


--
-- Name: vendors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vendors_id_seq', 1, true);


--
-- PostgreSQL database dump complete
--

\unrestrict FVRGs7usp8joXtN3Qg6bBWUpotUPTeIIz5QyxQblZZkMXesbIawiwontVlZou3d

