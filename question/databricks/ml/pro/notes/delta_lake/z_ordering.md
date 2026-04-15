# Delta Lake — Z-Ordering

## 상위 개념

```
Delta Lake
└── Optimization
    ├── Z-Ordering     ← 여기
    └── Bin-packing
```

## 정의

관련 데이터를 동일한 파일에 가깝게 배치(colocate)하여 쿼리 시 읽어야 하는 파일 수를 최소화하는 최적화 기법. (Q39)

## 사용법

```sql
OPTIMIZE table_name ZORDER BY (column_name)

-- 여러 컬럼
OPTIMIZE table_name ZORDER BY (col1, col2)
```

## Z-Ordering vs Bin-packing

| | Z-Ordering | Bin-packing |
|---|---|---|
| **목적** | 유사 데이터 colocate | 파일 크기 최적화 |
| **효과** | 특정 컬럼 필터 쿼리 속도 향상 | 작은 파일 병합 |
| **명령어** | `OPTIMIZE ... ZORDER BY` | `OPTIMIZE` (기본) |

## Data Skipping과의 관계

Z-Ordering은 Data Skipping을 더 효과적으로 만든다.

```
Z-Ordering으로 유사 데이터 colocate
    → 각 파일의 min/max 통계값이 뚜렷하게 분리
        → 쿼리 시 불필요한 파일 skip 가능 (Data Skipping)
```

## 관련 문제

- Q39: 분산된 행을 모아 유사 레코드를 colocate하는 최적화 → Z-Ordering

## 실무 포인트

- 자주 필터링하는 컬럼에 적용 (예: `date`, `user_id`, `region`)
- OPTIMIZE 작업은 비용이 있으므로 주기적으로 실행 (예: 일 1회)
- 카디널리티가 높은 컬럼(user_id 등)에 특히 효과적
- `OPTIMIZE` 단독 사용은 Bin-packing만 수행
