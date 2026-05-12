@echo off
title Phase 3 - OpenCV Traffic Signal Optimizer
color 0A

echo ============================================================
echo   DYNAMIC TRAFFIC SIGNAL OPTIMIZATION  ^|  PHASE 3
echo   OpenCV MOG2 Detection  +  Greedy Scheduler (C++)
echo ============================================================
echo.

REM ── Step 1: Install OpenCV if needed ─────────────────────────
echo [1/5] Installing OpenCV (if not already installed)...
pip install opencv-python --quiet
if errorlevel 1 (
    echo WARNING: pip install failed. Make sure Python is in PATH.
)

REM ── Step 2: Compile C++ ──────────────────────────────────────
echo.
echo [2/5] Compiling main.cpp...
g++ main.cpp -o main.exe
if errorlevel 1 (
    echo [ERROR] Compilation failed! Make sure g++ is installed.
    pause
    exit /b 1
)
echo       Compiled successfully.

REM ── Step 3: Start Dashboard HTTP server ──────────────────────
echo.
echo [3/5] Starting Dashboard server (http://localhost:8080/dashboard.html)...
start "Dashboard Server" cmd /k "python serve.py"
timeout /t 2 /nobreak > nul

REM ── Step 4: Open Dashboard in browser ────────────────────────
echo [4/5] Opening dashboard in browser...
start http://localhost:8080/dashboard.html
timeout /t 1 /nobreak > nul

REM ── Step 5: Instructions + launch ────────────────────────────
echo.
echo ============================================================
echo  INSTRUCTIONS:
echo  1. In a NEW terminal, run:
echo     python detector.py --video traffic.mp4 --show --loop
echo.
echo  2. Wait ~3 seconds for detector.py to write counts.json
echo.
echo  3. Then press any key here to start the C++ simulation.
echo ============================================================
echo.
pause

main.exe
pause