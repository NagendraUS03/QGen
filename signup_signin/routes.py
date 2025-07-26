import email
from flask import Blueprint, render_template, redirect, url_for, request, flash, session
from flask_login import login_user, logout_user, login_required, UserMixin, current_user
from flask_bcrypt import Bcrypt
from flask_mysqldb import MySQL
from signup_signin.forms import SignupForm, LoginForm, ForgotPasswordForm
from signup_signin import mysql, bcrypt, login_manager
from dotenv import load_dotenv
import os, time, random, re, smtplib
from werkzeug.security import generate_password_hash
from datetime import datetime
from flask import Blueprint, request, jsonify
import numpy as np
import logging

import json
from flask import jsonify
from signup_signin.utils.GeneticAlgorithm import run_ga

load_dotenv()
EMAIL_USER = os.getenv("EMAIL_USER")
EMAIL_PASSWORD = os.getenv("EMAIL_PASSWORD")

main = Blueprint('main', __name__)

# User Class
class User(UserMixin):
    def __init__(self, id, username, email, password):
        self.id = str(id)
        self.username = username
        self.email = email
        self.password = password

@login_manager.user_loader
def load_user(user_id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM users WHERE id = %s", (user_id,))
    data = cur.fetchone()
    cur.close()
    if data:
        return User(id=data[0], username=data[1], email=data[2], password=data[3])
    return None

# ---------------------- EMAIL HELPERS ---------------------- #
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def send_info_email(to_email, subject, body, html=False):
    try:
        msg = MIMEMultipart()
        msg['From'] = EMAIL_USER
        msg['To'] = to_email
        msg['Subject'] = subject

        content_type = 'html' if html else 'plain'
        body_part = MIMEText(body, content_type, 'utf-8')
        msg.attach(body_part)

        with smtplib.SMTP("smtp.gmail.com", 587) as smtp:
            smtp.starttls()
            smtp.login(EMAIL_USER, EMAIL_PASSWORD)
            smtp.sendmail(EMAIL_USER, to_email, msg.as_string())

        print(f"✅ Info email sent to {to_email}")
        return True
    except Exception as e:
        print(f"❌ Email sending failed: {e}")
        return False

def send_otp_email(to_email, otp):
    subject = "QGEN Password Reset OTP"
    body = f"""Hello,\n\nYou requested to reset your password for your QGEN account. Your OTP code is: {otp}\n\nThis code will expire in 5 minutes.\n\nIf you didn't request this, please ignore this email.\n\nBest,\nQGEN Team"""
    send_info_email(to_email, subject, body)

# ---------------------- ROUTES ---------------------- #
@main.route('/')
def index():
    return render_template('home.html')

@main.route('/signup', methods=['GET', 'POST'])
def signup():
    form = SignupForm()
    
    if request.method == 'GET':
        return render_template('signup.html', form=form, step=1)

    # Get the current step
    step = request.form.get('step', '1')
    
    if step == '1':
        # Step 1: Username and Email validation
        username = request.form.get('username', '').strip()
        email = request.form.get('email', '').strip().lower()
        
        # Server-side validation
        errors = []
        
        # Username validation
        if not username:
            errors.append("Username is required")
        elif len(username) < 3:
            errors.append("Username must be at least 3 characters")
        elif not re.match(r'^[a-zA-Z0-9_]+$', username):
            errors.append("Username can only contain letters, numbers, and underscores")
            
        # Email validation
        if not email:
            errors.append("Email is required")
        elif not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', email):
            errors.append("Invalid email format")
        else:
            # Check for disposable email domains
            disposable_domains = [
                '10minutemail.com', 'tempmail.org', 'guerrillamail.com', 
                'mailinator.com', 'throwaway.email', 'temp-mail.org',
                'yopmail.com', 'maildrop.cc', 'sharklasers.com'
            ]
            email_domain = email.split('@')[1] if '@' in email else ''
            if email_domain in disposable_domains:
                errors.append("Temporary/disposable email addresses are not allowed")
        
        if errors:
            return jsonify(success=False, errors=errors), 400
        
        # Check if user already exists
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE email = %s OR username = %s", (email, username))
        existing_user = cur.fetchone()
        cur.close()
        
        if existing_user:
            if existing_user[2] == email:  # email matches
                return jsonify(success=False, errors=["Email already registered. Please login instead."]), 400
            if existing_user[1] == username:  # username matches
                return jsonify(success=False, errors=["Username already taken. Please choose another."]), 400
        
        # Generate and send OTP
        otp = ''.join([str(random.randint(0, 9)) for _ in range(6)])
        session['signup_otp'] = otp
        session['signup_email'] = email
        session['signup_username'] = username
        session['signup_otp_timestamp'] = time.time()
        
        # Send OTP email
        if send_signup_otp_email(email, username, otp):
            return jsonify(success=True, message="OTP sent to your email"), 200
        else:
            return jsonify(success=False, errors=["Failed to send OTP. Please try again."]), 500
    
    elif step == '2':
        # Step 2: OTP verification and password setup
        otp_input = request.form.get('otp', '').strip()
        password = request.form.get('password', '')
        confirm_password = request.form.get('confirm_password', '')
        
        # Retrieve session data
        stored_otp = session.get('signup_otp')
        stored_email = session.get('signup_email')
        stored_username = session.get('signup_username')
        otp_timestamp = session.get('signup_otp_timestamp')
        
        errors = []
        
        # Validate session data exists
        if not all([stored_otp, stored_email, stored_username, otp_timestamp]):
            return jsonify(success=False, errors=["Session expired. Please start again."]), 400
        
        # Check OTP expiry (10 minutes)
        if time.time() - otp_timestamp > 600:
            clear_signup_session()
            return jsonify(success=False, errors=["OTP expired. Please start again."]), 400
        
        # Validate OTP
        if not otp_input:
            errors.append("OTP is required")
        elif otp_input != stored_otp:
            errors.append("Invalid OTP. Please check and try again.")
        
        # Validate passwords
        if not password:
            errors.append("Password is required")
        elif len(password) < 8:
            errors.append("Password must be at least 8 characters long")
        else:
            # Password strength validation
            strength_criteria = 0
            if re.search(r'[a-z]', password):
                strength_criteria += 1
            if re.search(r'[A-Z]', password):
                strength_criteria += 1
            if re.search(r'\d', password):
                strength_criteria += 1
            if re.search(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>?]', password):
                strength_criteria += 1
            
            if strength_criteria < 3:
                errors.append("Password must meet at least 3 out of 4 strength criteria")
        
        if password != confirm_password:
            errors.append("Passwords do not match")
        
        if errors:
            return jsonify(success=False, errors=errors), 400
        
        # Create user account
        try:
            hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
            
            cur = mysql.connection.cursor()
            cur.execute(
                "INSERT INTO users (username, email, password) VALUES (%s, %s, %s)",
                (stored_username, stored_email, hashed_password)
            )
            mysql.connection.commit()
            cur.close()
            
            # Clear signup session
            clear_signup_session()
            
            # Send welcome email
            send_welcome_email(stored_email, stored_username)
            
            return jsonify(success=True, message="Account created successfully! Please login."), 200
            
        except Exception as e:
            print(f"❌ Error creating user: {e}")
            return jsonify(success=False, errors=["Error creating account. Please try again."]), 500
    
    elif step == 'resend_otp':
        # Resend OTP
        stored_email = session.get('signup_email')
        stored_username = session.get('signup_username')
        
        if not stored_email or not stored_username:
            return jsonify(success=False, errors=["Session expired. Please start again."]), 400
        
        # Generate new OTP
        otp = ''.join([str(random.randint(0, 9)) for _ in range(6)])
        session['signup_otp'] = otp
        session['signup_otp_timestamp'] = time.time()
        
        if send_signup_otp_email(stored_email, stored_username, otp):
            return jsonify(success=True, message="New OTP sent to your email"), 200
        else:
            return jsonify(success=False, errors=["Failed to resend OTP. Please try again."]), 500
    
    # Default fallback
    return render_template('signup.html', form=form, step=1)

# Add this new route for real-time email validation
@main.route('/validate-email', methods=['POST'])
def validate_email():
    """Real-time email validation endpoint"""
    data = request.get_json()
    email = data.get('email', '').strip().lower()
    
    if not email:
        return jsonify(valid=False, message="Email is required")
    
    # Email format validation
    if not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$', email):
        return jsonify(valid=False, message="Invalid email format")

# Add these helper functions after your existing email functions
def send_welcome_email(to_email, username):
    """Send welcome email after successful signup"""
    subject = "🎉 Welcome to QGen - Your Account is Ready!"
    
    html_body = f"""
    <html>
        <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto;">
            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; text-align: center; border-radius: 10px 10px 0 0;">
                <h1 style="color: white; margin: 0; font-size: 28px;">🎯 QGen</h1>
                <p style="color: #f0f0f0; margin: 5px 0 0 0;">Smart Question Paper Generator</p>
            </div>
            
            <div style="background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; border: 1px solid #e0e0e0;">
                <h2 style="color: #333; margin-top: 0;">🎉 Account Created Successfully!</h2>
                
                <p>Hello <strong>{username}</strong>,</p>
                
                <p>Congratulations! Your QGen account has been successfully created and verified. You're now ready to revolutionize the way you create question papers.</p>
                
                <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 8px; padding: 20px; color: white; text-align: center; margin: 25px 0;">
                    <h3 style="margin: 0 0 15px 0;">🚀 Get Started Now</h3>
                    <p style="margin: 0; opacity: 0.9;">Log in to your dashboard and create your first question paper in minutes!</p>
                </div>
                
                <h3 style="color: #333;">✨ What You Can Do:</h3>
                <ul style="color: #666; padding-left: 20px;">
                    <li><strong>📚 Add Subjects & Modules:</strong> Organize your curriculum</li>
                    <li><strong>🎯 Smart Paper Generation:</strong> AI-powered question selection</li>
                    <li><strong>⚖️ Difficulty Balance:</strong> Easy, medium, hard distribution</li>
                    <li><strong>🧠 Bloom's Taxonomy:</strong> Cognitive level optimization</li>
                    <li><strong>📊 Analytics:</strong> Track and improve your papers</li>
                </ul>
                
                <div style="background: #d4edda; border: 1px solid #c3e6cb; padding: 15px; border-radius: 5px; margin: 20px 0;">
                    <p style="margin: 0; color: #155724;"><strong>💡 Pro Tip:</strong> Start by adding your subjects and modules. This will help QGen generate more accurate and relevant question papers for you!</p>
                </div>
                
                <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e0e0e0;">
                    <p style="color: #666; font-size: 14px;">Need help getting started?</p>
                    <p style="color: #999; font-size: 12px; margin: 5px 0;">
                        📧 Email: <a href="mailto:qgenhelp@gmail.com" style="color: #667eea;">qgenhelp@gmail.com</a><br>
                        📖 Check out our user guide and tutorials in your dashboard
                    </p>
                </div>
                
                <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #e0e0e0;">
                    <p style="color: #999; font-size: 12px; margin: 0;">
                        Welcome to the QGen family! We're here to make question paper generation effortless and intelligent.<br>
                        This is an automated message from QGen - Smart Question Paper Generator.
                    </p>
                </div>
            </div>
        </body>
    </html>
    """
    
    return send_info_email(to_email, subject, html_body, html=True)

def clear_signup_session():
    """Clear signup-related session data"""
    session.pop('signup_otp', None)
    session.pop('signup_email', None)
    session.pop('signup_username', None)
    session.pop('signup_otp_timestamp', None)
    
    # Check for suspicious patterns
    if '..' in email or email.startswith('.') or email.endswith('.'):
        return jsonify(valid=False, message="Invalid email format")
    
    # Check for disposable email domains
    disposable_domains = [
        '10minutemail.com', 'tempmail.org', 'guerrillamail.com', 
        'mailinator.com', 'throwaway.email', 'temp-mail.org',
        'yopmail.com', 'maildrop.cc', 'sharklasers.com',
        'getnada.com', 'temp-mail.io', 'mohmal.com'
    ]
    
    email_domain = email.split('@')[1] if '@' in email else ''
    if email_domain in disposable_domains:
        return jsonify(valid=False, message="Temporary/disposable email addresses are not allowed")
    
    # Check if email already exists
    cur = mysql.connection.cursor()
    cur.execute("SELECT id FROM users WHERE email = %s", (email,))
    existing = cur.fetchone()
    cur.close()
    
    if existing:
        return jsonify(valid=False, message="Email already registered")
    
    return jsonify(valid=True, message="Email is available")

# Add these helper functions after your existing email functions

def send_signup_otp_email(to_email, username, otp):
    """Send OTP email for signup verification"""
    subject = "🔐 Verify Your QGen Account - OTP Code"
    
    html_body = f"""
    <html>
        <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto;">
            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; text-align: center; border-radius: 10px 10px 0 0;">
                <h1 style="color: white; margin: 0; font-size: 28px;">🎯 QGen</h1>
                <p style="color: #f0f0f0; margin: 5px 0 0 0;">Smart Question Paper Generator</p>
            </div>
            
            <div style="background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; border: 1px solid #e0e0e0;">
                <h2 style="color: #333; margin-top: 0;">Welcome to QGen, {username}! 👋</h2>
                
                <p>We're excited to have you join our community. To complete your account setup, please verify your email address.</p>
                
                <div style="background: white; border: 2px dashed #667eea; border-radius: 8px; padding: 20px; text-align: center; margin: 25px 0;">
                    <p style="margin: 0; color: #666; font-size: 14px;">Your Verification Code</p>
                    <h1 style="margin: 10px 0; color: #667eea; font-size: 36px; letter-spacing: 8px; font-family: 'Courier New', monospace;">{otp}</h1>
                    <p style="margin: 0; color: #999; font-size: 12px;">This code expires in 10 minutes</p>
                </div>
                
                <div style="background: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 5px; margin: 20px 0;">
                    <p style="margin: 0; color: #856404;"><strong>⚠️ Security Note:</strong> Never share this OTP with anyone. QGen team will never ask for your OTP via phone or email.</p>
                </div>
                
                <h3 style="color: #333;">What's Next?</h3>
                <ul style="color: #666; padding-left: 20px;">
                    <li>Enter the OTP code on the signup page</li>
                    <li>Create a strong password</li>
                    <li>Start generating question papers instantly!</li>
                </ul>
                
                <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e0e0e0;">
                    <p style="color: #999; font-size: 12px; margin: 0;">
                        If you didn't create an account with QGen, please ignore this email.<br>
                        This is an automated message from QGen - Smart Question Paper Generator.
                    </p>
                </div>
            </div>
        </body>
    </html>
    """
    
    return send_info_email(to_email, subject, html_body, html=True)

def send_welcome_email(to_email, username):
    """Send welcome email after successful signup"""
    subject = "🎉 Welcome to QGen - Your Account is Ready!"
    
    html_body = f"""
    <html>
        <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto;">
            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; text-align: center; border-radius: 10px 10px 0 0;">
                <h1 style="color: white; margin: 0; font-size: 28px;">🎯 QGen</h1>
                <p style="color: #f0f0f0; margin: 5px 0 0 0;">Smart Question Paper Generator</p>
            </div>
            
            <div style="background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; border: 1px solid #e0e0e0;">
                <h2 style="color: #333; margin-top: 0;">🎉 Account Created Successfully!</h2>
                
                <p>Hello <strong>{username}</strong>,</p>
                
                <p>Congratulations! Your QGen account has been successfully created and verified. You're now ready to revolutionize the way you create question papers.</p>
                
                <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 8px; padding: 20px; color: white; text-align: center; margin: 25px 0;">
                    <h3 style="margin: 0 0 15px 0;">🚀 Get Started Now</h3>
                    <p style="margin: 0; opacity: 0.9;">Log in to your dashboard and create your first question paper in minutes!</p>
                </div>
                
                <h3 style="color: #333;">✨ What You Can Do:</h3>
                <ul style="color: #666; padding-left: 20px;">
                    <li><strong>📚 Add Subjects & Modules:</strong> Organize your curriculum</li>
                    <li><strong>🎯 Smart Paper Generation:</strong> AI-powered question selection</li>
                    <li><strong>⚖️ Difficulty Balance:</strong> Easy, medium, hard distribution</li>
                    <li><strong>🧠 Bloom's Taxonomy:</strong> Cognitive level optimization</li>
                    <li><strong>📊 Analytics:</strong> Track and improve your papers</li>
                </ul>
                
                <div style="background: #d4edda; border: 1px solid #c3e6cb; padding: 15px; border-radius: 5px; margin: 20px 0;">
                    <p style="margin: 0; color: #155724;"><strong>💡 Pro Tip:</strong> Start by adding your subjects and modules. This will help QGen generate more accurate and relevant question papers for you!</p>
                </div>
                
                <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e0e0e0;">
                    <p style="color: #666; font-size: 14px;">Need help getting started?</p>
                    <p style="color: #999; font-size: 12px; margin: 5px 0;">
                        📧 Email: <a href="mailto:qgenhelp@gmail.com" style="color: #667eea;">qgenhelp@gmail.com</a><br>
                        📖 Check out our user guide and tutorials in your dashboard
                    </p>
                </div>
                
                <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #e0e0e0;">
                    <p style="color: #999; font-size: 12px; margin: 0;">
                        Welcome to the QGen family! We're here to make question paper generation effortless and intelligent.<br>
                        This is an automated message from QGen - Smart Question Paper Generator.
                    </p>
                </div>
            </div>
        </body>
    </html>
    """
    
    return send_info_email(to_email, subject, html_body, html=True)

def clear_signup_session():
    """Clear signup-related session data"""
    session.pop('signup_otp', None)
    session.pop('signup_email', None)
    session.pop('signup_username', None)
    session.pop('signup_otp_timestamp', None)


from datetime import datetime
from flask import request

@main.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        email = form.email.data.strip()
        password_input = form.password.data

        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE email = %s", (email,))
        user_data = cur.fetchone()
        cur.close()

        if not user_data:
            flash("❌ No account found with this email.", "danger")
            return redirect(url_for('main.signup'))

        stored_password = user_data[3]
        if bcrypt.check_password_hash(stored_password, password_input):
            user_obj = User(id=user_data[0], username=user_data[1], email=user_data[2], password=stored_password)
            login_user(user_obj)

            # Capture login details
            login_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            ip_address = request.remote_addr or 'Unknown IP'

            # Compose email body
            email_body = f"""
            <html>
                <body style="font-family: Arial, sans-serif; line-height: 1.6;">
                    <p>Hello <b>{user_data[1]}</b>,</p>
    
                    <p>We noticed a successful login to your <b>QGen</b> account just now.<br>
                    If this was you, there’s nothing to worry about — welcome back! 🎉</p>
    
                    <h4>🧾 Login Details:</h4>
                    <p>
                        <b>Date:</b> {login_time.split()[0]}<br>
                        <b>Time:</b> {login_time.split()[1]}<br>
                        <b>IP Address:</b> {ip_address}<br>
                    </p>

                    <p>If this login was <b>NOT</b> performed by you, please:<br>
                        1. Reset the password immediately<br>
                        2. Contact our support team at <a href="mailto:qgenhelp@gmail.com">qgenhelp@gmail.com</a>
                    </p>

                    <p>Thank you for using <b>QGen – Your Smart Question Paper Assistant</b>.<br>
                    We’re here to make paper generation faster, smarter, and syllabus-driven.</p>

                    <p>Stay secure,<br>
                    The QGen Team</p>

                    <p style="color: gray; font-size: 0.9em;">
                    (Do not share your password or OTP with anyone. We never ask for it.)
                    </p>
                </body>
            </html>"""

            send_info_email(user_data[2], "✅ Login Successful — QGen", email_body,html=True)

            flash("✅ Logged in successfully.", "success")
            return redirect(url_for('main.dashboard'))
        else:
            flash("⚠️ Incorrect password. Try again.", "warning")

    return render_template('login.html', form=form)


@main.route('/forgot-password', methods=['GET', 'POST'])
def forgot_password():
    form = ForgotPasswordForm()

    if request.method == 'GET':
        return render_template('forgetpassword.html', form=form, show_otp_form=False)

    step = request.form.get('step')
    email = request.form.get('email')

    if step == 'email':
        # Step 1: Send OTP to user
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cur.fetchone()
        cur.close()

        if not user:
            flash("❌ No account found with that email.", "danger")
            return render_template('forgetpassword.html', form=form, show_otp_form=False)

        otp = ''.join([str(random.randint(0, 9)) for _ in range(6)])
        session['otp'] = otp
        session['otp_email'] = email
        session['otp_timestamp'] = time.time()
        session['otp_purpose'] = "forgot_password"

        send_otp_email(email, otp)
        flash("✅ OTP sent to your email.", "success")
        return render_template('forgetpassword.html', form=form, email=email, show_otp_form=True)

    elif step in ['verify', 'resend']:
        if step == 'resend':
            otp = ''.join([str(random.randint(0, 9)) for _ in range(6)])
            session['otp'] = otp
            session['otp_email'] = email
            session['otp_timestamp'] = time.time()
            session['otp_purpose'] = "forgot_password"

            send_otp_email(email, otp)
            flash("✅ OTP resent to your email.", "success")
            return render_template('forgetpassword.html', form=form, email=email, show_otp_form=True)

        otp_input = request.form.get('otp')
        new_password = request.form.get('new_password')
        confirm_password = request.form.get('confirm_password')
        stored_otp = session.get('otp')
        stored_email = session.get('otp_email')
        timestamp = session.get('otp_timestamp')
        purpose = session.get('otp_purpose')

        if not all([otp_input, new_password, confirm_password]):
            flash("⚠️ All fields are required.", "warning")
            return render_template('forgetpassword.html', form=form, email=email, show_otp_form=True)

        if purpose != "forgot_password" or email != stored_email or otp_input != stored_otp:
            flash("❌ Invalid OTP or session expired.", "danger")
            return render_template('forgetpassword.html', form=form, email=email, show_otp_form=True)

        if time.time() - timestamp > 600:
            session.clear()
            flash("⚠️ OTP expired. Please try again.", "warning")
            return render_template('forgetpassword.html', form=form, show_otp_form=False)

        if new_password != confirm_password:
            flash("❌ Passwords do not match.", "danger")
            return render_template('forgetpassword.html', form=form, email=email, show_otp_form=True)

        if len(new_password) < 8:
            flash("❌ Password must be at least 8 characters.", "danger")
            return render_template('forgetpassword.html', form=form, email=email, show_otp_form=True)

        hashed_pw = bcrypt.generate_password_hash(new_password).decode('utf-8')
        cur = mysql.connection.cursor()
        cur.execute("UPDATE users SET password = %s WHERE email = %s", (hashed_pw, email))
        mysql.connection.commit()
        cur.close()

        session.clear()
        flash("✅ Password reset successful. Please log in.", "success")
        return redirect(url_for('main.login'))

    return render_template('forgetpassword.html', form=form, show_otp_form=False)

@main.route('/logout')
@login_required
def logout():
    logout_user()
    flash("👋 You have been logged out.", "info")
    return redirect(url_for('main.login'))

@main.route('/dashboard')
@login_required
def dashboard():
    return render_template('dashboard.html', username=current_user.username)

@main.route('/account-settings')
@login_required
def account_settings():
    return render_template('accountsettings.html')

@main.route('/request-username-change-otp', methods=['POST'])
@login_required
def request_username_change_otp():
    generated_otp = ''.join([str(random.randint(0, 9)) for _ in range(6)])
    session["otp"] = generated_otp
    session["otp_email"] = current_user.email
    session["otp_timestamp"] = time.time()
    session["otp_purpose"] = "username_change"
    session["last_otp_sent_time"] = time.time()
    send_otp_email(current_user.email, generated_otp)
    return {'success': True, 'message': 'OTP sent to your email'}, 200

@main.route('/change-username', methods=['POST'])
@login_required
def change_username():
    otp = request.form.get('otp')
    new_username = request.form.get('new_username')
    stored_otp = session.get("otp")
    stored_email = session.get("otp_email")
    otp_timestamp = session.get("otp_timestamp")
    otp_purpose = session.get("otp_purpose")

    if not all([otp, new_username, stored_otp, stored_email, otp_purpose]):
        return {'success': False, 'message': 'OTP session expired or invalid input'}, 400
    if otp != stored_otp or current_user.email != stored_email or otp_purpose != "username_change":
        return {'success': False, 'message': 'Invalid or expired OTP'}, 400
    if time.time() - otp_timestamp > 600:
        clear_otp_session()
        return {'success': False, 'message': 'OTP expired'}, 400

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM users WHERE username = %s", (new_username,))
    existing = cur.fetchone()
    if existing and str(existing[0]) != current_user.id:
        cur.close()
        return {'success': False, 'message': 'Username already taken'}, 400

    cur.execute("UPDATE users SET username = %s WHERE id = %s", (new_username, current_user.id))
    mysql.connection.commit()
    cur.close()
    clear_otp_session()
    send_info_email(current_user.email, "Username Updated", f"Hello,\n\nYour QGen username has been successfully changed to: {new_username}.")
    return {'success': True, 'message': 'Username updated successfully'}, 200

@main.route('/request-password-reset-otp', methods=['POST'])
@login_required
def request_password_reset_otp():
    last_time = session.get("last_otp_sent_time")
    now = time.time()
    if last_time and (now - last_time) < 60:
        remaining = int(60 - (now - last_time))
        return {'success': False, 'message': f'Please wait {remaining}s'}, 429

    generated_otp = ''.join([str(random.randint(0, 9)) for _ in range(6)])
    session["otp"] = generated_otp
    session["otp_email"] = current_user.email
    session["otp_timestamp"] = now
    session["otp_purpose"] = "password_reset"
    session["last_otp_sent_time"] = now
    send_otp_email(current_user.email, generated_otp)
    return {'success': True, 'message': 'OTP sent to your email'}, 200

@main.route('/reset-password', methods=['POST'])
@login_required
def reset_password():
    otp = request.form.get('otp')
    new_password = request.form.get('new_password')
    confirm_password = request.form.get('confirm_password')
    stored_otp = session.get("otp")
    stored_email = session.get("otp_email")
    otp_timestamp = session.get("otp_timestamp")
    otp_purpose = session.get("otp_purpose")

    if not all([otp, new_password, confirm_password, stored_otp, stored_email, otp_purpose]):
        return {'success': False, 'message': 'Missing fields or OTP expired'}, 400
    if otp != stored_otp or current_user.email != stored_email or otp_purpose != "password_reset":
        return {'success': False, 'message': 'Invalid or expired OTP'}, 400
    if new_password != confirm_password:
        return {'success': False, 'message': 'Passwords do not match'}, 400
    if len(new_password) < 8:
        return {'success': False, 'message': 'Password must be at least 8 chars'}, 400
    if time.time() - otp_timestamp > 600:
        clear_otp_session()
        return {'success': False, 'message': 'OTP expired'}, 400

    hashed_password = bcrypt.generate_password_hash(new_password).decode('utf-8')
    cur = mysql.connection.cursor()
    cur.execute("UPDATE users SET password = %s WHERE id = %s", (hashed_password, current_user.id))
    mysql.connection.commit()
    cur.close()
    clear_otp_session()
    send_info_email(current_user.email, "Password Changed", f"Hello,\n\nYour QGen account password has been updated.\nIf this wasn't you, reset it immediately.")
    return {'success': True, 'message': 'Password updated successfully'}, 200

def clear_otp_session():
    session.pop("otp", None)
    session.pop("otp_email", None)
    session.pop("otp_timestamp", None)
    session.pop("otp_purpose", None)
    session.pop("last_otp_sent_time", None)

#----------------------- SUBJECTS ---------------------- #
@main.route('/subjects', methods=['GET'])
@login_required
def subjects():
    search = request.args.get('search')
    scheme = request.args.get('scheme')

    query = "SELECT * FROM Subjects WHERE 1=1"
    params = []

    if search:
        query += " AND Subject_Name LIKE %s"
        params.append(f"%{search}%")
    if scheme:
        query += " AND Scheme = %s"
        params.append(scheme)

    cur = mysql.connection.cursor()
    cur.execute(query, params)
    data = cur.fetchall()
    cur.close()

    subjects = []
    for row in data:
        subjects.append({
            "Subject_ID": row[0],
            "Subject_Name": row[1],
            "Subject_Code": row[3],
            "Scheme_Year": row[2],
            "Semester": row[4],
            "Credits": row[5],
            "Total_Marks": row[7],
        })

    return render_template("subjects.html", subjects=subjects)

#----------------------- SUBJECT ROUTES ---------------------- #
@main.route('/add-subject', methods=['GET', 'POST'])
@login_required
def add_subject():
    cur = mysql.connection.cursor()

    if request.method == 'POST':
        subject_name = request.form.get('subject_name')
        subject_code = request.form.get('subject_code')
        semester = request.form.get('semester')
        credits = request.form.get('credits')
        total_marks = request.form.get('total_marks')

        # Check for custom scheme
        scheme = request.form.get('scheme')
        new_scheme = request.form.get('new_scheme')
        final_scheme = new_scheme.strip() if new_scheme else scheme

        # Insert into DB
        cur.execute("""
            INSERT INTO Subjects (Subject_Name, Subject_Code, Scheme, Semester, Credits, Learning_Hours, Total_Marks)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (subject_name, subject_code, final_scheme, semester, credits, 0, total_marks))
        mysql.connection.commit()
        cur.close()

        flash("✅ Subject added successfully!", "success")
        return redirect(url_for('main.subjects'))

    # GET request — fetch unique schemes from existing subjects
    cur.execute("SELECT DISTINCT Scheme FROM Subjects")
    schemes = sorted({row[0] for row in cur.fetchall()})
    cur.close()

    return render_template('addSubject.html', schemes=schemes)

@main.route('/delete-subject/<int:subject_id>', methods=['POST'])
@login_required
def delete_subject(subject_id):
    cur = mysql.connection.cursor()
    
    # First delete all modules associated with this subject
    cur.execute("DELETE FROM Modules WHERE Subject_ID = %s", (subject_id,))
    
    # Then delete the subject
    cur.execute("DELETE FROM Subjects WHERE Subject_ID = %s", (subject_id,))
    
    mysql.connection.commit()
    cur.close()
    
    flash("✅ Subject and all associated modules deleted successfully!", "success")
    return redirect(url_for('main.subjects'))

#----------------------- MODULE ROUTES ---------------------- #
@main.route('/modules/<int:subject_id>', methods=['GET'])
@login_required
def modules(subject_id):
    # Get subject info
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM Subjects WHERE Subject_ID = %s", (subject_id,))
    subject_data = cur.fetchone()
    
    if not subject_data:
        flash("❌ Subject not found", "danger")
        return redirect(url_for('main.subjects'))
    
    subject = {
        "Subject_ID": subject_data[0],
        "Subject_Name": subject_data[1],
        "Scheme": subject_data[2],
        "Subject_Code": subject_data[3],
        "Semester": subject_data[4],
        "Credits": subject_data[5],
        "Learning_Hours": subject_data[6],
        "Total_Marks": subject_data[7]
    }
    
    # Get modules for this subject
    cur.execute("SELECT * FROM Modules WHERE Subject_ID = %s", (subject_id,))
    modules_data = cur.fetchall()
    cur.close()
    
    modules = []
    for row in modules_data:
        modules.append({
            "Module_ID": row[0], 
            "Module_Name": row[2],
            "Module_Number": row[3],
            "Module_Marks": row[4]
        })
    
    return render_template('modules.html', subject=subject, modules=modules)

@main.route('/add-module/<int:subject_id>', methods=['GET', 'POST'])
@main.route('/add-module/<int:subject_id>/<int:module_id>', methods=['GET', 'POST'])
@login_required
def add_module(subject_id, module_id=None):
    # Get subject info for display
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM Subjects WHERE Subject_ID = %s", (subject_id,))
    subject_data = cur.fetchone()
    
    if not subject_data:
        flash("❌ Subject not found", "danger")
        return redirect(url_for('main.subjects'))
    
    subject = {
        "Subject_ID": subject_data[0],
        "Subject_Name": subject_data[1],
        "Subject_Code": subject_data[3]
    }
    
    # Check if editing an existing module
    if module_id:
        cur.execute("SELECT * FROM Modules WHERE Module_ID = %s", (module_id,))
        module_data = cur.fetchone()
        
        if not module_data:
            flash("❌ Module not found", "danger")
            return redirect(url_for('main.modules', subject_id=subject_id))
        
        module = {
            "Module_ID": module_data[0],
            "Module_Name": module_data[2],
            "Module_Number": module_data[3],
            "Module_Marks": module_data[4]
        }
        
        if request.method == 'POST':
            module_name = request.form.get('module_name')
            module_code = request.form.get('module_code')
            module_marks = request.form.get('module_marks')
            
            # Update existing module
            cur.execute("""
                UPDATE Modules 
                SET Module_Name = %s, Module_Number = %s, Total_Marks = %s
                WHERE Module_ID = %s
            """, (module_name, module_code, module_marks, module_id))
            mysql.connection.commit()
            
            flash("✅ Module updated successfully!", "success")
            return redirect(url_for('main.modules', subject_id=subject_id))
        
        cur.close()
        return render_template('editmodules.html', subject=subject, module=module)
    
    # Add new module
    if request.method == 'POST':
        module_name = request.form.get('module_name')
        module_code = request.form.get('module_code')
        module_marks = request.form.get('module_marks')

        # Insert including Subject_ID
        cur.execute("""
            INSERT INTO Modules (Subject_ID, Module_Name, Module_Number, Total_Marks)
            VALUES (%s, %s, %s, %s)
        """, (subject_id, module_name, module_code, module_marks))
        mysql.connection.commit()
        cur.close()
        
        flash("✅ Module added successfully!", "success")
        return redirect(url_for('main.modules', subject_id=subject_id))
    
    cur.close()
    return render_template('addmodule.html', subject=subject)

@main.route('/delete-module/<int:module_id>', methods=['POST'])
@login_required
def delete_module(module_id):
    cur = mysql.connection.cursor()
    
    # Get subject_id before deleting for redirect
    cur.execute("SELECT Subject_ID FROM Modules WHERE Module_ID = %s", (module_id,))
    subject_data = cur.fetchone()
    
    if not subject_data:
        flash("❌ Module not found", "danger")
        return redirect(url_for('main.subjects'))
    
    subject_id = subject_data[0]
    
    # Delete the module
    cur.execute("DELETE FROM Modules WHERE Module_ID = %s", (module_id,))
    mysql.connection.commit()
    cur.close()
    
    flash("✅ Module deleted successfully!", "success")
    return redirect(url_for('main.modules', subject_id=subject_id))

#----------------------- edit subject ---------------------- #  
@main.route('/edit-subject/<int:subject_id>', methods=['GET', 'POST'])
@login_required
def edit_subject(subject_id):
    cur = mysql.connection.cursor()

    if request.method == 'POST':
        subject_name = request.form.get('subject_name')
        subject_code = request.form.get('subject_code')
        semester = request.form.get('semester')
        credits = request.form.get('credits')
        total_marks = request.form.get('total_marks')
        scheme = request.form.get('scheme')
        new_scheme = request.form.get('new_scheme')
        final_scheme = new_scheme.strip() if new_scheme else scheme

        cur.execute("""
            UPDATE Subjects 
            SET Subject_Name=%s, Subject_Code=%s, Scheme=%s, Semester=%s, Credits=%s, Total_Marks=%s
            WHERE Subject_ID=%s
        """, (subject_name, subject_code, final_scheme, semester, credits, total_marks, subject_id))
        mysql.connection.commit()
        cur.close()

        flash("✅ Subject updated successfully!", "success")
        return redirect(url_for('main.subjects'))

    # GET request: fetch current subject info
    cur.execute("SELECT * FROM Subjects WHERE Subject_ID = %s", (subject_id,))
    data = cur.fetchone()
    cur.execute("SELECT DISTINCT Scheme FROM Subjects")
    schemes = sorted({row[0] for row in cur.fetchall()})
    cur.close()

    subject = {
        "Subject_ID": data[0],
        "Subject_Name": data[1],
        "Subject_Code": data[3],
        "Scheme_Year": data[2],
        "Semester": data[4],
        "Credits": data[5],
        "Total_Marks": data[7]
    }

    return render_template('editSubjects.html', subject=subject, schemes=schemes)

#-------------------- GENERATE PAPER-Dashboard ---------------------- #
@main.route('/generate', methods=['GET'])
@login_required
def generate_page():
    cur = mysql.connection.cursor()
    cur.execute("SELECT Subject_ID, Subject_Name, Subject_Code FROM subjects")
    subjects = cur.fetchall()

    cur.execute("SELECT Module_ID, Module_Name, Subject_ID FROM modules")
    modules = cur.fetchall()
    cur.close()

    return render_template("GeneratePaper.html", subjects=subjects, modules=modules)

#----------------- PAPER RESULT ---------------------- #
@main.route("/paper_result")
@login_required
def paper_result():
    return render_template("PaperResults.html")

#----------------- GENERATE PAPER - paper result ---------------------- #
@main.route('/generate_paper', methods=['POST'])
@login_required
def generate_paper():
    try:
        data = request.get_json()
        
        # Log the incoming data for debugging
        print("📥 Received data:", data)
        
        # Validate required fields
        subject_id = data.get("subject_id")
        module_ids = data.get("modules") or []
        total_marks = data.get("marks")
        difficulty = data.get("difficulty") or {}
        taxonomy = data.get("taxonomy") or []
        
        # Validate input
        error_message = None
        if not subject_id:
            error_message = "Missing subject ID"
        elif not module_ids or not isinstance(module_ids, list):
            error_message = "Missing or invalid modules"
        elif not total_marks or not isinstance(total_marks, int):
            error_message = "Missing or invalid total marks"
        elif not difficulty or not isinstance(difficulty, dict):
            error_message = "Missing or invalid difficulty distribution"
        elif not taxonomy or not isinstance(taxonomy, list):
            error_message = "Missing or invalid taxonomy levels"
        
        if error_message:
            print("❌ Validation error:", error_message)
            return jsonify(success=False, message=f"Invalid or incomplete input: {error_message}"), 400

        # Convert Bloom levels to internal enum
        bloom_map = {"remember": "L1", "understand": "L2", "apply": "L3"}
        bloom_levels = [bloom_map.get(t.lower()) for t in taxonomy if t.lower() in bloom_map]
        
        if not bloom_levels:
            return jsonify(success=False, message="No valid Bloom taxonomy levels selected"), 400

        # Fetch questions from database
        cur = mysql.connection.cursor()
        
        # Ensure module_ids are integers
        module_ids = [int(mid) for mid in module_ids if str(mid).isdigit()]
        
        if not module_ids:
            return jsonify(success=False, message="No valid module IDs provided"), 400
            
        # Build the query for matching questions
        format_strings = ','.join(['%s'] * len(module_ids))
        query = f"""
            SELECT Question_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy 
            FROM Questions 
            WHERE Module_ID IN ({format_strings})
            AND Bloom_Taxonomy IN %s
        """
        
        # Execute query with parameters
        print("🔍 Executing query with params:", module_ids, tuple(bloom_levels))
        cur.execute(query, (*module_ids, tuple(bloom_levels)))
        candidates = cur.fetchall()
        
        if not candidates:
            return jsonify(success=False, message="No matching questions found for the selected criteria"), 404
            
        print(f"✅ Found {len(candidates)} candidate questions")

        # Run genetic algorithm to generate paper
        generated_questions, fitness_score = run_ga(candidates, total_marks, difficulty)
        
        if not generated_questions:
            return jsonify(success=False, message="Could not generate a valid paper with the given constraints"), 500

        # Store the generated paper in the database
        try:
            cur.execute("""
                INSERT INTO generated_papers (Subject_ID, Date_Created, Marks_Distribution, Fitness_Score)
                VALUES (%s, %s, %s, %s)
            """, (subject_id, datetime.now(), json.dumps(difficulty), fitness_score))
            paper_id = cur.lastrowid
            
            for q in generated_questions:
                cur.execute("INSERT INTO paper_questions (GP_ID, Question_ID) VALUES (%s, %s)", 
                           (paper_id, q["id"]))
                           
            mysql.connection.commit()
            
            print(f"✅ Generated paper saved with ID: {paper_id}")
            
            # Return success with the generated questions
            return jsonify(success=True, 
                          paper_id=paper_id, 
                          questions=generated_questions)
                          
        except Exception as db_error:
            print("❌ Database error:", db_error)
            mysql.connection.rollback()
            return jsonify(success=False, message="Error saving generated paper"), 500
        finally:
            cur.close()

    except Exception as e:
        print("❌ Unexpected error:", e)
        return jsonify(success=False, message="Server error while generating paper"), 500
