@echo off
:: Standalone Flutter Project Generator
:: Downloads and sets up Flutter project directly from GitHub

echo Flutter Project Generator - Standalone Version
echo =============================================
echo.

:: Check Flutter
where flutter >nul 2>&1
if errorlevel 1 (
    echo ERROR: Flutter not found
    pause
    exit /b 1
)

:: Get project details
set /p PROJECT_NAME="Enter project name: "
set /p PACKAGE_NAME="Enter package name (e.g., com.yourCompany): "
set /p TARGET_DIR="Enter target directory (or press Enter for current): "

if "%TARGET_DIR%"=="" set "TARGET_DIR=%CD%"
set "PROJECT_PATH=%TARGET_DIR%\%PROJECT_NAME%"

:: Create project directory
mkdir "%PROJECT_PATH%" 2>nul

:: Download and extract
echo Downloading boilerplate...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/thesua7/boiler_plater_flutter_v3/archive/refs/heads/master.zip' -OutFile 'boilerplate.zip'"
powershell -Command "Expand-Archive -Path 'boilerplate.zip' -DestinationPath '.' -Force"

:: Create exclude list
echo .git > exclude_list.txt
echo .idea >> exclude_list.txt
echo .dart_tool >> exclude_list.txt
echo .vscode >> exclude_list.txt
echo .fvm >> exclude_list.txt
echo .DS_Store >> exclude_list.txt
echo pubspec.lock >> exclude_list.txt
echo *.lock >> exclude_list.txt
echo build >> exclude_list.txt
echo scripts >> exclude_list.txt

:: Copy files
echo Copying files...
xcopy "boiler_plater_flutter_v3-master\*" "%PROJECT_PATH%\" /E /I /H /Y /EXCLUDE:exclude_list.txt

:: Update files
echo Updating project files...
powershell -Command "(Get-Content '%PROJECT_PATH%\pubspec.yaml') -replace 'boiler_plater_flutter_v3', '%PROJECT_NAME%' | Set-Content '%PROJECT_PATH%\pubspec.yaml'"

:: Clean up
del boilerplate.zip
del exclude_list.txt
rmdir /s /q boiler_plater_flutter_v3-master

echo.
echo Project created successfully at: %PROJECT_PATH%
echo Run: cd "%PROJECT_PATH%" ^&^& flutter pub get
pause
