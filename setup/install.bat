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
    echo [ERROR] Python not found. Install from https://www.python.org/downloads/
    pause
    exit /b
)

:: Upgrade pip
echo Updating pip...
python -m pip install --upgrade pip

:: Install yt-dlp
echo Installing yt-dlp...
python -m pip install -U "yt-dlp[default]"

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
powershell -Command "Expand-Archive -Path extension.zip -DestinationPath extension -Force"

echo.
echo --------------------------------------------
echo Open Chrome and install extension manually:
echo 1. Go to chrome://extensions/
echo 2. Enable Developer Mode
echo 3. Click "Load unpacked"
echo 4. Select the 'extension' folder
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
