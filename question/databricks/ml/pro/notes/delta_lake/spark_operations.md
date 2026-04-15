# Delta Lake — Spark 기본 조작

## 상위 개념

```
Delta Lake
└── Spark Operations
    ├── 읽기 (Read)
    ├── 쓰기 (Write)
    └── 컬럼 조작 (Schema)
```

## Delta 테이블 읽기

### 경로(path) 기반
```python
df = spark.read.format("delta").load("/path/to/table")
```

### 테이블명 기반
```python
df = spark.read.table("database.table_name")
```

> 혼동 주의: `load(path)`는 경로, `table(name)`은 테이블명을 받는다

## 컬럼 삭제 (Q7)

```python
df = spark.read.format("delta").load(path).drop("column_name")
```

- 메모리 상에서 컬럼을 제거한 DataFrame을 반환
- Delta 테이블 자체를 변경하지 않음 → 영구 삭제하려면 write back 필요

```python
# 영구 삭제
spark.read.format("delta").load(path) \
    .drop("column_name") \
    .write.format("delta").mode("overwrite").save(path)
```

## 잘못된 사용 예시

```python
# ❌ table()은 테이블명을 받아야 함, 경로 사용 불가
spark.read.format("delta").table(path).drop("column_name")

# ❌ SQL이지만 FROM에 경로 사용 불가
SELECT * EXCEPT column_name FROM path
```

## 관련 문제

- Q7: 경로 기반 Delta 테이블에서 컬럼 삭제

## 실무 포인트

- Delta Lake 2.0+ 에서는 `ALTER TABLE DROP COLUMN` 지원
- Spark API로 컬럼 제거 후 write back 시 `overwriteSchema=True` 옵션 필요할 수 있음
