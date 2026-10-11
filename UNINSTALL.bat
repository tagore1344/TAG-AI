@echo off
title Tag AI - UNINSTALL
color 0C
echo.
echo  Removing Tag AI from Windows Startup...
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "Tag AI" /f >nul 2>&1
del /f .installed >nul 2>&1
echo  Done! Tag AI will no longer auto-start.
echo  Your files are untouched - delete this folder to fully remove.
pause