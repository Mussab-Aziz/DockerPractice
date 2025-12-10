@echo off
REM AI Quiz Generator - Quick Start Script for Windows

echo.
echo ====================================
echo AI Quiz Generator - Quick Start
echo ====================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker is not installed or not in PATH
    echo Please install Docker Desktop: https://www.docker.com/products/docker-desktop
    exit /b 1
)

echo [✓] Docker is installed

REM Check if docker-compose is available
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker Compose is not available
    exit /b 1
)

echo [✓] Docker Compose is available
echo.

REM Menu
:menu
echo What would you like to do?
echo.
echo 1. Start development environment (docker-compose)
echo 2. Build production Docker image
echo 3. Run production container
echo 4. Open documentation
echo 5. Clean up (remove containers/images)
echo 6. Exit
echo.

set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto dev
if "%choice%"=="2" goto build-prod
if "%choice%"=="3" goto run-prod
if "%choice%"=="4" goto docs
if "%choice%"=="5" goto clean
if "%choice%"=="6" goto exit

echo Invalid choice. Please try again.
goto menu

:dev
echo.
echo Starting development environment...
echo.
docker-compose up
goto menu

:build-prod
echo.
echo Building production Docker image...
echo.
docker build -t ai-quiz-generator:latest --target production .
echo.
echo [✓] Image built successfully!
echo Run 'docker run -p 3000:3000 ai-quiz-generator:latest' to start it
echo.
goto menu

:run-prod
echo.
echo Starting production container...
echo Port: 3000
echo.
if exist .env.local (
    docker run -p 3000:3000 --env-file .env.local ai-quiz-generator:latest
) else (
    echo [WARNING] .env.local not found. Running without environment variables.
    docker run -p 3000:3000 ai-quiz-generator:latest
)
goto menu

:docs
echo.
echo Opening documentation in default browser...
start DOCKER_CICD_GUIDE.md
goto menu

:clean
echo.
echo Stopping all containers...
docker-compose down
echo Removing ai-quiz-generator images...
docker rmi ai-quiz-generator:latest 2>nul
docker rmi ai-quiz-generator:dev 2>nul
echo [✓] Cleanup complete
echo.
goto menu

:exit
echo Goodbye!
exit /b 0
