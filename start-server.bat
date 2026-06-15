@echo off
title Motoverse 2026 — Presentation Server
cd /d "%~dp0"

echo.
echo  =====================================================
echo   Motoverse 2026  --  RE Digital Stall Presentation
echo  =====================================================
echo.

if not exist "node_modules" (
    echo  [SETUP] node_modules not found. Installing packages...
    echo  This only happens once and may take a minute.
    echo.
    call npm install
    if errorlevel 1 (
        echo.
        echo  [ERROR] npm install failed. Make sure Node.js is installed.
        echo  Download from: https://nodejs.org/
        pause
        exit /b 1
    )
    echo.
    echo  [SETUP] Packages installed successfully.
    echo.
)

echo  Starting presentation server on port 3030...
echo.
echo  Local:    http://localhost:3030
echo  Network:  http://%COMPUTERNAME%:3030
echo.
echo  Press Ctrl+C to stop the server.
echo.

npm run host

pause
