from flask_mysqldb import mysql  # or however you access MySQL

def check_user_exists(email):
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
    user = cursor.fetchone()
    cursor.close()
    return user

def update_password(email, hashed_pw):
    cursor = mysql.connection.cursor()
    cursor.execute("UPDATE users SET password = %s WHERE email = %s", (hashed_pw, email))
    mysql.connection.commit()
    cursor.close()
