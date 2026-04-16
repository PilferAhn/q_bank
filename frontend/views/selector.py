"""
selector.py - 벤더 → 시험 → 레벨 → 모드 선택 화면
"""
import os
import socket
import streamlit as st

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

from backend import get_vendors, get_exams, get_exam_levels, get_exam_sets, get_question_count_by_level, get_questions_by_set


def _get_user_identity() -> str | None:
    """
    USER_ID_SOURCE 환경변수에 따라 응시자 ID를 자동 감지.
    - 'ip'         : 접속 IP (없으면 hostname) (dev)
    - 'databricks' : Databricks 로그인 계정 (prod, Apps가 자동 주입)
    - 미설정        : None → 텍스트 입력창 표시 (기존 동작)
    """
    source = os.getenv("USER_ID_SOURCE", "").lower()

    if source == "databricks":
        return os.getenv("DATABRICKS_USER_NAME", "unknown")

    if source == "ip":
        # 1순위: 프록시 헤더 (배포 환경)
        try:
            headers = st.context.headers
            forwarded = headers.get("X-Forwarded-For") or headers.get("X-Real-Ip")
            if forwarded:
                return forwarded.split(",")[0].strip()
        except Exception:
            pass
        # 2순위: 로컬 hostname (개발 환경)
        return socket.gethostname()

    return None


def show():
    st.title("📝 자격증 시험 문제은행")
    st.divider()

    vendors = get_vendors()
    if vendors.empty:
        st.warning("등록된 벤더가 없습니다.")
        return

    # ── Step 1: 벤더 선택 ──
    st.subheader("① 벤더 선택")
    vendor_map = {row["name"]: row["id"] for _, row in vendors.iterrows()}
    vendor_names = list(vendor_map.keys())
    default_vendor = vendor_names.index("Databricks") if "Databricks" in vendor_names else 0
    selected_vendor = st.selectbox("벤더", vendor_names, index=default_vendor, label_visibility="collapsed")
    vendor_id = vendor_map[selected_vendor]

    # ── Step 2: 시험 선택 ──
    exams = get_exams(vendor_id)
    if exams.empty:
        st.info("해당 벤더에 등록된 시험이 없습니다.")
        return

    st.subheader("② 시험 선택")
    exam_map = {row["name"]: row["id"] for _, row in exams.iterrows()}
    selected_exam = st.selectbox("시험", list(exam_map.keys()), label_visibility="collapsed")
    exam_id = exam_map[selected_exam]

    # ── Step 3: 레벨 선택 ──
    levels = get_exam_levels(exam_id)
    if levels.empty:
        st.info("해당 시험에 등록된 레벨이 없습니다.")
        return

    st.subheader("③ 레벨 선택")
    level_map = {row["level"]: row["id"] for _, row in levels.iterrows()}
    selected_level = st.selectbox("레벨", list(level_map.keys()), label_visibility="collapsed")
    level_id = level_map[selected_level]

    q_count = get_question_count_by_level(level_id)

    if q_count == 0:
        st.warning("등록된 문제가 없습니다.")
        return

    # ── Step 4: 응시자 이름 + 모드 선택 ──
    st.divider()
    st.subheader("④ 시험 방식 선택")

    sets = get_exam_sets(level_id)
    set_options = {int(r["set_number"]): int(r["id"]) for _, r in sets.iterrows()}

    auto_identity = _get_user_identity()

    col_name, col_set = st.columns(2)

    with col_name:
        if auto_identity:
            st.text_input("응시자", value=auto_identity, disabled=True, key="selector_user_display")
            user_name = auto_identity
        else:
            user_name = st.text_input("응시자", key="selector_user_name", placeholder="이름을 입력하세요")

    with col_set:
        selected_set_num = st.selectbox(
            "Set", list(set_options.keys()),
            format_func=lambda n: f"Set {n}",
            key="selector_set_num"
        )
        selected_set_id = set_options[selected_set_num]

    st.write("")
    btn_col1, btn_col2 = st.columns(2)

    with btn_col1:
        if st.button("🎯 시험 시작", type="primary", use_container_width=True, key="btn_exam"):
            if not user_name.strip():
                st.error("응시자 이름을 입력해주세요.")
            else:
                questions = get_questions_by_set(selected_set_id)
                _set_context(vendor_id, selected_vendor, exam_id, selected_exam, level_id, selected_level)
                st.session_state.update({
                    "exam_user": user_name.strip(),
                    "exam_set_id": selected_set_id,
                    "exam_set_number": selected_set_num,
                    "exam_questions": questions.reset_index(drop=True),
                    "exam_submitted": False,
                    "exam_page": 0,
                    "page": "exam",
                })
                st.rerun()

    with btn_col2:
        if st.button("📖 시험 연습", use_container_width=True, key="btn_practice"):
            _set_context(vendor_id, selected_vendor, exam_id, selected_exam, level_id, selected_level)
            st.session_state["practice_limit"] = st.session_state.get("selector_practice_limit", q_count)
            st.session_state["page"] = "practice"
            st.rerun()

        if os.getenv("APP_ENV", "dev") == "dev":
            st.number_input(
                "문제 수 (dev)", min_value=1, max_value=q_count, value=q_count,
                step=1, key="selector_practice_limit"
            )


def _set_context(vendor_id, vendor_name, exam_id, exam_name, level_id, level_name):
    st.session_state.update({
        "vendor_id": vendor_id,
        "vendor_name": vendor_name,
        "exam_id": exam_id,
        "exam_name": exam_name,
        "exam_level_id": level_id,
        "exam_level_name": level_name,
    })
    # 이전 시험 상태 초기화
    for key in ["exam_questions", "exam_submitted", "exam_result",
                "practice_questions", "practice_index", "practice_answered"]:
        st.session_state.pop(key, None)
