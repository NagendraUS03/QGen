from flask import Flask
from flask_mysqldb import MySQL
from flask_bcrypt import Bcrypt
from flask_login import LoginManager
from config import Config
from dotenv import load_dotenv
load_dotenv()

# Instantiate extensions
mysql = MySQL()
bcrypt = Bcrypt()
login_manager = LoginManager()

# Set the login view for @login_required redirect
login_manager.login_view = 'main.login'
login_manager.login_message_category = 'info'  # For flash messages

def create_app():
    # Initialize Flask app with configuration
    app = Flask(__name__)
    app.config.from_object(Config)

    # Initialize extensions with the app context
    mysql.init_app(app)
    bcrypt.init_app(app)
    login_manager.init_app(app)

    # Import and register the Blueprint
    from signup_signin.routes import main
    app.register_blueprint(main)

    return app
