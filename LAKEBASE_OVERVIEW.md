# Databricks Lakebase 완전 정리 — OLTP + OLAP 통합 아키텍처

## Lakebase란?

Databricks가 제공하는 **완전 관리형 PostgreSQL 데이터베이스**.
Lakehouse에 **OLTP(온라인 트랜잭션 처리)** 기능을 추가한 서비스.

---

## OLTP vs OLAP

| | OLTP (Lakebase) | OLAP (Spark SQL) |
|--|--|--|
| 역할 | 소량 데이터를 빈번하게 읽고 쓰기 | 대량 데이터를 한번에 분석 |
| 예시 | `SELECT * FROM orders WHERE id = 1` | `SELECT region, SUM(sales) GROUP BY region` |
| 속도 | 밀리초 | 초~분 |
| 빈도 | 초당 수천 건 | 하루 몇 번 |
| 비유 | 편의점 계산대에서 바코드 찍기 | 창고에서 재고 전수조사 |

**Spark SQL은 구조적으로 OLTP가 불가능** — 분산 처리 엔진이라 단건 트랜잭션에 Spark job 오버헤드가 붙음.

---

## 왜 PostgreSQL인가?

- OLTP 전용 엔진이 필요했는데, 오픈소스 중 **가장 성숙한 OLTP DB**
- **생태계** — psycopg2, JDBC, Django, SQLAlchemy 등 전부 호환
- **BSD 라이선스** — 상용 서비스에 자유롭게 내장 가능 (MySQL은 GPL 제약)
- Wire protocol 호환이라 **연결 주소만 바꾸면** 기존 앱 그대로 동작

---

## 기존 아키텍처 vs Lakebase 아키텍처

### Before (각각 따로)

```
Web App → PostgreSQL/MySQL (OLTP)
              ↓ ETL/CDC 직접 구축
          Redis (캐시) → MQTT (실시간) → Spark (분석)
```

### After (Lakebase 통합)

```
Web App → Lakebase (PostgreSQL 호환 OLTP)
              ↕ 자동 동기화
          Spark / Delta Lake (분석)
```

ETL 파이프라인 직접 만들 필요 없음.

---

## Lakebase 두 가지 버전

| 버전 | 설명 |
|------|------|
| **Autoscaling** | 2026-03-12부터 기본값. 자동 스케일링, scale-to-zero, 브랜칭, 즉시 복구 |
| **Provisioned** | 기존 버전. 수동 컴퓨트 조절. 기존 인스턴스만 지원 |

### Autoscaling 주요 기능

- **Autoscaling** — 워크로드에 따라 컴퓨트 자동 조절
- **Scale-to-zero** — 비활성 시 비용 0, 수초 내 재시작
- **Branching** — copy-on-write로 DB 복사본 즉시 생성 (개발/테스트용)
- **Instant Restore** — 0~30일 내 특정 시점 복구
- **Read Replicas** — 동일 스토리지 공유, 데이터 복제 없이 즉시 생성
- **High Availability** — AZ 간 자동 페일오버
- **Data API** — PostgREST 호환 RESTful HTTP 인터페이스

---

## Unity Catalog와의 관계

### 자동으로 되는 것

Lakebase 테이블이 **Unity Catalog에 자동 등록** (메타데이터, 권한, 검색 가능)

### 자동으로 안 되는 것

Delta 테이블로 변환은 **Lakehouse Sync 설정 필요**

### 동기화 방향 2가지

```
① Synced Tables:   Delta Lake  →  Lakebase   (분석 결과를 웹 앱에서 서빙)
② Lakehouse Sync:  Lakebase    →  Delta Lake  (웹 앱 데이터를 Spark로 분석)
```

---

## 데이터 저장 방식이 다르므로 복사가 필요

| | PostgreSQL (Lakebase) | Delta Lake |
|--|--|--|
| 저장 방식 | 행(row) 단위 | 열(column) 단위 (Parquet) |
| 잘하는 것 | 단건 조회/쓰기 | 수억 건 집계 |
| 엔진 | PostgreSQL | Spark |

Spark가 PostgreSQL 파일을 직접 못 읽으므로 Delta 포맷으로 변환 복사 필요.

### 용량

- 물리적으로 두 벌이지만, Delta Lake는 Parquet 압축으로 **원본의 20~40%** 크기
- 1GB PostgreSQL → 총 ~1.3GB 사용
- 스토리지는 클라우드에서 가장 싼 리소스, ETL 인건비/컴퓨트 비용보다 훨씬 저렴

### 증분/변경 처리 (CDC)

- **CDC (Change Data Capture)** 방식으로 변경분만 감지하여 동기화
- INSERT, UPDATE, DELETE 모두 **변경된 row만 반영** (전체 복사 X)
- 1억 row 중 10건 변경 → 10건만 동기화

---

## q_bank 프로젝트 마이그레이션

### 바뀌는 것 / 안 바뀌는 것

| 항목 | 변경 여부 |
|------|----------|
| psycopg2 쿼리 코드 | **X** — 그대로 |
| SQL문 (SELECT, INSERT 등) | **X** — 그대로 |
| Streamlit 프론트엔드 | **X** — 그대로 |
| Docker 컨테이너 | **삭제** — 서버리스라 불필요 |
| `.env` 연결 정보 | **O** — host만 변경 |
| 백업 | **자동** — PITR 0~30일 |

### 마이그레이션 방법

```bash
# 1. Docker PostgreSQL에서 덤프
pg_dump -h localhost -U postgres q_bank > dump.sql

# 2. Lakebase에 복원
psql -h lakebase-xxx.databricks.com -U user q_bank < dump.sql

# 3. .env 수정
DB_HOST=lakebase-xxx.databricks.com
```

---

## 개발자 관점 요약

- **웹 앱 개발 시** → 그냥 PostgreSQL. Spark 생각 안 해도 됨
- **분석 필요할 때** → Databricks 노트북에서 Spark로 별도 작업
- **둘 사이 연결** → Lakehouse Sync가 자동 처리

```
웹 앱 코드 (psycopg2)  →  Lakebase (PostgreSQL)
                                ↕ 자동 동기화
데이터 분석 (Spark)     →  Delta Lake
```

---

> 참고: https://docs.databricks.com/aws/en/oltp (2026-04-15 업데이트)
