"""
app.py - 자격증 시험 문제은행 (라우터)
"""
import streamlit as st

st.set_page_config(page_title="문제은행", page_icon="📝", layout="wide")

# ── URL → session_state 복원 (새로고침 대응) ──
_qp = st.query_params
if "page" not in st.session_state:
    st.session_state["page"] = _qp.get("page", "select")
if "exam_level_id" not in st.session_state and "level_id" in _qp:
    st.session_state["exam_level_id"]   = int(_qp["level_id"])
    st.session_state["vendor_name"]     = _qp.get("vendor", "")
    st.session_state["exam_name"]       = _qp.get("exam", "")
    st.session_state["exam_level_name"] = _qp.get("level", "")
if "exam_set_id" not in st.session_state and "set_id" in _qp:
    st.session_state["exam_set_id"]     = int(_qp["set_id"])
    st.session_state["exam_set_number"] = int(_qp.get("set_num", 1))
    st.session_state["exam_user"]       = _qp.get("exam_user", "")

# ── 사이드바 ──
with st.sidebar:
    st.markdown("## 📝 문제은행")
    st.divider()

    if st.button("🏠 홈", use_container_width=True):
        st.session_state["page"] = "select"
        st.rerun()

    if st.button("⚙️ 관리", use_container_width=True):
        st.session_state.pop("admin_authed", None)
        st.session_state["page"] = "admin"
        st.rerun()

    # 시험/연습 공통: 시험명 + 페이지 정보
    _page = st.session_state.get("page")
    if _page in ("exam", "practice"):
        vendor = st.session_state.get("vendor_name", "")
        exam = st.session_state.get("exam_name", "")
        level = st.session_state.get("exam_level_name", "")
        if vendor or exam:
            st.divider()
            st.caption(f"{vendor} · {exam}")
            if level:
                st.caption(level)

        if _page == "exam" and st.session_state.get("exam_questions") is not None:
            from math import ceil
            total = len(st.session_state["exam_questions"])
            cur = st.session_state.get("exam_page", 0)
            total_pages = ceil(total / 10)
            st.caption(f"📄 {cur+1} / {total_pages} 페이지")

        if _page == "practice" and st.session_state.get("practice_questions") is not None:
            total = len(st.session_state["practice_questions"])
            idx = st.session_state.get("practice_index", 0)
            st.caption(f"📖 Q{idx+1} / {total}")


# ── session_state → URL 동기화 ──
_sync: dict = {"page": st.session_state["page"]}
if st.session_state.get("exam_level_id"):
    _sync["level_id"] = st.session_state["exam_level_id"]
    _sync["vendor"]   = st.session_state.get("vendor_name", "")
    _sync["exam"]     = st.session_state.get("exam_name", "")
    _sync["level"]    = st.session_state.get("exam_level_name", "")
if st.session_state.get("exam_set_id"):
    _sync["set_id"]   = st.session_state["exam_set_id"]
    _sync["set_num"]  = st.session_state.get("exam_set_number", 1)
    _sync["exam_user"]= st.session_state.get("exam_user", "")
st.query_params.from_dict(_sync)

# ── 라우터 ──
page = st.session_state["page"]

if page == "select":
    from views.selector import show
    show()

elif page == "exam":
    from views.exam_mode import show
    show()

elif page == "practice":
    from views.practice_mode import show
    show()

elif page == "admin":
    from views.admin import show
    show()
