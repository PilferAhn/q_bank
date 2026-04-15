# Feature Drift

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
