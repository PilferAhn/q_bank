"""
exam_mode.py - 시험 시작 모드 (세트 단위, 일괄 채점)
"""
import streamlit as st
import streamlit.components.v1 as components
from backend import save_exam_result, save_user_answers, get_wrong_answers, get_questions_by_set
from views.option_selector import render as render_options, render_result


def show():
    if "exam_questions" not in st.session_state:
        if st.session_state.get("exam_set_id"):
            questions = get_questions_by_set(st.session_state["exam_set_id"])
            st.session_state.update({
                "exam_questions": questions.reset_index(drop=True),
                "exam_submitted": False,
                "exam_page": 0,
            })
            st.rerun()
        else:
            st.session_state["page"] = "select"
            st.rerun()
        return

    _header()

    if st.session_state.get("exam_submitted"):
        _show_result()
    else:
        _show_exam()


def _header():
    if st.button("← 돌아가기"):
        st.session_state["page"] = "select"
        st.rerun()
    st.subheader(
        f"🎯 {st.session_state.get('vendor_name', '')} "
        f"{st.session_state.get('exam_name', '')} "
        f"— {st.session_state.get('exam_level_name', '')}"
    )
    st.divider()


PAGE_SIZE = 10


def _show_exam():
    questions = st.session_state["exam_questions"]
    set_num = st.session_state.get("exam_set_number", "?")
    total = len(questions)
    total_pages = (total + PAGE_SIZE - 1) // PAGE_SIZE
    page = st.session_state.get("exam_page", 0)
    start = page * PAGE_SIZE
    end = min(start + PAGE_SIZE, total)

    # ── 문제 목록 ──
    page_questions = questions.iloc[start:end]
    for i, (_, row) in enumerate(page_questions.iterrows()):
        q_num = start + i + 1
        options = _parse_options(row["options"])
        st.markdown(f"**Q{q_num}.**")
        st.markdown(row["body"])
        render_options(options, key=f"exam_q_{row['id']}")
        st.divider()

    # ── 하단: 이전 / 다음 or 제출 ──
    col_prev, col_next = st.columns(2)
    if page > 0:
        if col_prev.button("← 이전", use_container_width=True):
            st.session_state["exam_page"] = page - 1
            st.rerun()
    if page < total_pages - 1:
        if col_next.button("다음 →", type="primary", use_container_width=True):
            st.session_state["exam_page"] = page + 1
            st.rerun()
    else:
        if col_next.button("📮 답안 제출", type="primary", use_container_width=True):
            _submit(questions)

    # 페이지 이동 시 최상단 스크롤
    components.html("<script>window.parent.document.querySelector('section.main').scrollTo(0,0)</script>", height=0)


def _submit(questions):
    correct_count = 0
    answer_records = []

    for _, row in questions.iterrows():
        key = f"exam_q_{row['id']}"
        selected = st.session_state.get(key)
        correct_set = {str(x) for x in row["correct"]}
        is_correct = ({selected} if selected else set()) == correct_set
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
