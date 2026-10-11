@echo off
title Tag AI - INSTALLER
color 0B
echo.
echo  ========================================
echo   Tag AI - WINDOWS INSTALLER
echo  ========================================
echo.

cd /d "%~dp0"
set TAG_AI_PATH=%~dp0

echo  [1/4] Checking Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo  [ERROR] Python not found!
    echo  Install Python 3.10+ from https://python.org
    echo  Check 'Add Python to PATH' during install!
    pause
    exit /b 1
)
echo  [1/4] Python OK!

echo  [2/4] Installing dependencies...
pip install -r requirements.txt
echo  [2/4] Done!

echo  [3/4] Setting up .env file...
if not exist ".env" (
    copy .env.example .env >nul
    echo  Opening .env - add your API keys then save and close...
    notepad .env
) else (
    echo  [3/4] .env already exists.
)

echo  [4/4] Adding Tag AI to Windows Startup...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "Tag AI" /t REG_SZ /d "cmd /c start /B /MIN pythonw \"%TAG_AI_PATH%run_tag_ai.py\"" /f >nul
echo  [4/4] Tag AI will now start automatically on Windows boot!

echo.
echo  ========================================
echo   INSTALLATION COMPLETE!
echo  ========================================
echo.
echo  - Double-click TAG-AI.bat to start Tag AI manually anytime
echo  - Or restart your PC - Tag AI starts automatically!
echo  - Say your wake word to activate
echo  - HUD appears in the top area of your screen
echo.
echo  Press any key to launch Tag AI now...
pause >nul

start "" /B pythonw run_tag_ai.py
echo  Tag AI is running!
timeout /t 3 >nul