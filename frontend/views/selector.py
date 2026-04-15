"""
selector.py - 벤더 → 시험 → 레벨 → 모드 선택 화면
"""
import streamlit as st
from backend import get_vendors, get_exams, get_exam_levels, get_exam_sets, get_question_count_by_level, get_questions_by_set


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
    selected_vendor = st.selectbox("벤더", list(vendor_map.keys()), label_visibility="collapsed")
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
    st.caption(f"총 {q_count}문제 등록됨")

    if q_count == 0:
        st.warning("등록된 문제가 없습니다.")
        return

    # ── Step 4: 응시자 이름 + 모드 선택 ──
    st.divider()
    st.subheader("④ 시험 방식 선택")

    user_name = st.text_input("응시자 이름 (시험 시작 시 필요)", key="selector_user_name")

    col1, col2 = st.columns(2)

    with col1:
        st.markdown("### 🎯 시험 시작")
        st.markdown("세트 단위로 모든 문제를 풀고\n마지막에 한 번에 채점합니다.")
        if st.button("시험 시작", type="primary", use_container_width=True, key="btn_exam"):
            if not user_name.strip():
                st.error("응시자 이름을 입력해주세요.")
            else:
                sets = get_exam_sets(level_id)
                set_id = int(sets.sample(1)["id"].iloc[0])
                set_number = int(sets[sets["id"] == set_id]["set_number"].iloc[0])
                questions = get_questions_by_set(set_id)
                _set_context(vendor_id, selected_vendor, exam_id, selected_exam, level_id, selected_level)
                st.session_state.update({
                    "exam_user": user_name.strip(),
                    "exam_set_id": set_id,
                    "exam_set_number": set_number,
                    "exam_questions": questions.reset_index(drop=True),
                    "exam_submitted": False,
                    "page": "exam",
                })
                st.rerun()

    with col2:
        st.markdown("### 📖 시험 연습")
        st.markdown("문제를 하나씩 풀고\n바로 정답과 해설을 확인합니다.")
        if st.button("시험 연습", use_container_width=True, key="btn_practice"):
            _set_context(vendor_id, selected_vendor, exam_id, selected_exam, level_id, selected_level)
            st.session_state["page"] = "practice"
            st.rerun()


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
