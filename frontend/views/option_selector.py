"""
option_selector.py - 보기 선택 컴포넌트
radio 사용 (rerun 없음 → 빠름). 코드블록은 fence 제거 후 텍스트로 표시.
"""
import re
import streamlit as st

_CSS = """
<style>
/* radio 레이블 줄바꿈 및 들여쓰기 */
[data-testid="stRadio"] label {
    align-items: flex-start !important;
    white-space: pre-wrap !important;
    font-family: inherit !important;
}
[data-testid="stRadio"] label > div:last-child {
    margin-top: 2px !important;
}
/* radio 내 코드처럼 보이는 텍스트 */
[data-testid="stRadio"] label code {
    font-size: 13px !important;
}
</style>
"""

_CSS_INJECTED = False


def _inject_css():
    global _CSS_INJECTED
    if not _CSS_INJECTED:
        st.markdown(_CSS, unsafe_allow_html=True)
        _CSS_INJECTED = True


def _to_label(k: str, text: str) -> str:
    """radio 레이블용: 코드 fence 제거, 텍스트로 변환"""
    # ```lang\n...\n``` → 코드 내용만 남김
    text = re.sub(r'```[^\n]*\n', '', text)
    text = re.sub(r'```', '', text)
    # 인라인 백틱 유지 (streamlit radio가 렌더링)
    return f"{k}.  {text.strip()}"


def render(options: dict, key: str) -> str:
    """보기 radio 렌더링. 선택값 반환."""
    _inject_css()

    selected = st.radio(
        "답 선택",
        options=list(options.keys()),
        format_func=lambda k: _to_label(k, options[k]),
        key=key,
        label_visibility="collapsed",
    )
    return selected


def render_result(options: dict, selected: str, correct: str):
    """채점 결과 표시용 보기 렌더링 (마크다운으로 코드블록 표시)"""
    for k, v in options.items():
        col_icon, col_body = st.columns([1, 11], gap="small")

        with col_icon:
            if k == correct:
                st.success(f"✅ {k}")
            elif k == selected:
                st.error(f"❌ {k}")
            else:
                st.markdown(f"**{k}**")

        with col_body:
            st.markdown(v)
