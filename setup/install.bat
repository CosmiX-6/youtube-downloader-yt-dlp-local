@echo off
setlocal enabledelayedexpansion

:: -------- Check Python --------
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Python not found. Install Python from https://www.python.org/downloads/
    pause
    exit /b
)

:: -------- Upgrade pip --------
echo Updating pip...
python -m pip install --upgrade pip

:: -------- Install yt-dlp --------
echo Installing yt-dlp...
python -m pip install -U "yt-dlp[default]"

:: -------- Install plyer --------
pip install plyer

:: -------- Set up FFmpeg --------
echo Setting up FFmpeg...
set FFMPEG_URL=https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip
set FFMPEG_ZIP=ffmpeg.zip
set FFMPEG_DIR=%USERPROFILE%\ffmpeg

mkdir "%FFMPEG_DIR%" 2>nul
cd /d "%FFMPEG_DIR%"

:: Download FFmpeg
powershell -Command "Invoke-WebRequest -Uri '%FFMPEG_URL%' -OutFile '%FFMPEG_ZIP%'"

:: Extract FFmpeg
powershell -Command "Expand-Archive -Path '%FFMPEG_ZIP%' -DestinationPath . -Force"
del "%FFMPEG_ZIP%"

:: Add to PATH permanently
for /d %%i in ("%FFMPEG_DIR%\ffmpeg-*") do set "EXTRACTED=%%i"
set "FFMPEG_BIN=!EXTRACTED!\bin"
setx PATH "!FFMPEG_BIN!;%PATH%" >nul

echo.
echo [SETUP COMPLETE] yt-dlp and FFmpeg are ready.
pause
