# QGen - A Customised Question Paper Generator

**QGen** is a full-stack web application designed to automate the generation of academic question papers based on syllabus structure and cognitive levels (Bloom's Taxonomy). Built using Flask, MySQL, and Tailwind CSS,
  QGen eliminates manual workload, reduces human error, ensures syllabus alignment, and enables dynamic question paper generation using Genetic Algorithms.

---

## Features:

- OTP-based user authentication for faculty
- Question selection based on:
- Subject & modules
- Total marks
- Bloom’s levels (L1 – Remember, L2 – Understand, L3 – Apply)
- Difficulty level (Easy, Medium, Hard)
- Optimized question selection using Genetic Algorithm
- Export question paper as PDF or Word (`.docx`)
- Audit trail & question reuse prevention
- Real-time form validations and dynamic module loading

---

## Powered by Bloom’s Taxonomy:

Supports automatic distribution of cognitive levels:
- **L1** – Remember
- **L2** – Understand
- **L3** – Apply  
(Extendable to L4–L6 in future versions)

---

## System Architecture:
1. Frontend (HTML + Tailwind CSS / React)
2. Backend (Flask - Python)
3. MySQL Database <--> Genetic Algorithm
4. PDF / DOCX Export Engine

---

## Project Structure:
QGen/                                                                                                                                                                                                                                             
├── signup_signin/ # User auth module (signup, signin)                                                                                                                                                                                           
├── static/ # CSS, images, assets                                                                                                                                                                                                                
├── templates/ # HTML templates (Jinja2)                                                                                                                                                                                                             
├── utils/ # Utility functions                                                                                                                                                                                                                       
├── config.py # App configuration                                                                                                                                                                                                                    
├── forms.py # Flask-WTF forms                                                                                                                                                                                                                  
├── models.py # DB Models (if using ORM)                                                                                                                                                                                                         
├── routes.py # Main route handlers                                                                                                                                                                                                                     
├── run.py # Flask entry point
├── Database.sql # MySQL schema                                                                                                                                                                                                                 
├── requirements.txt # Python dependencies                                                                                                                                                                                                      
├── .env # Environment variables (DB, secret keys)                                                                                                                                                                                              
├── venv/ # Python virtual environment                                                                                                                                                                                                            


---

## Tech Stack

- **Frontend**: HTML5, Tailwind CSS (optionally React)
- **Backend**: Flask (Python)
- **Database**: MySQL (WorkBench)
- **PDF Export**: `fpdf`
- **Word Export**: `python-docx`
- **Email & OTP**: `smtplib`, `email.message`
- **AI Algorithm**: Genetic Algorithm (GA)

---

## Setup Instructions

### Prerequisites
- Python 3.x
- MySQL Server
- VS Code or any IDE
- Git

### Clone the repo

git clone https://github.com/NagendraUS03/QGen.git                                                                                                                                                                                                 
cd QGen

---

### Create a virtual environment
python -m venv venv                                                                                                                                                                                                                              
source venv/Scripts/activate     # On Windows

---

### Install requirements
pip install -r requirements.txt

---

### Import database
1. Open Database.sql in MySQL Workbench
2. Run the script to create necessary tables

---
### Set up .env
SECRET_KEY=your-secret-key                                                                                                                                                                                                                        
MAIL_USERNAME=your-email@example.com                                                                                                                                                                                                                 
MAIL_PASSWORD=your-email-password                                                                                                                                                                                                                     
DATABASE_URL=mysql://user:password@localhost/qgen                                                                                                                                                                                                         

---

### Run the application
python run.py                                                                                                                                                                                                                                   
Then open http://localhost:5000 in your browser.

---

### Future Scope:
1. ML-based automatic tagging of Bloom’s levels & difficulty
2. NLP-powered question recommendation
3. Adaptive difficulty using student performance data
4. Admin dashboard with analytics & logs
5. Bulk import/export of questions via CSV
6. Email Authentication and Security


