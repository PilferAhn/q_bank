"""
practice_mode.py - 시험 연습 모드 (문제별 즉시 정답 확인)
"""
import streamlit as st
from backend import get_questions_by_level
from views.option_selector import render as render_options


def show():
    _header()

    if "practice_questions" not in st.session_state:
        _load_questions()
        return

    questions = st.session_state["practice_questions"]
    idx = st.session_state.get("practice_index", 0)
    total = len(questions)

    if idx >= total:
        _show_complete()
        return

    _show_question(questions, idx, total)


def _header():
    col1, col2 = st.columns([1, 8])
    with col1:
        if st.button("← 돌아가기"):
            st.session_state["page"] = "select"
            st.rerun()
    with col2:
        st.subheader(
            f"📖 {st.session_state.get('vendor_name', '')} "
            f"{st.session_state.get('exam_name', '')} "
            f"— {st.session_state.get('exam_level_name', '')} 연습"
        )


def _load_questions():
    level_id = st.session_state["exam_level_id"]
    questions = get_questions_by_level(level_id, random=True)

    if questions.empty:
        st.error("등록된 문제가 없습니다.")
        return

    st.session_state.update({
        "practice_questions": questions.reset_index(drop=True),
        "practice_index": 0,
        "practice_answered": {},
        "practice_correct": 0,
    })
    st.rerun()


def _show_question(questions, idx: int, total: int):
    row = questions.iloc[idx]
    answered = st.session_state.get("practice_answered", {})
    qid = row["id"]
    already_answered = qid in answered
    options = _parse_options(row["options"])

    st.progress(idx / total, text=f"{idx + 1} / {total} 문제")
    st.divider()

    st.markdown(f"### Q{idx + 1}.")
    st.markdown(row["body"])
    st.write("")

    if not already_answered:
        key = f"practice_q_{qid}"
        render_options(options, key=key)
        selected = st.session_state.get(key)

        if st.button("확인", type="primary"):
            answered[qid] = selected
            st.session_state["practice_answered"] = answered
            if selected == str(row["correct"]):
                st.session_state["practice_correct"] = (
                    st.session_state.get("practice_correct", 0) + 1
                )
            st.rerun()

    else:
        selected = answered[qid]
        correct = str(row["correct"])
        for k, v in options.items():
            if k == correct:
                bg, border, label = "#d4edda", "#28a745", f"✅ {k}."
            elif k == selected:
                bg, border, label = "#f8d7da", "#dc3545", f"❌ {k}."
            else:
                bg, border, label = "#f8f9fa", "#dee2e6", f"{k}."
            st.markdown(
                f"""<div style="background:{bg};border:2px solid {border};
                    border-radius:8px;padding:12px 16px;margin-bottom:8px">
                    <strong>{label}</strong><br>{_md_to_html(v)}
                </div>""",
                unsafe_allow_html=True,
            )

        if row["explanation"]:
            st.info(f"💡 **해설:** {row['explanation']}")
        if row.get("quote"):
            with st.expander("📄 원문 참조"):
                st.markdown(row["quote"])

        st.divider()
        col1, col2 = st.columns(2)
        with col1:
            if idx > 0:
                if st.button("← 이전", use_container_width=True):
                    st.session_state["practice_index"] = idx - 1
                    st.rerun()
        with col2:
            label = "다음 →" if idx < total - 1 else "결과 보기"
            if st.button(label, type="primary", use_container_width=True):
                st.session_state["practice_index"] = idx + 1
                st.rerun()


def _show_complete():
    total = len(st.session_state["practice_questions"])
    correct = st.session_state.get("practice_correct", 0)
    score = round(correct / total * 100, 1)

    st.subheader("📊 연습 완료")
    c1, c2, c3 = st.columns(3)
    c1.metric("풀이 완료", f"{total}문제")
    c2.metric("정답", f"{correct}문제")
    c3.metric("정답률", f"{score}%")
    st.divider()

    if st.button("🔄 다시 연습하기", type="primary"):
        for key in ["practice_questions", "practice_index", "practice_answered", "practice_correct"]:
            st.session_state.pop(key, None)
        st.rerun()

    if st.button("홈으로"):
        st.session_state["page"] = "select"
        st.rerun()


def _md_to_html(text: str) -> str:
    """마크다운 코드블록/인라인코드 → HTML 변환"""
    import re
    # ```lang\ncode\n``` → <pre><code>
    text = re.sub(
        r'```[^\n]*\n(.*?)```',
        lambda m: (
            f'<pre style="background:rgba(0,0,0,0.06);padding:8px 12px;'
            f'border-radius:4px;font-size:13px;overflow-x:auto;margin:6px 0">'
            f'<code>{m.group(1).strip()}</code></pre>'
        ),
        text, flags=re.DOTALL,
    )
    # 인라인 `code`
    text = re.sub(
        r'`([^`]+)`',
        r'<code style="background:rgba(0,0,0,0.06);padding:1px 4px;border-radius:3px">\1</code>',
        text,
    )
    return text


def _parse_options(options) -> dict:
    if isinstance(options, dict):
        return options
    if isinstance(options, list):
        return {str(i + 1): v for i, v in enumerate(options)}
    return {}
