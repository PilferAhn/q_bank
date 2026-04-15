# MLflow Nested Runs

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
