import ssl
import streamlit as st
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email import encoders

def to_hebrew():
    return st.markdown(
        """
        <style>
        body {
            direction: rtl;
            text-align: right;
        }
        .stMarkdown p {
            direction: rtl;
            text-align: right;
        }
        </style>
        """,
        unsafe_allow_html=True
    )

def set_bg(url):
    """
    Sets the background image of the Streamlit app.

    Args:
      url (str): The URL of the image.
    """

    st.markdown(f"""
  <style>
  .stApp {{
    background-image: url('{url}');
    background-size: cover;
  }}
  </style>
  """, unsafe_allow_html=True)
    
def send_email(receiver, files=None):
    '''
    Send email via khanuka1912 password or help files,
    :param receiver:
    :param files:
    :return:
    '''
    with open('passtxt.txt') as f:
        password = f.read()
    # password=st.secrets.sisma
    sender = 'khanuka1912@gmail.com'
    body = "צורפת לרשימת התפוצה של Puzzle Mind"
    # Create a multipart message and set headers
    message = MIMEMultipart()
    message["From"] = sender
    message["To"] = receiver
    message["Subject"] = 'Puzzle Mind'
    message["Bcc"] = receiver  # Recommended for mass emails
    # Add body to email
    message.attach(MIMEText(body, "plain", "utf-8"))
    if files:
        for i, filename in enumerate(files):
            # Open PDF file in binary mode
            with open(filename, "rb") as attachment:
                # Add file as application/octet-stream
                part = MIMEBase("application", "octet-stream")
                # Email client can usually download this automatically as attachment
                part.set_payload(attachment.read())
            # Encode file in ASCII characters to send by email
            encoders.encode_base64(part)
            # Add header as key/value pair to attachment part
            part.add_header(
                f"Content-Disposition",
                f"attachment; filename= {filename}",
            )
            # Add attachment to message and convert message to string
            message.attach(part)
    text = message.as_string()
    # Log in to server using secure context and send email
    context = ssl.create_default_context()
    with smtplib.SMTP_SSL("smtp.gmail.com", 465, context=context) as server:
        server.login(sender, password)
        server.sendmail(sender, receiver, text)
    return body

def setup_container(col):
    with col:
        with st.container(border=True):
            pic=st.empty()
            wrt1=st.empty()
            wrt2=st.empty()
            wrt3=st.empty()
            mrkdn=st.empty()
    return pic,wrt1,wrt2,wrt3,mrkdn

def fill_container(pic,wrt1,wrt2,wrt3,mrkdn,img,txt1,txt2,txt3,txt4,color,width=300):
    pic.image(img,width=width, use_container_width="always")
    wrt1.write(f'**{txt1}**')
    wrt2.write(f'{txt2}')
    wrt3.write(f'{txt3}')
    mrkdn.markdown(f'<div style="direction:rtl;font-size:1em;color:gray;background-color:{color};">{txt4}</div>', unsafe_allow_html=True)

to_hebrew()
set_bg("https://iris-bs.co.il/wp-content/uploads/2021/01/100111.jpg")
col1, col2, col3 = st.columns([1, 2, 1])
col2.header(':flag-il: :rainbow[Puzzle Mind] :flag-il:', divider=True)
col1, col2 = st.columns([1, 1])
col1.header(':rainbow[ בילוי חוויתי איכותי בעזרת משחקי חברה חכמים.]')
col2.image("mankhe.png", width=375)
col1.write('ליצירת קשר אנא צרף אימייל')
col3, col4 = col1.columns([1, 4])
receiver = col4.text_input(' ', label_visibility='collapsed')
send_button = col3.button('שלח!', use_container_width=True,type='primary')
if send_button:
    msg = send_email(receiver)
    st.success(msg)
col1, col2, col3 = st.columns([1, 1, 1])
txt='למה לבחור בנו?'
st.markdown(f'<div style="direction:rtl;font-size:1em;font-weight:bold;text-align: center;">{txt}</div>', unsafe_allow_html=True)
col1, col2, col3 = st.columns([1, 1, 1])
c1_pic,c1_wrt1,c1_wrt2,c1_wrt3,c1_mrkdn1=setup_container(col1)
img='hanaa.png'
txt1='הנאה צרופה'
txt2=''
txt3=''
txt4='חוויה מהנה ובלתי נשכחת שתגרום לכם לצחוק להנות ולהתחבר יחד.'
fill_container(c1_pic,c1_wrt1,c1_wrt2,c1_wrt3,c1_mrkdn1,img,txt1,txt2,txt3,txt4,'yellow')
c2_pic,c2_wrt1,c2_wrt2,c2_wrt3,c2_mrkdn1=setup_container(col2)
img='havaia.png'
txt1='חוויה מעצימה ומגבשת'
txt2=''
txt3=''
txt4='פיתוח חשיבה יצירתית עבודת צוות ופתרון בעיות מורכבות בדרך מהנה ומאתגרת.'
fill_container(c2_pic,c2_wrt1,c2_wrt2,c2_wrt3,c2_mrkdn1,img,txt1,txt2,txt3,txt4,'cyan')
c3_pic,c3_wrt1,c3_wrt2,c3_wrt3,c3_mrkdn1=setup_container(col3)
img='haham.png'
txt1='משחקי חברה חכמים ומעניינים'
txt2=''
txt3=''
txt4='מגוון רחב של משחקים חברתיים המשלבים איסטרטגיה יצירתיות ואינטרקציה חברתית.'
fill_container(c3_pic,c3_wrt1,c3_wrt2,c3_wrt3,c3_mrkdn1,img,txt1,txt2,txt3,txt4,'greenyellow')
col1,col2,col3=st.columns([2,1,2])
content=col2.toggle('מה יש לנו להציע?')
if content:
    col1,col2,col3=st.columns([2,3,2])
    options=['תשבץ הגיון','זיהוי דמות','זיהוי מקום']
    res=col2.segmented_control('המשחקים שלנו',options=options)
    if res=='תשבץ הגיון':
        img='higayon.png'
        txt1='תשבץ הגיון'
        txt2=''
        txt3=''
        txt4='תשבץ הגיון מבוסס הקשר לארוע מסוים או לקבוצה מסוימת מוקרן על מסך גדול המנצח הינו זה הפותר את מירב ההגדרות.'
        fill_container(c1_pic,c1_wrt1,c1_wrt2,c1_wrt3,c1_mrkdn1,img,txt1,txt2,txt3,txt4,'yellow',200)
    if res=='זיהוי דמות':
        img='mi.png'
        txt1='מי הדמות'
        txt2=''
        txt3=''
        txt4='פלטפורמה של משחקים שבה המשתמש כותב חידה על דמות בטלפון החידה מוקרנת על מסך גדול ושאר המשתתפים פותרים כל חידה בתורה המנצח הינו זה שזיהה את מירב הדמויות .'
        fill_container(c2_pic,c2_wrt1,c2_wrt2,c2_wrt3,c2_mrkdn1,img,txt1,txt2,txt3,txt4,'cyan',200)
    if res=='זיהוי מקום':
        img='place.png'
        txt1='זיהוי מקום'
        txt2=''
        txt3=''
        txt4='המערכת בוחרת יישוב מסוים בארץ כמטרה, כל משתתף בוחר ישוב מסוים דרך הטלפון ומקבל חיווי על המרחק והכיוון של הבחירה שלו מהמטרה המנצח הינו הקרוב ביותר למטרה.'
        fill_container(c3_pic,c3_wrt1,c3_wrt2,c3_wrt3,c3_mrkdn1,img,txt1,txt2,txt3,txt4,'greenyellow',200)