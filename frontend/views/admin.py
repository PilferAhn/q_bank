"""
admin.py - 시험 이력 / 문제 목록 (관리용)
"""
import streamlit as st
from backend import get_exam_history, get_wrong_answers, run_query


def show():
    st.subheader("⚙️ 관리")
    tab_history, tab_browse = st.tabs(["📊 시험 이력", "📋 문제 목록"])

    with tab_history:
        _show_history()

    with tab_browse:
        _show_browse()


def _show_history():
    history = get_exam_history()
    if history.empty:
        st.info("아직 시험 이력이 없습니다.")
        return

    st.dataframe(
        history,
        use_container_width=True,
        column_config={
            "result_id": "ID",
            "user_name": "응시자",
            "level": "레벨",
            "total_questions": "문제 수",
            "correct_count": "정답 수",
            "score": st.column_config.NumberColumn("점수", format="%.1f"),
            "passed": "합격",
            "mode": "모드",
            "exam_date": "시험일시",
        },
    )

    rid = st.selectbox("오답 확인할 시험 ID", history["result_id"].tolist())
    if st.button("오답 조회"):
        wrong = get_wrong_answers(rid)
        if wrong.empty:
            st.success("오답이 없습니다! 🎉")
        else:
            for _, row in wrong.iterrows():
                with st.expander(f"Q. {row['question_text']}"):
                    st.error(f"내 답: {row['selected_answer']}")
                    st.success(f"정답: {row['correct_answer']}")
                    if row["explanation"]:
                        st.info(f"💡 {row['explanation']}")


def _show_browse():
    df = run_query("""
        SELECT v.name AS vendor, e.name AS exam, el.level,
               es.set_number, q.number, q.body, a.correct
        FROM vendors v
        JOIN exams e ON e.vendor_id = v.id
        JOIN exam_levels el ON el.exam_id = e.id
        JOIN exam_sets es ON es.exam_level_id = el.id
        JOIN questions q ON q.exam_set_id = es.id
        JOIN answers a ON a.question_id = q.id
        ORDER BY v.name, e.name, el.level, es.set_number, q.number
    """)

    if df.empty:
        st.info("등록된 문제가 없습니다.")
        return

    st.metric("전체 문제 수", len(df))
    st.dataframe(
        df,
        use_container_width=True,
        column_config={
            "vendor": "벤더",
            "exam": "시험",
            "level": "레벨",
            "set_number": "세트",
            "number": "번호",
            "body": "문제",
            "correct": "정답",
        },
    )
