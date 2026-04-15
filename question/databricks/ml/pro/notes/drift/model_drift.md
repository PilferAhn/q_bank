# Model Drift — Overview

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
