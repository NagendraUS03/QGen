from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import DataRequired, Email, Length, EqualTo, ValidationError
import re

# -----------------------
# Password Strength Validator
# -----------------------
def validate_password_strength(form, field):
    password = field.data
    if len(password) < 8:
        raise ValidationError("Password must be at least 8 characters.")
    if not re.search(r"[A-Z]", password):
        raise ValidationError("Password must include at least one uppercase letter.")
    if not re.search(r"\d", password):
        raise ValidationError("Password must include at least one number.")
    if not re.search(r"[_@!#$%^&*(),.?\":{}|<>]", password):
        raise ValidationError("Password must include at least one special character (_@!#$%^&* etc).")

# -----------------------
# Signup Form
# -----------------------
class SignupForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired(), Length(min=3, max=50)])
    email = StringField('Email', validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[
        DataRequired(),
        Length(min=8),
        validate_password_strength
    ])
    confirm_password = PasswordField('Confirm Password', validators=[
        DataRequired(),
        EqualTo('password', message='Passwords must match.')
    ])
    submit = SubmitField('Sign Up')

# -----------------------
# Login Form
# -----------------------
class LoginForm(FlaskForm):
    email = StringField('Email', validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired()])
    submit = SubmitField('Login')

class ForgotPasswordForm(FlaskForm):
    email = StringField("Email", validators=[DataRequired(), Email()])
    otp = StringField("OTP", validators=[DataRequired(), Length(min=6, max=6)])
    new_password = PasswordField("New Password", validators=[DataRequired()])
    confirm_password = PasswordField("Confirm Password", validators=[DataRequired(), EqualTo('new_password')])
    submit = SubmitField("Reset Password")
