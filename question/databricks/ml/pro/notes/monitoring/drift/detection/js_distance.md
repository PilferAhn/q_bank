# Jensen-Shannon (JS) Distance

## 상위 개념

```
ML Monitoring
└── Drift Detection
    └── 수치형 피처 감지
        └── JS Distance   ← 여기
```

## 정의

두 확률 분포 간의 유사도를 측정하는 거리 지표.
KL Divergence를 대칭적으로 개선한 버전이다.

## 특징

- **0~1 사이로 정규화**: 0이면 동일한 분포, 1이면 완전히 다른 분포
- **임계값 설정 불필요**: 값 자체가 직관적으로 해석 가능
- **대칭적**: JS(P, Q) = JS(Q, P)

## KS Test와 비교

→ [ks_test.md](./ks_test.md) 참고

## 한계

- KS test보다 **계산 비용이 높음**
- 연속형 분포에서는 이산화(binning) 과정이 필요

## 관련 문제

- Q10: JS distance를 KS test보다 선호하는 이유 → 임계값 불필요

## 실무 포인트

- 운영 환경에서 자동화된 drift 알람을 설정할 때 유리 (임계값 튜닝 불필요)
- 0.1 이하: 분포 유사, 0.2 이상: drift 의심 (일반적인 기준, 도메인마다 다름)
