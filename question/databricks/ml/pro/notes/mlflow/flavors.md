# MLflow Model Flavors

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
