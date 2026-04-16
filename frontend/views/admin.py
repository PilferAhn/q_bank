"""
admin.py - 시험 이력 / 문제 목록 (관리용)
"""
import streamlit as st
from backend import get_exam_history, get_wrong_answers, delete_exam_result, run_query


_ADMIN_PASSWORD = "1234"


def show():
    if not st.session_state.get("admin_authed"):
        st.subheader("⚙️ 관리자 인증")
        with st.form("admin_auth_form"):
            pw = st.text_input("비밀번호", type="password")
            submitted = st.form_submit_button("확인", type="primary")
        if submitted:
            if pw == _ADMIN_PASSWORD:
                st.session_state["admin_authed"] = True
                st.rerun()
            else:
                st.error("비밀번호가 올바르지 않습니다.")
        return

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

    # 날짜 포맷: 년-월-일 시:분
    history = history.copy()
    history["exam_date"] = history["exam_date"].apply(
        lambda d: d.strftime("%Y-%m-%d %H:%M") if hasattr(d, "strftime") else str(d)[:16]
    )

    display = history[["result_id", "user_name", "level", "total_questions",
                        "correct_count", "score", "passed", "mode", "exam_date"]].copy()

    event = st.dataframe(
        display,
        use_container_width=True,
        hide_index=True,
        on_select="rerun",
        selection_mode="multi-row",
        column_config={
            "result_id":       st.column_config.NumberColumn("ID", width="small"),
            "user_name":       st.column_config.TextColumn("응시자", width="small"),
            "level":           st.column_config.TextColumn("레벨"),
            "total_questions": st.column_config.NumberColumn("문제수", width="small"),
            "correct_count":   st.column_config.NumberColumn("정답", width="small"),
            "score":           st.column_config.NumberColumn("점수", format="%.1f", width="small"),
            "passed":          st.column_config.CheckboxColumn("합격", width="small"),
            "mode":            st.column_config.TextColumn("모드", width="small"),
            "exam_date":       st.column_config.TextColumn("시험일시"),
        },
    )

    selected_rows = event.selection.rows
    if selected_rows:
        rids = [int(display.iloc[i]["result_id"]) for i in selected_rows]
        n = len(rids)
        _, btn_col = st.columns([4, 1])
        if btn_col.button(f"🗑️ {n}개 삭제", type="primary", use_container_width=True, key="del_selected"):
            _confirm_delete(rids)


@st.dialog("삭제 확인")
def _confirm_delete(rids: list[int]):
    st.write(f"{len(rids)}개의 시험 이력을 삭제하시겠습니까?")
    c1, c2 = st.columns(2)
    if c1.button("예", type="primary", use_container_width=True):
        for rid in rids:
            delete_exam_result(rid)
        st.rerun()
    if c2.button("아니오", use_container_width=True):
        st.rerun()


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
