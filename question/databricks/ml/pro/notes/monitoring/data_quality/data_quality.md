# Data Quality Monitoring

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
