# Containers — 배포 패키징

## 상위 개념

```
ML Deployment
└── Infrastructure
    └── Containers (Docker)
```

## 정의

애플리케이션 코드와 모든 종속성(라이브러리, 런타임, 설정 등)을 하나의 패키지로 묶어 어떤 환경에서도 동일하게 실행되도록 하는 기술. (Q33)

## 배포에서의 역할

Real-time 서빙이나 스트리밍 배포 시, 모델과 서빙 코드를 컨테이너로 패키징하면:

- 개발 환경과 운영 환경의 차이 제거
- 라이브러리 버전 충돌 방지
- 어디서나 동일한 실행 환경 보장

## MLflow + Docker

MLflow는 모델을 Docker 이미지로 패키징하는 기능을 내장하고 있다.

```bash
# MLflow 모델을 Docker 이미지로 빌드
mlflow models build-docker -m "runs:/<run_id>/model" -n "my-model"

# 컨테이너 실행
docker run -p 5000:8080 my-model
```

## Containers vs 다른 인프라

| | Containers | Cloud Compute | Autoscaling Clusters |
|---|---|---|---|
| **역할** | 소프트웨어 패키징 | 실행 환경 제공 | 트래픽 대응 |
| **종속성 포함** | ✅ | ❌ | ❌ |

## 관련 문제

- Q33: Real-time 배포 시 소프트웨어를 종속성과 함께 패키징하는 도구 → Containers

## 실무 포인트

- REST API + Container 조합이 Real-time 배포의 표준 패턴
- MLflow Model Serving (Databricks)은 내부적으로 컨테이너 기반으로 동작
