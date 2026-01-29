@echo off
REM Windows Deployment Script for GitHub Pages

echo ========================================================
echo  Flutter Web GitHub Pages Deployment
echo ========================================================

REM 1. Ask for Repository Name to set base-href correctly
set /p REPO_NAME="Please enter your GitHub Repository Name (e.g. bible_app): "

IF "%REPO_NAME%"=="" (
    echo Error: Repository Name is required for correct routing.
    goto :ShowUsage
)

echo.
echo [1/4] Building Flutter Web App...
call flutter build web --release --base-href "/%REPO_NAME%/"

IF %ERRORLEVEL% NEQ 0 (
    echo Error: Build failed.
    exit /b %ERRORLEVEL%
)

echo.
echo [2/4] Preparing Deployment...
cd build\web

REM Initialize a temporary git repo for the build folder
git init
git add .
git commit -m "Deploy to GitHub Pages"

echo.
echo [3/4] Pushing to gh-pages branch...
echo Please enter your full repository URL (e.g. https://github.com/username/bible_app.git)
set /p REMOTE_URL="Repository URL: "

git push -f %REMOTE_URL% master:gh-pages

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [4/4] Deployment Successful!
    echo Your app should be live at: https://<username>.github.io/%REPO_NAME%/
) else (
    echo.
    echo Error: Push failed. Please check your URL and permissions.
)

REM Cleanup
cd ..\..
echo ========================================================
pause
exit /b 0

:ShowUsage
echo Please run the script again and provide the repository name.
pause
