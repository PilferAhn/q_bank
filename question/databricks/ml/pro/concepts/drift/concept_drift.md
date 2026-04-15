# Concept Drift

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
