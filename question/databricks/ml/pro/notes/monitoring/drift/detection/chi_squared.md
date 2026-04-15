# Chi-Squared Test

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
