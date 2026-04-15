# Databricks ML Professional — Practice Questions

---

## Question 1

Which of the following describes concept drift?

- A. Concept drift is when there is a change in the distribution of an input variable
- B. Concept drift is when there is a change in the distribution of a target variable
- C. Concept drift is when there is a change in the relationship between input variables and target variables
- D. Concept drift is when there is a change in the distribution of the predicted target given by the model
- E. None of these describe Concept drift

---

## Question 2

A machine learning engineer is monitoring categorical input variables for a production machine learning application.

The engineer believes that missing values are becoming more prevalent in more recent data for a particular value in one of the categorical input variables.

Which of the following tools can the machine learning engineer use to assess their theory?

- A. Kolmogorov-Smirnov (KS) test
- B. One-way Chi-squared Test
- C. Two-way Chi-squared Test
- D. Jensen-Shannon distance
- E. None of these

---

## Question 3

A data scientist is using MLflow to track their machine learning experiment.

As part of each MLflow run, they are performing hyperparameter tuning. The data scientist would like to have:

- one parent run for the tuning process
- one child run for each unique combination of hyperparameter values

However, the runs are not nesting correctly in MLflow.

Which of the following changes should be made so that the child runs nest under the parent run?

- A. Indent the child run blocks within the parent run block
- B. Add the `nested=True` argument to the parent run
- C. Remove the `nested=True` argument from the child runs
- D. Provide the same name to the `run_name` parameter for all run blocks
- E. Add `nested=True` to the parent run and remove `nested=True` from the child runs

---

## Question 4

A machine learning engineer wants to log feature importance data from a CSV file at path `importance_path` with an MLflow run for model `model`.

Which of the following code blocks will accomplish this task inside of an existing MLflow run block?

- A.
```python
mlflow.log_model_and_data(
    model,
    importance_path,
    "feature-importance.csv"
)
```

- B.
```python
mlflow.log_model(
    model,
    importance_path,
    "feature-importance.csv"
)
```

- C.
```python
mlflow.log_data(importance_path, "feature-importance.csv")
```

- D.
```python
mlflow.log_artifact(importance_path, "feature-importance.csv")
```

- E. None of these

---

## Question 5

Which of the following is a simple, low-cost method of monitoring numeric feature drift?

- A. Jensen-Shannon test
- B. Summary statistics trends
- C. Chi-squared test
- D. None of these can be used to monitor feature drift
- E. Kolmogorov-Smirnov (KS) test

---

## Question 6

A data scientist has developed a model to predict ice cream sales using:

- expected temperature
- expected number of hours of sun in the day

However, the expected temperature is dropping beneath the range of the input variable on which the model was trained.

Which type of drift is present?

- A. Label drift
- B. None of these
- C. Concept drift
- D. Prediction drift
- E. Feature drift

---

## Question 7

A data scientist wants to remove the `star_rating` column from the Delta table located at `path`.

Which code block accomplishes this task?

- A.
```python
spark.read.format("delta").load(path).drop("star_rating")
```

- B.
```python
spark.read.format("delta").table(path).drop("star_rating")
```

- C. Delta tables cannot be modified

- D.
```python
spark.read.table(path).drop("star_rating")
```

- E.
```sql
SELECT * EXCEPT star_rating FROM path
```

---

## Question 8

Which of the following operations in Feature Store Client (`fs`) can be used to return a Spark DataFrame of a dataset associated with a Feature Store table?

- A. `fs.create_table`
- B. `fs.write_table`
- C. `fs.get_table`
- D. There is no way to accomplish this task with `fs`
- E. `fs.read_table`

---

## Question 9

A machine learning engineer is implementing a concept drift monitoring solution using the following steps:

1. Deploy a model to production and compute predicted values
2. Obtain the observed (actual) label values
3. ?

Which step should be completed as Step 3?

- A. Obtain the observed feature values
- B. Measure the latency of the prediction time
- C. Retrain the model
- D. None of these should be completed as Step 3
- E. Compute the evaluation metric using the observed and predicted values

---

## Question 10

Which of the following is a reason for using Jensen-Shannon (JS) distance over a Kolmogorov-Smirnov (KS) test for numeric feature drift detection?

- A. All of these reasons
- B. JS is not normalized or smoothed
- C. None of these reasons
- D. JS is more robust when working with large datasets
- E. JS does not require any manual threshold or cutoff determinations

---

## Question 11

A data scientist is utilizing MLflow to track experiments and wants to programmatically work with run data in a Spark DataFrame.

They have:

- an active MLflow Client `client`
- an active Spark session `spark`

Which code retrieves run-level results for `exp_id`?

- A. `client.list_run_infos(exp_id)`
- B. `spark.read.format("delta").load(exp_id)`
- C. There is no way to programmatically return row-level results
- D. `mlflow.search_runs(exp_id)`
- E. `spark.read.format("mlflow-experiment").load(exp_id)`

---

## Question 12

A data scientist wants to reload a logged scikit-learn model and access `feature_importances_`.

Which code accomplishes this?

- A. `mlflow.load_model(model_uri)`
- B. `client.list_artifacts(run_id)["feature-importances.csv"]`
- C. `mlflow.sklearn.load_model(model_uri)`
- D. Only available in UI
- E. `client.pyfunc.load_model(model_uri)`

---

## Question 13

Which is a simple statistic for monitoring categorical feature drift?

- A. Mode
- B. None
- C. Mode, number of unique values, and % missing
- D. % missing
- E. Number of unique values

---

## Question 14

What is a probable response to drift?

- A. None
- B. Retrain on recent data
- C. All of these
- D. Change label variable
- E. Sunset application

---

## Question 15

A data scientist wants to overwrite a Feature Store table `features` with `features_df`.

Which code works?

- A.
```python
fs.create_table(
    name="features",
    df=features_df,
    mode="overwrite"
)
```

- B.
```python
fs.write_table(
    name="features",
    df=features_df
)
```

- C.
```python
fs.write_table(
    name="features",
    df=features_df,
    mode="merge"
)
```

- D.
```python
fs.write_table(
    name="features",
    df=features_df,
    mode="overwrite"
)
```

- E.
```python
fs.create_table(
    name="features",
    df=features_df,
    mode="merge"
)
```

---

## Question 16

A team wants to find when a column was dropped from a Delta table.

Which SQL command should be used?

- A. `VERSION`
- B. `DESCRIBE`
- C. `HISTORY`
- D. `DESCRIBE HISTORY`
- E. `TIMESTAMP`

---

## Question 17

Which describes label drift?

- A. Change in predicted target distribution
- B. None
- C. Change in input variable distribution
- D. Change in relationship between inputs and target
- E. Change in target variable distribution

---

## Question 18

Most common deployment paradigm?

- A. On-device
- B. Streaming
- C. Real-time
- D. Batch
- E. None

---

## Question 19

Enable MLflow autologging globally.

- A. `mlflow.sklearn.autolog()`
- B. `mlflow.spark.autolog()`
- C. `spark.conf.set("autologging", True)`
- D. Not possible
- E. `mlflow.autolog()`

---

## Question 20

Store RMSE (`rmse`) in MLflow:

```python
with mlflow.start_run():
    ...
```

Which function should be used?

- A. `log_artifact`
- B. `log_model`
- C. `log_metric`
- D. `log_param`
- E. Not possible

---

## Question 21

Which of the following MLflow operations can be used to automatically calculate and log a Shapley feature importance plot?

- A. `mlflow.shap.log_explanation`
- B. None of these operations can accomplish the task.
- C. `mlflow.shap`
- D. `mlflow.log_figure`
- E. `client.log_artifact`

---

## Question 22

A data scientist has developed a scikit-learn random forest model `model`, but they have not yet logged it with MLflow.

They want to obtain the input schema and the output schema of the model.

Which operation can be used to perform this task?

- A. `mlflow.models.schema.infer_schema`
- B. `mlflow.models.signature.infer_signature`
- C. `mlflow.models.Model.get_input_schema`
- D. `mlflow.models.Model.signature`
- E. There is no way to obtain the schema of an unlogged model

---

## Question 23

A machine learning engineer and data scientist are converting a batch deployment to an always-on streaming deployment.

Why are strict data tests particularly important for streaming deployments?

- A. Because the streaming deployment is always on, all types of data must be handled without producing an error
- B. All of these statements
- C. Because there is no practitioner to debug poor model performance
- D. Because autoscaling must be validated
- E. None of these statements

---

## Question 24

Which deployment paradigm can centrally compute predictions for a single record with very fast results?

- A. Streaming
- B. Batch
- C. Edge/on-device
- D. None of these
- E. Real-time

---

## Question 25

A team wants continuous data processing into equal-sized batches.

Which tool supports this?

- A. Spark UDFs
- B. Structured Streaming
- C. MLflow
- D. Delta Lake
- E. AutoML

---

## Question 26

A model is registered in MLflow Model Registry with versions in multiple stages.

Which stages are automatically deployed with Model Serving?

- A. Staging, Production, Archived
- B. Production
- C. None, Staging, Production, Archived
- D. Staging, Production
- E. None, Staging, Production

---

## Question 27

A data scientist logs the number of trees in a random forest.

Which MLflow operation logs single values like this?

- A. `mlflow.log_artifact`
- B. `mlflow.log_model`
- C. `mlflow.log_metric`
- D. `mlflow.log_param`
- E. Not possible

---

## Question 28

A team is using Hyperopt with MLflow Autologging.

How can they create a parent run with child runs per hyperparameter combination?

- A. Start a manual parent run before calling `fmin`
- B. Use built-in model flavor
- C. Start a child run in `objective_function`
- D. Not possible
- E. Autologging automatically handles it

---

## Question 29

A function `compute_features` returns a Spark DataFrame `features_df`.

Which code creates and populates a Feature Store table?

- A.
```python
fs.create_table(
    name="new_table",
    primary_keys="customer_id",
    df=features_df,
    description="Customer features"
)
```

- B.
```python
fs.create_table(
    name="new_table",
    primary_keys="customer_id",
    description="Customer features"
)
```

- C.
```python
features_df.write.mode("fs").path("new_table")
```

- D.
```python
fs.create_table(
    name="new_table",
    primary_keys="customer_id",
    function=compute_features,
    description="Customer features"
)
```

- E.
```python
features_df.write.mode("feature").path("new_table")
```

---

## Question 30

What is a benefit of logging a model signature in MLflow?

- A. Unique identifier in experiment
- B. Input schema validation during serving
- C. Enables real-time deployment
- D. Secures the model
- E. Automatically converts schema

---

## Question 31

Which describes streaming with Spark for model deployment?

- A. Batch inference on trigger
- B. Real-time inference for all data
- C. Batch inference on job run
- D. Incremental inference on trigger
- E. Incremental inference on job run

---

## Question 32

A model in Production stage needs to be queried via Model Serving.

Which URI is correct?

- A. `https://<host>/model-serving/recommender/Production/invocations`
- B. Requires version number
- C. `https://<host>/model/recommender/stage-production/invocations`
- D. `https://<host>/model-serving/recommender/stage-production/invocations`
- E. `https://<host>/model/recommender/Production/invocations`

---

## Question 33

Which tool packages software with dependencies for real-time deployment?

- A. Cloud compute
- B. None
- C. REST APIs
- D. Containers
- E. Autoscaling clusters

---

## Question 34

A registered sklearn model needs to be loaded for batch deployment.

Which operation works?

- A. `mlflow.spark.load_model(model_uri)`
- B. `mlflow.pyfunc.read_model(model_uri)`
- C. `mlflow.sklearn.read_model(model_uri)`
- D. `mlflow.pyfunc.load_model(model_uri)`
- E. `mlflow.sklearn.load_model(model_uri)`

---

## Question 35

A data scientist logged visualizations in MLflow.

Where can they view them?

- A. Model Registry page
- B. Experiment Artifacts
- C. Cannot view
- D. Run Artifacts
- E. Run Figures

---

## Question 36

A sklearn model needs to be logged:

```python
with mlflow.start_run():
    ...
```

Which line completes the task?

- A. `mlflow.spark.track_model(sklearn_model, "model")`
- B. `mlflow.sklearn.log_model(sklearn_model, "model")`
- C. `mlflow.spark.log_model(sklearn_model, "model")`
- D. `mlflow.sklearn.load_model("model")`
- E. `mlflow.sklearn.track_model(sklearn_model, "model")`

---

## Question 37

What are MLflow Model flavors?

- A. Wrap preprocessing logic
- B. Version models
- C. Organize runs
- D. Help deployment tools understand models
- E. Organize models

---

## Question 38

What typically triggers CI/CD testing in ML pipelines?

- A. New SQL endpoint
- B. Not needed
- C. New feature table
- D. New cluster
- E. New model version in MLflow Registry

---

## Question 39

A team has slow queries due to scattered rows.

Which optimization helps colocate similar records?

- A. Z-Ordering
- B. Bin-packing
- C. Parquet
- D. Data skipping
- E. File size tuning

---

## Question 40

A model's features are available one week before query time.

Why use batch serving instead of real-time?

- A. Built-in Databricks support
- B. No advantage
- C. More up-to-date results
- D. Real-time cannot be tested
- E. Stored predictions are faster to query

---

## Question 41

A machine learning engineer logged a scikit-learn random forest model and stored its `run_id`.

They want to perform batch inference on a Spark DataFrame `spark_df`.

Which code creates a predict function?

- A.
```python
predict = mlflow.pyfunc.spark_udf(
    spark_df,
    f"runs:/{run_id}/random_forest_model"
)
```

- B. It is not possible

- C.
```python
predict = sklearn.spark_udf(
    spark_df,
    f"runs:/{run_id}/random_forest_model"
)
```

- D.
```python
predict = spark.spark_udf(
    f"runs:/{run_id}/random_forest_model"
)
```

- E.
```python
predict = mlflow.pyfunc.spark_udf(
    spark,
    f"runs:/{run_id}/random_forest_model"
)
```

---

## Question 42

What is the purpose of the `context` parameter in MLflow Python model `predict` method?

- A. Specify model version
- B. Log performance
- C. Document business context
- D. Add custom logic
- E. Provide access to artifacts/config (e.g., preprocessing models)

---

## Question 43

A model is registered with Feature Store and used for batch inference.

Some features are missing in `spark_df`, but available via `customer_id`.

Which code computes predictions?

- A.
```python
df = fs.get_missing_features(spark_df, model_uri)
fs.score_model(model_uri, df)
```

- B.
```python
fs.score_model(model_uri, spark_df)
```

- C.
```python
df = fs.get_missing_features(spark_df, model_uri)
fs.score_batch(model_uri, df)
```

- D.
```python
df = fs.get_missing_features(spark_df)
fs.score_batch(model_uri, df)
```

- E.
```python
fs.score_batch(model_uri, spark_df)
```

---

## Question 44

A deployment requires:

- features available at request time
- very fast single-record predictions

Which deployment strategy fits?

- A. Edge/on-device
- B. Streaming
- C. None
- D. Batch
- E. Real-time

---

## Question 45

A batch pipeline must work with a streaming source.

What change is required?

- A. Replace table name with path
- B. Replace schema with `maxFilesPerTrigger`
- C. Replace `spark.read` with `spark.readStream`
- D. Replace format with `"stream"`
- E. Replace predict function

---

## Question 46

A model is identified via `model_uri` and `run_id`.

How to register it as `"best_model"`?

- A. `mlflow.register_model(model_uri, "best_model")`
- B. `mlflow.register_model(run_id, "best_model")`
- C. `mlflow.register_model(f"runs:/{run_id}/best_model", "model")`
- D. `mlflow.register_model(model_uri, "model")`
- E. `mlflow.register_model(f"runs:/{run_id}/model")`

---

## Question 47

Move model version from Staging → Production.

Which code works?

- A.
```python
client.transition_model_version_stage(
    name=model,
    version=model_version,
    stage="Staging"
)
```

- B.
```python
client.transition_model_stage(
    name=model,
    version=model_version,
    stage="Production"
)
```

- C.
```python
client.transition_model_version_stage(
    name=model,
    version=model_version,
    stage="Production"
)
```

- D.
```python
client.transition_model__stage(
    name=model,
    version=model_version,
    from="Staging",
    to="Production"
)
```

- E.
```python
client.transition_model_version_stage(
    name=model,
    version=model_version,
    from="Staging",
    to="Production"
)
```

---

## Question 48

Add a new version to an existing registered model.

Which operation?

- A. `mlflow.register_model`
- B. `MlflowClient.update_registered_model`
- C. `mlflow.add_model_version`
- D. `MlflowClient.get_model_version`
- E. Create new model

---

## Question 49

Advantage of `python_function` (pyfunc) flavor?

- A. No benefits
- B. Parallel deployment
- C. Library-agnostic deployment
- D. Stores in MLmodel file
- E. Deployment-type agnostic

---

## Question 50

Which stages exist in MLflow Model Registry?

- A. Development, Staging, Production
- B. None, Staging, Production
- C. Staging, Production, Archived
- D. None, Staging, Production, Archived
- E. Development, Staging, Production, Archived

---

## Question 51

Which use case requires HTTP Webhook?

- A. Start testing job on new model
- B. Update dashboard data
- C. Email alert
- D. None
- E. Send Slack message on stage transition

---

## Question 52

A custom pyfunc model includes preprocessing in `fit` and `predict`.

What is the benefit?

- A. Parallel deployment
- B. Preprocessing applied in fit
- C. Preprocessing applied in predict
- D. No impact
- E. No need for pipelines

---

## Question 53

Update model description:

```python
client.update_registered_model(
    name="model",
    description=model_description
)
```

What change is needed?

- A. Replace with `update_model_version`
- B. No changes
- C. Replace `description` with `artifact`
- D. Replace `client` with `mlflow`
- E. Add Python model

---

## Question 54

Move model to Production and archive existing versions.

Which code works?

- A.
```python
client.transition_model_version_stage(..., stage="Archived")
client.transition_model_version_stage(..., stage="Production")
```

- B.
```python
client.transition_model_stage(...)
```

- C.
```python
client.transition_model_stage(..., archive_existing_versions=True)
```

- D.
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

Which is the centralized model store?

- A. Models
- B. Model Registry
- C. Model Serving
- D. Feature Store
- E. Experiments

---

## Question 56

Webhook triggers on any stage transition.

What fills the blank?

- A. `"MODEL_VERSION_CREATED"`
- B. `"MODEL_VERSION_TRANSITIONED_TO_PRODUCTION"`
- C. `"MODEL_VERSION_TRANSITIONED_TO_STAGING"`
- D. `"MODEL_VERSION_TRANSITIONED_STAGE"`
- E. Multiple specific events

---

## Question 57

Which deletes a model from Model Registry?

- A. `transition_model_version_stage`
- B. `delete_model_version`
- C. `update_registered_model`
- D. `delete_model`
- E. `delete_registered_model`

---

## Question 58

How to programmatically create a Databricks Job?

- A. MLflow APIs
- B. AutoML APIs
- C. MLflow Client
- D. Not possible
- E. Databricks REST APIs

---

## Question 59

List webhooks API call fix:

```python
endpoint="/api/2.0/mlflow/registry-webhooks/list"
method="POST"
```

What change is needed?

- A. No change
- B. Replace `list` with `view`
- C. Replace `POST` with `GET`
- D. Replace `list` with `webhooks`
- E. Replace `POST` with `PUT`

---

## Question 60

Webhook triggers on transition to Staging.

Which action triggers it?

- A.
```python
client.transition_model_version_stage(..., from="None", to="Staging")
```

- B.
```python
client.transition_model_version_stage(..., stage="Staging")
```

- C.
```python
client.transition_model_version_stage(name=model, ..., from="None", to="Staging")
```

- D.
```python
client.transition_model_stage(...)
```

- E.
```python
client.transition_model_version_stage(name=model, ..., stage="Staging")
```
