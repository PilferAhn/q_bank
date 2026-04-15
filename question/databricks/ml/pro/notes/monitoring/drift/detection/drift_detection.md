# Drift 감지 도구

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
