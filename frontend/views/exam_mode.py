"""
exam_mode.py - 시험 시작 모드 (세트 단위, 일괄 채점)
"""
import streamlit as st
from backend import save_exam_result, save_user_answers, get_wrong_answers
from views.option_selector import render as render_options, render_result


def show():
    _header()

    if st.session_state.get("exam_submitted"):
        _show_result()
    else:
        _show_exam()


def _header():
    col1, col2 = st.columns([1, 8])
    with col1:
        if st.button("← 돌아가기"):
            st.session_state["page"] = "select"
            st.rerun()
    with col2:
        st.subheader(
            f"🎯 {st.session_state.get('vendor_name', '')} "
            f"{st.session_state.get('exam_name', '')} "
            f"— {st.session_state.get('exam_level_name', '')}"
        )


def _show_exam():
    questions = st.session_state["exam_questions"]
    set_num = st.session_state.get("exam_set_number", "?")

    st.info(
        f"📌 Set {set_num} | {len(questions)}문제 | "
        f"응시자: {st.session_state.get('exam_user', '')}"
    )
    st.divider()

    for i, row in questions.iterrows():
        options = _parse_options(row["options"])
        st.markdown(f"**Q{i + 1}.**")
        st.markdown(row["body"])
        render_options(options, key=f"exam_q_{row['id']}")
        st.divider()

    if st.button("📮 답안 제출", type="primary"):
        _submit(questions)


def _submit(questions):
    correct_count = 0
    answer_records = []

    for _, row in questions.iterrows():
        key = f"exam_q_{row['id']}"
        selected = st.session_state.get(key)  # radio가 자동으로 저장
        is_correct = selected == str(row["correct"])
        if is_correct:
            correct_count += 1
        answer_records.append((row["id"], selected, is_correct))

    total = len(questions)
    score = round(correct_count / total * 100, 1)
    passed = score >= 60

    result_id = save_exam_result(
        st.session_state["exam_user"],
        st.session_state["exam_level_id"],
        st.session_state["exam_set_id"],
        total, correct_count, score, passed, "exam"
    )
    save_user_answers(result_id, answer_records)

    st.session_state.update({
        "exam_submitted": True,
        "exam_result": {
            "result_id": result_id,
            "score": score,
            "correct": correct_count,
            "total": total,
            "passed": passed,
        },
    })
    st.rerun()


def _show_result():
    result = st.session_state["exam_result"]
    st.subheader("📊 시험 결과")

    c1, c2, c3, c4 = st.columns(4)
    c1.metric("점수", f"{result['score']}점")
    c2.metric("정답", f"{result['correct']}/{result['total']}")
    c3.metric("합격 기준", "60점")
    if result["passed"]:
        c4.success("✅ 합격")
    else:
        c4.error("❌ 불합격")

    st.divider()

    wrong = get_wrong_answers(result["result_id"])
    if wrong.empty:
        st.balloons()
        st.success("🎉 전문제 정답입니다!")
    else:
        st.subheader(f"❌ 오답 노트 ({len(wrong)}문제)")
        for _, row in wrong.iterrows():
            preview = row["question_text"][:60].replace("\n", " ")
            with st.expander(f"Q. {preview}..."):
                st.markdown(row["question_text"])
                st.divider()
                options = _parse_options(row["options"])
                render_result(options, row["selected_answer"], row["correct_answer"])
                if row["explanation"]:
                    st.info(f"💡 {row['explanation']}")

    if st.button("🔄 다시 시험 보기"):
        for key in ["exam_questions", "exam_submitted", "exam_result", "exam_set_id"]:
            st.session_state.pop(key, None)
        st.rerun()


def _parse_options(options) -> dict:
    if isinstance(options, dict):
        return options
    if isinstance(options, list):
        return {str(i + 1): v for i, v in enumerate(options)}
    return {}
