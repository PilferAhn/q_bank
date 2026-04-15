"""
app.py - 자격증 시험 문제은행 (라우터)
"""
import streamlit as st

st.set_page_config(page_title="문제은행", page_icon="📝", layout="wide")

if "page" not in st.session_state:
    st.session_state["page"] = "select"

# ── 사이드바 ──
with st.sidebar:
    st.markdown("## 📝 문제은행")
    st.divider()

    if st.button("🏠 홈", use_container_width=True):
        st.session_state["page"] = "select"
        st.rerun()

    if st.button("⚙️ 관리", use_container_width=True):
        st.session_state["page"] = "admin"
        st.rerun()

    # 시험 진행 중일 때 현재 컨텍스트 표시
    if st.session_state.get("exam_level_id"):
        st.divider()
        st.caption("현재 선택")
        st.write(f"**{st.session_state.get('vendor_name', '')}**")
        st.write(f"{st.session_state.get('exam_name', '')}")
        st.write(f"레벨: {st.session_state.get('exam_level_name', '')}")

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
