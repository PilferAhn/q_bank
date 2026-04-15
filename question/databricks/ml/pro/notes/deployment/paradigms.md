# 배포 패러다임 (Deployment Paradigms)

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
