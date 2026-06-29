@echo off
setlocal enabledelayedexpansion

rem Build Real-ESRGAN GUI as a Windows executable.
rem Run this from the repository root.

if not exist "python.exe" (
  where python >nul 2>nul
  if errorlevel 1 (
    echo ERROR: Python was not found on PATH.
    exit /b 1
  )
)

if not exist ".venv\Scripts\activate.bat" (
  echo INFO: Creating virtual environment...
  python -m venv .venv
  if errorlevel 1 exit /b 1
)

echo INFO: Activating virtual environment...
call .venv\Scripts\activate.bat
if errorlevel 1 exit /b 1

echo INFO: Checking Tkinter availability...
python -c "import tkinter" >nul 2>nul
if errorlevel 1 (
  echo ERROR: tkinter is not available in this Python installation.
  echo ERROR: Install the standard Python distribution for Windows, then rerun this script.
  echo ERROR: The Microsoft Store / embeddable Python builds may not include Tcl/Tk.
  exit /b 1
)

echo INFO: Upgrading pip...
python -m pip install --upgrade pip
if errorlevel 1 exit /b 1

echo INFO: Installing project dependencies...
pip install -r requirements.txt
if errorlevel 1 exit /b 1

echo INFO: Installing PyInstaller...
pip install pyinstaller==6.*
if errorlevel 1 exit /b 1

rem Build a single-file executable on Windows.
set REGUI_ONEFILE=1

echo INFO: Building executable...
pyinstaller --clean --log-level WARN realesrgan-gui.spec
if errorlevel 1 exit /b 1

echo INFO: Build complete. Output is in the dist folder.
endlocal
