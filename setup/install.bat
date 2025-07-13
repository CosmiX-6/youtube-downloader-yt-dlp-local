@echo off
setlocal enabledelayedexpansion

:MENU
cls
echo ========================================
echo     yt-dlp Server Setup - Launcher
echo ========================================
echo.
echo 1. Install yt-dlp, FFmpeg, extension
echo 2. Run yt-dlp server
echo.

:: Prompt
choice /c 12 /n /m "Choose option [1-2]: "

:: Handle choice (IMPORTANT: reverse order)
if errorlevel 2 goto RUN_SERVER
if errorlevel 1 goto INSTALL

goto MENU

:INSTALL
echo.
echo ===== Installing yt-dlp ^& dependencies =====

:: Check Python
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Python is not installed. Installing Python 3.12.2...
    powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.12.2/python-3.12.2-amd64.exe' -OutFile 'python-installer.exe'; Start-Process -FilePath 'python-installer.exe' -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1 Include_test=0' -Wait; Remove-Item 'python-installer.exe'"
)

:: Upgrade pip
echo Updating pip...
python -m pip install --upgrade pip

:: Install yt-dlp
echo Installing yt-dlp...
python -m pip install -U "yt-dlp[default]"
:: -------- Add Python Scripts to PATH --------
for /f "delims=" %%i in ('where python') do set PYTHON_PATH=%%i
for %%i in ("%PYTHON_PATH%") do set PYTHON_DIR=%%~dpi
set "PY_SCRIPTS=%PYTHON_DIR%Scripts"
setx PATH "%PY_SCRIPTS%;%PATH%" >nul

:: Install plyer
echo Installing plyer...
python -m pip install plyer

:: Set up FFmpeg
echo Setting up FFmpeg...
set FFMPEG_URL=https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip
set FFMPEG_ZIP=ffmpeg.zip
set FFMPEG_DIR=%USERPROFILE%\ffmpeg

mkdir "%FFMPEG_DIR%" 2>nul
cd /d "%FFMPEG_DIR%"

:: Download and extract
powershell -Command "Invoke-WebRequest -Uri '%FFMPEG_URL%' -OutFile '%FFMPEG_ZIP%'"
powershell -Command "Expand-Archive -Path '%FFMPEG_ZIP%' -DestinationPath . -Force"
del "%FFMPEG_ZIP%"

:: Add to PATH
for /d %%i in ("%FFMPEG_DIR%\ffmpeg-*") do set "EXTRACTED=%%i"
set "FFMPEG_BIN=!EXTRACTED!\bin"
setx PATH "!FFMPEG_BIN!;%PATH%" >nul

:: Set up browser extension
echo.
echo Setting up browser extension...

:: Set URL and paths
set EXTENSION_URL=https://raw.githubusercontent.com/CosmiX-6/yt-dlp-local-downloader-interface/main/setup/extension.zip
set EXTENSION_ZIP=extension.zip
set EXTENSION_DIR=extension

:: Download the extension.zip file
powershell -NoProfile -Command "Invoke-WebRequest -Uri '%EXTENSION_URL%' -OutFile '%EXTENSION_ZIP%'"

:: Extract it
powershell -NoProfile -Command "Expand-Archive -Path '%EXTENSION_ZIP%' -DestinationPath '%EXTENSION_DIR%' -Force"

:: Clean up
del "%EXTENSION_ZIP%"

echo.
echo --------------------------------------------
echo Open Chrome and install extension manually:
echo 1. Go to chrome://extensions/
echo 2. Enable Developer Mode
echo 3. Click "Load unpacked"
echo 4. Select the 'extension' folder available in the current directory
echo --------------------------------------------
start chrome "chrome://extensions/"

echo.
echo [SETUP COMPLETE] yt-dlp, FFmpeg, and browser extension are ready.
pause
exit /b

:RUN_SERVER
echo.
echo ===== Starting yt-dlp Server =====
:: Download latest server script (optional)
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/CosmiX-6/yt-dlp-local-downloader-interface/refs/heads/main/server/yt_dlp_server.py' -OutFile yt_dlp_server.py"

:: Run it
python yt_dlp_server.py
pause
exit /b
