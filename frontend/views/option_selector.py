"""
option_selector.py - 보기 선택 컴포넌트
"""
import streamlit as st


def render(options: dict, key: str, multi: bool = False, in_fragment: bool = False):
    """보기 버튼 렌더링.
    single(multi=False): 반환값 str | None
    multi(multi=True):   반환값 set[str]
    선택 시 type="primary" 로 색상 표시 (JS 없음).
    확인 버튼과의 CSS 충돌은 practice_mode에서 stHorizontalBlock 범위 지정으로 해결.
    """
    if multi:
        selected = st.session_state.get(key, set())
        if not isinstance(selected, set):
            selected = set()
    else:
        selected = st.session_state.get(key)

    for k, v in options.items():
        is_selected = (k in selected) if multi else (k == selected)
        col_btn, col_body = st.columns([1, 11], gap="small", vertical_alignment="center")
        with col_btn:
            if st.button(
                k,
                key=f"{key}_{k}",
                type="primary" if is_selected else "secondary",
                use_container_width=True,
            ):
                if multi:
                    new_sel = set(selected)
                    if k in new_sel:
                        new_sel.discard(k)
                    else:
                        new_sel.add(k)
                    selected = new_sel
                else:
                    selected = None if k == selected else k
                st.session_state[key] = selected
                if in_fragment:
                    st.rerun(scope="fragment")
                else:
                    st.rerun()
        with col_body:
            st.markdown(v)

    return selected


def render_result(options: dict, selected: str, correct: str):
    """채점 결과 표시용 보기 렌더링 (단일 정답, exam_mode용)"""
    for k, v in options.items():
        col_icon, col_body = st.columns([1, 11], gap="small", vertical_alignment="center")
        with col_icon:
            if k == correct:
                st.success(f"✅ {k}")
            elif k == selected:
                st.error(f"❌ {k}")
            else:
                st.markdown(f"**{k}**")
        with col_body:
            st.markdown(v)
