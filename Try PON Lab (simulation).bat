@echo off
cd /d "%~dp0"
where python >nul 2>nul || (echo Python is not installed. Get it from https://www.python.org/downloads/ & pause & exit /b)
python -m pip install --quiet flask
set PONLAB_SIM=1
start "" http://localhost:8080
python app.py
pause
