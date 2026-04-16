@echo off
powershell -ExecutionPolicy Bypass -File "%~dp0..\sync_github_pkb_ado_wiki.ps1" status
pause
