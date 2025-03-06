import streamlit as st
from PIL import Image

# Configure the page
st.set_page_config(
    page_title="Quality Assurance Training",
    layout="wide",
    initial_sidebar_state="collapsed"
)

# Custom CSS
st.markdown("""
<style>
    .main {
        padding: 0rem 1rem;
    }
    .stButton>button {
        background-color: #2d1b69;
        color: white;
        border-radius: 5px;
        padding: 0.5rem 2rem;
        width: 100px;
    }
    .header-text {
        color: #2d1b69;
        font-size: 2.5rem;
        font-weight: bold;
        text-align: right;
        direction: rtl;
    }
    .subheader-text {
        color: #666;
        font-size: 1.2rem;
        text-align: right;
        direction: rtl;
    }
    .card {
        padding: 1rem;
        border-radius: 10px;
        background-color: white;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        margin: 1rem 0;
        text-align: right;
        direction: rtl;
    }
    .card-title {
        color: #2d1b69;
        font-size: 1.5rem;
        font-weight: bold;
        margin-bottom: 0.5rem;
    }
    .card-text {
        color: #666;
        font-size: 1rem;
    }
    .email-container {
        display: flex;
        align-items: center;
        justify-content: flex-end;
    }
    .email-container .stTextInput {
        flex: 3;
    }
    .email-container .stButton {
        flex: 1;
        margin-left: 10px;
    }
</style>
""", unsafe_allow_html=True)

# Header Section
col1, col2 = st.columns([2, 1])

with col1:
    st.markdown('<h1 class="header-text">בילוי חוויתי איכותי<br>בעזרת משחקי חברה חכמים</h1>', unsafe_allow_html=True)
    st.markdown('<p class="subheader-text">ליצירת קשר אנא צרף אימייל</p>', unsafe_allow_html=True)
    
    # Create a row for the email input and button
    st.markdown('<div class="email-container">', unsafe_allow_html=True)
    email = st.text_input("", placeholder="הכנס את האימייל שלך", key="email")
    st.markdown('<div style="margin-left: 10px;"></div>', unsafe_allow_html=True)
    st.button("שלח")
    st.markdown('</div>', unsafe_allow_html=True)
    
    st.markdown('<p class="subheader-text" style="font-size: 0.8rem;">0 נרשמו לרשימת התפוצה</p>', unsafe_allow_html=True)

# "Why Choose Us" Section
st.markdown('<h2 class="header-text" style="font-size: 2rem; margin-top: 2rem;">למה לבחור בנו?</h2>', unsafe_allow_html=True)

# Three cards in a row
col1, col2, col3 = st.columns(3)

with col1:
    st.markdown("""
    <div class="card">
        <h3 class="card-title">משחקי חברה חכמים ומקצועיים</h3>
        <p class="card-text">מגוון רחב של משחקים חברתיים ומקצועיים אסטרטגיים, יצירתיים ואינטראקטיביים מהנים</p>
    </div>
    """, unsafe_allow_html=True)

with col2:
    st.markdown("""
    <div class="card">
        <h3 class="card-title">חוויה אינטלקטואלית מעציבה ומרגשת</h3>
        <p class="card-text">פיתוח חשיבה יצירתית, עבודת צוות ופתרון בעיות מורכבות בדרך מהנה ומאתגרת</p>
    </div>
    """, unsafe_allow_html=True)

with col3:
    st.markdown("""
    <div class="card">
        <h3 class="card-title">תמיכה צרופה</h3>
        <p class="card-text">חווית מוצר מלאה ונגישות של משחקי חברה שיעזרו לכם להתחבר להנאה יחד</p>
    </div>
    """, unsafe_allow_html=True)
