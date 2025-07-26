import os
from dotenv import load_dotenv

load_dotenv()
class Config:
    MYSQL_HOST = 'localhost'
    MYSQL_USER = 'root'  # Replace with your MySQL username
    MYSQL_PASSWORD = 'QGen2025'  # Replace with your MySQL password
    MYSQL_DB = 'myDB'

MAIL_SERVER = 'smtp.gmail.com'
MAIL_PORT = 587
MAIL_USE_TLS = True
EMAIL_USER='qgenhelp@gmail.com'
EMAIL_PASSWORD='lckmphcrlotrpdob'
