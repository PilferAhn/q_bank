# Feature Store — Overview

## 상위 개념

```
Databricks
└── Feature Store
    ├── 테이블 생성 (create_table)
    ├── 데이터 쓰기 (write_table)
    ├── 데이터 읽기 (read_table)
    └── 배치 추론 (score_batch)
```

## 정의

피처를 중앙에서 관리하고 재사용할 수 있도록 저장하는 저장소.
학습과 서빙에서 동일한 피처를 사용하도록 보장한다.

## 주요 메서드

| 메서드 | 용도 |
|---|---|
| `fs.create_table()` | 테이블 생성 (최초 1회) |
| `fs.write_table()` | 데이터 쓰기/업데이트 |
| `fs.read_table()` | Spark DataFrame으로 읽기 |
| `fs.get_table()` | 테이블 메타데이터 조회 (DataFrame 아님) |
| `fs.score_batch()` | Feature Store 연동 배치 추론 |

## create_table vs write_table

```python
# 테이블 생성 + 데이터 동시 적재 (df 파라미터 사용)
fs.create_table(
    name="database.table_name",
    primary_keys="id",
    df=features_df,
    description="설명"
)

# 기존 테이블에 데이터 쓰기
fs.write_table(
    name="database.table_name",
    df=features_df,
    mode="overwrite"   # or "merge"
)
```

## write_table modes (Q15)

| mode | 동작 |
|---|---|
| `"overwrite"` | 기존 데이터 전체 교체 |
| `"merge"` | primary_key 기준 upsert |

## read_table vs get_table (Q8)

```python
# Spark DataFrame 반환 ✅
df = fs.read_table(name="database.table_name")

# FeatureTable 메타데이터 객체 반환 (DataFrame 아님) ❌
meta = fs.get_table(name="database.table_name")
```

## 관련 문제

- Q8: Feature Store에서 Spark DataFrame 반환 → `fs.read_table`
- Q15: Feature Store 테이블 덮어쓰기 → `fs.write_table(..., mode="overwrite")`
- Q29: 테이블 생성과 동시에 데이터 적재 → `fs.create_table(..., df=features_df)`
- Q43: Feature Store 연동 배치 추론 → `fs.score_batch()`

## 실무 포인트

- `create_table`은 테이블이 없을 때만 사용, 이후는 `write_table`
- `get_table`과 `read_table` 혼동 주의 — DataFrame이 필요하면 `read_table`
- `score_batch`는 spark_df에 없는 피처를 primary_key로 자동 조회
