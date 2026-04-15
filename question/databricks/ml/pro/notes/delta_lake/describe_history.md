# Delta Lake — DESCRIBE HISTORY

## 상위 개념

```
Delta Lake
└── Time Travel
    └── DESCRIBE HISTORY   ← 여기
```

## 정의

Delta 테이블의 모든 변경 이력을 조회하는 SQL 명령어.
언제, 무엇이, 어떻게 바뀌었는지를 버전 단위로 확인할 수 있다.

## 사용법

```sql
-- 테이블명으로 조회
DESCRIBE HISTORY table_name

-- 경로로 조회
DESCRIBE HISTORY delta.`/path/to/table`
```

## 반환 정보

| 컬럼 | 설명 |
|---|---|
| version | 버전 번호 |
| timestamp | 변경 시각 |
| operation | 수행된 작업 (WRITE, DELETE, MERGE 등) |
| operationParameters | 작업 파라미터 상세 |
| userMetadata | 사용자 정의 메타데이터 |

## DESCRIBE vs DESCRIBE HISTORY

| | DESCRIBE | DESCRIBE HISTORY |
|---|---|---|
| **용도** | 현재 스키마 조회 | 전체 변경 이력 조회 |
| **결과** | 컬럼명, 타입 | 버전별 작업 내역 |

## 관련 문제

- Q16: 컬럼이 언제 삭제됐는지 확인 → DESCRIBE HISTORY

## 실무 포인트

- 컬럼 삭제, 데이터 변경, 스키마 변경 등의 시점 추적에 활용
- Time Travel (`VERSION AS OF`, `TIMESTAMP AS OF`)과 함께 사용하면 특정 시점 데이터 복원 가능
```sql
SELECT * FROM table_name VERSION AS OF 3
SELECT * FROM table_name TIMESTAMP AS OF '2024-01-01'
```
