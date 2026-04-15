# Label Drift

## 상위 개념

```
ML Monitoring
└── Model Drift
    ├── Concept Drift
    ├── Feature Drift
    ├── Label Drift        ← 여기
    └── Prediction Drift
```

## 정의

타겟 변수(y)의 **분포 자체가 변화**하는 현상.
입력과 출력의 관계는 유지되지만, 타겟값의 전체적인 분포가 달라진다.

> "정답 레이블의 비율이 달라진다"

## 비슷한 개념 비교

→ [concept_drift.md](./concept_drift.md) 참고

## 실무 예시

- 사기 탐지 모델에서 전체 사기 거래 비율이 증가
- 감성 분석 모델에서 부정 리뷰 비율이 급증
- 클래스 불균형이 시간에 따라 변화

## 감지 방법

타겟 변수의 분포를 직접 모니터링:
- 클래스별 비율 추이
- 평균, 분산 추이 (수치형 타겟)

## 관련 문제

- Q17: Label drift 정의

## 실무 포인트

- Label drift는 모델 자체의 문제가 아니라 **세상이 바뀐 것**
- 재학습 시 최근 데이터의 레이블 분포를 반영해야 함
- Concept drift와 혼동 주의: 레이블 분포만 바뀐 건 Label drift, 입력-레이블 관계가 바뀐 건 Concept drift
