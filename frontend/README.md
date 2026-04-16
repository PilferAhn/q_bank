# Frontend

Streamlit 기반 문제은행 앱.

## 실행

```bash
cd frontend
python -m streamlit run app.py --server.port 8503 --server.headless true --server.address 0.0.0.0
```

- 로컬: http://localhost:8503
- 네트워크: http://10.0.1.31:8503

## 구조

```
frontend/
├── app.py              # 라우터 + 사이드바
├── backend.py          # PostgreSQL 쿼리 (psycopg2)
├── .env                # DB 연결 정보 (gitignore)
└── views/
    ├── selector.py     # 벤더→시험→레벨→모드 선택
    ├── exam_mode.py    # 시험 모드 (세트 단위, 일괄 채점)
    ├── practice_mode.py # 연습 모드 (1문제씩, 즉시 정답)
    ├── option_selector.py # 보기 버튼 컴포넌트
    └── admin.py        # 시험 이력 / 문제 목록
```

## 라우팅

`st.session_state["page"]`로 라우팅. 새로고침 시 `st.query_params`로 복원.

```
select → exam / practice / admin
```

### URL 동기화 키

| URL 키 | 세션 키 | 비고 |
|---|---|---|
| `page` | `page` | 항상 |
| `level_id` | `exam_level_id` | 시험/연습 진입 후 |
| `vendor` | `vendor_name` | |
| `exam` | `exam_name` | |
| `level` | `exam_level_name` | |
| `set_id` | `exam_set_id` | 시험 모드만 |
| `set_num` | `exam_set_number` | 시험 모드만 |
| `exam_user` | `exam_user` | 시험 모드만 |

새로고침 시 복원 동작:
- **practice**: `level_id`로 문제 재로드, 연습 모드 유지 (이전 답안 초기화)
- **exam**: `set_id`로 같은 세트 재로드, 시험 모드 유지 (이전 답안 초기화)

## 보기 버튼 (option_selector.py)

`render(options, key, multi=False, in_fragment=False)` 파라미터로 두 모드 분리.

| 모드 | `in_fragment` | 선택 표시 | rerun |
|---|---|---|---|
| practice | `True` | `type="primary"` (fragment rerun 후 반영) | `scope="fragment"` |
| exam | `False` (기본) | `type="primary"` (full rerun 후 반영) | `st.rerun()` |

- 버튼 옆 내용은 `st.markdown(v)` — 코드블록 자동 렌더링
- 컬럼 비율 `[1, 11]`, `vertical_alignment="center"`

### 단일 vs 멀티 선택

| answer_count | 동작 |
|---|---|
| 1 | 단일 선택 (str \| None) |
| N | N개 선택 안내 + 멀티 (set[str]) |
| NULL | 개수 미공개 멀티 (set[str]) |

## 코드블록 렌더링

마크다운을 DB에 그대로 저장. `is_code` 컬럼 없음.

| 상황 | 방법 |
|---|---|
| 문제 body | `st.markdown()` |
| 보기 선택 전 | `st.markdown(v)` |
| 보기 채점 후 (practice) | `_md_to_html(v)` — HTML div 내부라 별도 변환 |
| 보기 채점 후 (exam) | `st.markdown(v)` |

`st.radio`는 마크다운 미지원이므로 사용하지 않음.

## 확인 버튼 (practice_mode)

`type="primary"` + CSS `position: fixed; bottom: 2rem; right: 2rem` 고정.
보기 버튼은 `in_fragment=True`일 때 항상 `secondary`라 CSS 충돌 없음.

## 성능

- `@st.fragment` + `st.rerun(scope="fragment")` — practice_mode 버튼 클릭 시 fragment만 재실행
- exam_mode는 fragment 미사용, full rerun
- 문제 목록은 세션 상태 캐싱 — 클릭마다 DB 재쿼리 없음

### `components.html` 사용 금지 (iframe 비용)

`st.components.v1.html()`은 매 rerun마다 iframe을 새로 생성하므로 인터랙션 지연의 주요 원인이 됨.

**대신 쓸 수 있는 패턴:**

| 목적 | 나쁜 방법 | 좋은 방법 |
|---|---|---|
| 버튼 색상 변경 | JS로 DOM 직접 조작 | `type="primary"/"secondary"` 토글 + rerun |
| 특정 버튼만 고정 | JS로 style 주입 | CSS selector로 범위 한정 |
| 선택 상태 표시 | iframe 내 JS | session_state → 버튼 type/label 반영 |

**CSS로 특정 버튼만 타겟하는 방법:**

Streamlit은 버튼에 커스텀 class를 붙일 수 없으나, 컬럼 유무로 구분 가능.

```css
/* 컬럼 밖 primary 버튼 (예: 확인 버튼) */
[data-testid="stButton"] > button[kind="primary"] {
    position: fixed;
    bottom: 2rem;
    right: 2rem;
}

/* 컬럼 안 primary 버튼 (예: 보기 선택 버튼) — 위 규칙 무력화 */
[data-testid="stHorizontalBlock"] button[kind="primary"] {
    position: static !important;
    width: 100% !important;
}
```

`stHorizontalBlock`은 `st.columns()` 컨테이너, `stButton`은 버튼 래퍼. 컬럼 안/밖 여부로 CSS specificity 분리 가능.

## 연습 문제 수 설정

시험 연습 시작 전 문제 수를 조절할 수 있음. 1 ~ 전체 문제 수 범위에서 선택.
`selector_practice_limit` session key로 저장, `_load_questions()`에서 적용.
