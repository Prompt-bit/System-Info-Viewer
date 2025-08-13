@echo off
cls
echo Opening Dashboard
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0main.ps1"
