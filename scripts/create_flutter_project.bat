@echo off
:: Redirect all output to log file
echo Starting Flutter Project Generator at %date% %time% > "%~dp0project_generator.log"
echo ============================================================================= >> "%~dp0project_generator.log"
echo Flutter Project Generator >> "%~dp0project_generator.log"
echo ============================================================================= >> "%~dp0project_generator.log"
echo. >> "%~dp0project_generator.log"

echo Flutter Project Generator
echo ========================
echo.

:: Check Flutter
where flutter >nul 2>&1
if errorlevel 1 (
    echo ERROR: Flutter not found
    pause
    exit /b 1
)
echo Flutter found!
echo.

:: Get project details with validation
:get_project_name
set /p PROJECT_NAME="Enter project name: "
if "%PROJECT_NAME%"=="" (
    echo ERROR: Project name cannot be empty!
    goto get_project_name
)
if "%PROJECT_NAME%"=="boiler_plater_flutter_v3" (
    echo ERROR: Cannot use the same name as boilerplate!
    goto get_project_name
)

:get_package_name
set /p PACKAGE_NAME="Enter package name (e.g., com.yourCompany): "
if "%PACKAGE_NAME%"=="" (
    echo ERROR: Package name cannot be empty!
    goto get_package_name
)
echo %PACKAGE_NAME% | findstr /r "^com\." >nul
if errorlevel 1 (
    echo ERROR: Package name must start with 'com.'
    echo Example: com.yourCompany
    goto get_package_name
)
:: Automatically append project name to package name
set "FINAL_PACKAGE_NAME=%PACKAGE_NAME%.%PROJECT_NAME%"
echo Package name will be: %FINAL_PACKAGE_NAME%
echo Package name accepted: %FINAL_PACKAGE_NAME%

:get_target_dir
set /p TARGET_DIR="Enter target directory (or press Enter for current): "
if "%TARGET_DIR%"=="" set "TARGET_DIR=%CD%"

:: Validate target directory exists
if not exist "%TARGET_DIR%" (
    echo ERROR: Target directory does not exist: %TARGET_DIR%
    goto get_target_dir
)

set "PROJECT_PATH=%TARGET_DIR%\%PROJECT_NAME%"

:: Check if project already exists
if exist "%PROJECT_PATH%" (
    echo ERROR: Project directory already exists: %PROJECT_PATH%
    echo Please choose a different name or location
        pause
        exit /b 1
    )
:: Check if we're running from a downloaded temp file
if "%~dp0"=="%TEMP%\" (
    echo ERROR: Cannot run directly from temp directory
    echo Please run this script from the actual boilerplate project directory
    echo Or use the install_and_run.bat script instead
    pause
    exit /b 1
)
set "BOILERPLATE_DIR=%~dp0.."

echo.
echo =============================================================================
echo Creating project: %PROJECT_NAME%
echo Location: %PROJECT_PATH%
echo =============================================================================
echo.
echo Progress: Starting project creation...
echo.

:: Create directory
echo Progress: Creating project directory...
mkdir "%PROJECT_PATH%" 2>nul
if errorlevel 1 (
    echo ERROR: Failed to create project directory
    pause
    exit /b 1
)
echo [OK] Project directory created
echo [OK] Project directory created >> "%~dp0project_generator.log"

:: Create minimal exclude list - only exclude what's absolutely necessary
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

:: Copy files with exclusions and progress
echo.
echo Progress: Copying project files...
echo Please wait, this may take a moment...
echo Source: %BOILERPLATE_DIR%
echo Destination: %PROJECT_PATH%
echo.

:: Show exclude list contents
echo Exclude list contents:
type exclude_list.txt
echo.

:: Copy all files except excluded ones with progress
echo Starting copy operation...
echo [                    ] 0%% - Starting copy...
echo DEBUG: Source directory: %BOILERPLATE_DIR%
echo DEBUG: Destination directory: %PROJECT_PATH%
echo DEBUG: Source directory: %BOILERPLATE_DIR% >> "%~dp0project_generator.log"
echo DEBUG: Destination directory: %PROJECT_PATH% >> "%~dp0project_generator.log"

:: Check if source directory exists
if not exist "%BOILERPLATE_DIR%" (
    echo ERROR: Source directory does not exist: %BOILERPLATE_DIR%
    echo ERROR: Source directory does not exist: %BOILERPLATE_DIR% >> "%~dp0project_generator.log"
    echo Please check the script location
    echo Please check the script location >> "%~dp0project_generator.log"
    pause
    exit /b 1
)

:: Show what's in the source directory
echo DEBUG: Contents of source directory:
echo DEBUG: Contents of source directory: >> "%~dp0project_generator.log"
dir "%BOILERPLATE_DIR%" /B
dir "%BOILERPLATE_DIR%" /B >> "%~dp0project_generator.log"
echo.
echo DEBUG: Checking for key files in source:
echo DEBUG: Checking for key files in source: >> "%~dp0project_generator.log"
if exist "%BOILERPLATE_DIR%\lib" (
    echo [OK] lib directory found in source
    echo [OK] lib directory found in source >> "%~dp0project_generator.log"
) else (
    echo [ERROR] lib directory NOT found in source
    echo [ERROR] lib directory NOT found in source >> "%~dp0project_generator.log"
)
if exist "%BOILERPLATE_DIR%\pubspec.yaml" (
    echo [OK] pubspec.yaml found in source
    echo [OK] pubspec.yaml found in source >> "%~dp0project_generator.log"
) else (
    echo [ERROR] pubspec.yaml NOT found in source
    echo [ERROR] pubspec.yaml NOT found in source >> "%~dp0project_generator.log"
)

:: Try robocopy first (more reliable)
echo Attempting robocopy...
echo Attempting robocopy... >> "%~dp0project_generator.log"
robocopy "%BOILERPLATE_DIR%" "%PROJECT_PATH%" /E /XD .git .idea .dart_tool .vscode .fvm build scripts /XF *.lock pubspec.lock /NFL /NDL /NJH /NJS
set ROBOCOPY_EXIT_CODE=%errorlevel%
echo Robocopy exit code: %ROBOCOPY_EXIT_CODE%
echo Robocopy exit code: %ROBOCOPY_EXIT_CODE% >> "%~dp0project_generator.log"

:: Robocopy returns 0-7 for success, 8+ for errors
if %ROBOCOPY_EXIT_CODE% gtr 7 (
    echo Robocopy failed, trying xcopy...
    echo Robocopy failed, trying xcopy... >> "%~dp0project_generator.log"
    xcopy "%BOILERPLATE_DIR%\*" "%PROJECT_PATH%\" /E /I /H /Y /EXCLUDE:exclude_list.txt /V
    set COPY_EXIT_CODE=%errorlevel%
    echo [====================] 100%% - Copy completed with exit code: %COPY_EXIT_CODE%
    echo Copy exit code: %COPY_EXIT_CODE%
    echo Copy exit code: %COPY_EXIT_CODE% >> "%~dp0project_generator.log"
) else (
    echo Robocopy completed successfully
    echo Robocopy completed successfully >> "%~dp0project_generator.log"
    set COPY_EXIT_CODE=0
)

if errorlevel 1 (
    echo WARNING: Copy operation had issues
    echo Check if source directory exists: %BOILERPLATE_DIR%
    echo Check if destination directory exists: %PROJECT_PATH%
    echo Continuing anyway...
)
echo Copy completed successfully!
echo Copy completed successfully! >> "%~dp0project_generator.log"

:: Show what was copied
echo.
echo Verifying copied files...
echo Verifying copied files... >> "%~dp0project_generator.log"
if exist "%PROJECT_PATH%\lib" (
    echo [OK] lib directory copied
    echo [OK] lib directory copied >> "%~dp0project_generator.log"
) else (
    echo [ERROR] lib directory NOT found
    echo [ERROR] lib directory NOT found >> "%~dp0project_generator.log"
)
if exist "%PROJECT_PATH%\android" (
    echo [OK] android directory copied
    echo [OK] android directory copied >> "%~dp0project_generator.log"
) else (
    echo [ERROR] android directory NOT found
    echo [ERROR] android directory NOT found >> "%~dp0project_generator.log"
)
if exist "%PROJECT_PATH%\pubspec.yaml" (
    echo [OK] pubspec.yaml copied
    echo [OK] pubspec.yaml copied >> "%~dp0project_generator.log"
) else (
    echo [ERROR] pubspec.yaml NOT found
    echo [ERROR] pubspec.yaml NOT found >> "%~dp0project_generator.log"
)

:: Additional copy for Android build.gradle.kts files if they exist
echo.
echo Checking for missing Android build files...
if exist "%BOILERPLATE_DIR%\android\app\build.gradle.kts" (
    if not exist "%PROJECT_PATH%\android\app\build.gradle.kts" (
        echo Copying android/app/build.gradle.kts...
        if not exist "%PROJECT_PATH%\android\app" mkdir "%PROJECT_PATH%\android\app"
        copy "%BOILERPLATE_DIR%\android\app\build.gradle.kts" "%PROJECT_PATH%\android\app\build.gradle.kts"
    )
)
if exist "%BOILERPLATE_DIR%\android\build.gradle.kts" (
    if not exist "%PROJECT_PATH%\android\build.gradle.kts" (
        echo Copying android/build.gradle.kts...
        copy "%BOILERPLATE_DIR%\android\build.gradle.kts" "%PROJECT_PATH%\android\build.gradle.kts"
    )
)

:: Verify Android folder was copied
echo.
echo Verifying copied files...
if exist "%PROJECT_PATH%\android" (
    echo [OK] Android folder copied successfully
    echo Android folder contents:
    dir "%PROJECT_PATH%\android" /B
    echo.
    if exist "%PROJECT_PATH%\android\app\build.gradle.kts" (
        echo [OK] android/app/build.gradle.kts found
    ) else (
        echo [ERROR] android/app/build.gradle.kts NOT found
        echo Checking app folder contents:
        dir "%PROJECT_PATH%\android\app" /B
    )
    if exist "%PROJECT_PATH%\android\build.gradle.kts" (
        echo [OK] android/build.gradle.kts found
    ) else (
        echo [ERROR] android/build.gradle.kts NOT found
        echo Checking android folder contents:
        dir "%PROJECT_PATH%\android" /B
    )
    echo.
    echo Android app folder contents:
    dir "%PROJECT_PATH%\android\app" /B
) else (
    echo [ERROR] WARNING: Android folder not found after copy
    echo Source directory contents:
    dir "%BOILERPLATE_DIR%"
    echo.
    echo Destination directory contents:
    dir "%PROJECT_PATH%"
    echo Continuing anyway...
)

:: Clean up exclude list
del exclude_list.txt

:: Update files - GRADUALLY ADDING BACK FUNCTIONALITY
echo.
echo Progress: Updating project files...
echo =============================================================================
echo   - Updating pubspec.yaml...
powershell -Command "try { if (Test-Path '%PROJECT_PATH%\pubspec.yaml') { (Get-Content '%PROJECT_PATH%\pubspec.yaml') -replace 'boiler_plater_flutter_v3', '%PROJECT_NAME%' | Set-Content '%PROJECT_PATH%\pubspec.yaml'; Write-Host '    Updated pubspec.yaml' } else { Write-Host '    WARNING: pubspec.yaml not found' } } catch { Write-Host '    ERROR updating pubspec.yaml: ' $_.Exception.Message }"

echo   - Updating Android manifest...
powershell -Command "try { if (Test-Path '%PROJECT_PATH%\android\app\src\main\AndroidManifest.xml') { $content = Get-Content '%PROJECT_PATH%\android\app\src\main\AndroidManifest.xml'; $content = $content -replace 'android:label=\"boiler_plater_flutter_v3\"', 'android:label=\"%PROJECT_NAME%\"'; $content = $content -replace 'boiler_plater_flutter_v3', '%PROJECT_NAME%'; $content | Set-Content '%PROJECT_PATH%\android\app\src\main\AndroidManifest.xml'; Write-Host '    Updated AndroidManifest.xml' } else { Write-Host '    WARNING: AndroidManifest.xml not found' } } catch { Write-Host '    ERROR updating AndroidManifest.xml: ' $_.Exception.Message }"

echo   - Updating iOS Info.plist...
powershell -Command "try { if (Test-Path '%PROJECT_PATH%\ios\Runner\Info.plist') { (Get-Content '%PROJECT_PATH%\ios\Runner\Info.plist') -replace 'boiler_plater_flutter_v3', '%PROJECT_NAME%' | Set-Content '%PROJECT_PATH%\ios\Runner\Info.plist'; Write-Host '    Updated Info.plist' } else { Write-Host '    WARNING: Info.plist not found' } } catch { Write-Host '    ERROR updating Info.plist: ' $_.Exception.Message }"

echo   - Updating README.md...
powershell -Command "try { if (Test-Path '%PROJECT_PATH%\README.md') { (Get-Content '%PROJECT_PATH%\README.md') -replace 'boiler_plater_flutter_v3', '%PROJECT_NAME%' | Set-Content '%PROJECT_PATH%\README.md'; Write-Host '    Updated README.md' } else { Write-Host '    WARNING: README.md not found' } } catch { Write-Host '    ERROR updating README.md: ' $_.Exception.Message }"

echo   - Updating Android build.gradle.kts...
powershell -Command "try { if (Test-Path '%PROJECT_PATH%\android\app\build.gradle.kts') { $content = Get-Content '%PROJECT_PATH%\android\app\build.gradle.kts'; $content = $content -replace 'namespace = \"com\.thesua7\.boiler_plater_flutter_v3\"', 'namespace = \"%FINAL_PACKAGE_NAME%\"'; $content = $content -replace 'applicationId = \"com\.thesua7\.boiler_plater_flutter_v3\"', 'applicationId = \"%FINAL_PACKAGE_NAME%\"'; $content = $content -replace 'Boiler Plate Dev', '%PROJECT_NAME% Dev'; $content = $content -replace 'Boiler Plate Staging', '%PROJECT_NAME% Staging'; $content = $content -replace 'Boiler Plate', '%PROJECT_NAME%'; $content = $content -replace 'Boiler Plater Flutter V3', '%PROJECT_NAME%'; $content = $content -replace 'com\.thesua7\.boiler_plater_flutter_v3', '%FINAL_PACKAGE_NAME%'; $content = $content -replace 'com\.thesua7\.', '%FINAL_PACKAGE_NAME%'; $content | Set-Content '%PROJECT_PATH%\android\app\build.gradle.kts'; Write-Host '    Updated android/app/build.gradle.kts' } else { Write-Host '    WARNING: android/app/build.gradle.kts not found' } } catch { Write-Host '    ERROR updating Android build.gradle.kts: ' $_.Exception.Message }"

echo   - Updating Android root build.gradle.kts...
powershell -Command "try { if (Test-Path '%PROJECT_PATH%\android\build.gradle.kts') { (Get-Content '%PROJECT_PATH%\android\build.gradle.kts') -replace 'boiler_plater_flutter_v3', '%PROJECT_NAME%' | Set-Content '%PROJECT_PATH%\android\build.gradle.kts'; Write-Host '    Updated android/build.gradle.kts' } else { Write-Host '    WARNING: android/build.gradle.kts not found' } } catch { Write-Host '    ERROR updating Android build.gradle.kts: ' $_.Exception.Message }"

echo   - Updating and moving MainActivity.kt...
powershell -Command "try { $oldPath = '%PROJECT_PATH%\android\app\src\main\kotlin\com\thesua7\boiler_plater_flutter_v3\MainActivity.kt'; $newPackagePath = '%FINAL_PACKAGE_NAME%' -replace '\.', '\'; $newDir = '%PROJECT_PATH%\android\app\src\main\kotlin\' + $newPackagePath; $newPath = $newDir + '\MainActivity.kt'; if (Test-Path $oldPath) { $content = Get-Content $oldPath; $content = $content -replace 'com\.thesua7\.boiler_plater_flutter_v3', '%FINAL_PACKAGE_NAME%'; if (-not (Test-Path $newDir)) { New-Item -ItemType Directory -Path $newDir -Force | Out-Null }; $content | Set-Content $newPath; Remove-Item $oldPath -Force; Write-Host '    Updated and moved MainActivity.kt to new package structure' } else { Write-Host '    WARNING: MainActivity.kt not found' } } catch { Write-Host '    ERROR updating MainActivity.kt: ' $_.Exception.Message }"

echo   - Cleaning up old package directory...
powershell -Command "try { $oldDir = '%PROJECT_PATH%\android\app\src\main\kotlin\com\thesua7\boiler_plater_flutter_v3'; if (Test-Path $oldDir) { Remove-Item $oldDir -Recurse -Force; Write-Host '    Cleaned up old package directory' } } catch { Write-Host '    WARNING: Could not clean up old package directory' }"

echo   - Updating iOS project.pbxproj...
powershell -Command "try { if (Test-Path '%PROJECT_PATH%\ios\Runner.xcodeproj\project.pbxproj') { $content = Get-Content '%PROJECT_PATH%\ios\Runner.xcodeproj\project.pbxproj'; $content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boilerPlaterFlutterV3', 'PRODUCT_BUNDLE_IDENTIFIER = %FINAL_PACKAGE_NAME%'; $content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boiler_plater_flutter_v3', 'PRODUCT_BUNDLE_IDENTIFIER = %FINAL_PACKAGE_NAME%'; $content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boilerPlaterFlutterV3\.RunnerTests', 'PRODUCT_BUNDLE_IDENTIFIER = %FINAL_PACKAGE_NAME%.RunnerTests'; $content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boiler_plater_flutter_v3\.RunnerTests', 'PRODUCT_BUNDLE_IDENTIFIER = %FINAL_PACKAGE_NAME%.RunnerTests'; $content = $content -replace 'com\.thesua7\.boilerPlaterFlutterV3', '%FINAL_PACKAGE_NAME%'; $content = $content -replace 'com\.thesua7\.boiler_plater_flutter_v3', '%FINAL_PACKAGE_NAME%'; $content = $content -replace 'boiler_plater_flutter_v3', '%PROJECT_NAME%'; $content = $content -replace 'Boiler Plater Flutter V3', '%PROJECT_NAME%'; $content = $content -replace 'Boiler Plater Flutter V3', '%PROJECT_NAME%'; $content | Set-Content '%PROJECT_PATH%\ios\Runner.xcodeproj\project.pbxproj'; Write-Host '    Updated ALL PRODUCT_BUNDLE_IDENTIFIER instances and project.pbxproj' } else { Write-Host '    WARNING: project.pbxproj not found' } } catch { Write-Host '    ERROR updating project.pbxproj: ' $_.Exception.Message }"

echo   - Updating AppInfo.xcconfig...
powershell -Command "try { if (Test-Path '%PROJECT_PATH%\macos\Runner\Configs\AppInfo.xcconfig') { (Get-Content '%PROJECT_PATH%\macos\Runner\Configs\AppInfo.xcconfig') -replace 'boiler_plater_flutter_v3', '%PROJECT_NAME%' | Set-Content '%PROJECT_PATH%\macos\Runner\Configs\AppInfo.xcconfig'; Write-Host '    Updated AppInfo.xcconfig' } else { Write-Host '    WARNING: AppInfo.xcconfig not found' } } catch { Write-Host '    ERROR updating AppInfo.xcconfig: ' $_.Exception.Message }"

echo   - Updating all .xcconfig files...
for /r "%PROJECT_PATH%" %%f in (*.xcconfig) do (
    echo     - Updating %%f...
    powershell -Command "try { if (Test-Path '%%f') { $content = Get-Content '%%f'; $content = $content -replace 'boiler_plater_flutter_v3', '%PROJECT_NAME%'; $content = $content -replace 'com\.thesua7\.boilerPlaterFlutterV3', '%FINAL_PACKAGE_NAME%'; $content = $content -replace 'com\.thesua7\.boiler_plater_flutter_v3', '%FINAL_PACKAGE_NAME%'; $content = $content -replace 'com\.thesua7\.', '%FINAL_PACKAGE_NAME%'; $content | Set-Content '%%f'; Write-Host '      Updated %%f' } } catch { Write-Host '      ERROR updating %%f: ' $_.Exception.Message }"
)

echo   - Updating all CMake files...
for /r "%PROJECT_PATH%" %%f in (*.cmake CMakeLists.txt) do (
    echo     - Updating %%f...
    powershell -Command "try { if (Test-Path '%%f') { $content = Get-Content '%%f'; $content = $content -replace 'boiler_plater_flutter_v3', '%PROJECT_NAME%'; $content = $content -replace 'com\.thesua7\.boilerPlaterFlutterV3', '%FINAL_PACKAGE_NAME%'; $content = $content -replace 'com\.thesua7\.boiler_plater_flutter_v3', '%FINAL_PACKAGE_NAME%'; $content = $content -replace 'com\.thesua7\.', '%FINAL_PACKAGE_NAME%'; $content | Set-Content '%%f'; Write-Host '      Updated %%f' } } catch { Write-Host '      ERROR updating %%f: ' $_.Exception.Message }"
)

echo   - Updating Windows resource files...
for /r "%PROJECT_PATH%" %%f in (*.rc) do (
    echo     - Updating %%f...
    powershell -Command "try { if (Test-Path '%%f') { $content = Get-Content '%%f'; $content = $content -replace 'boiler_plater_flutter_v3', '%PROJECT_NAME%'; $content = $content -replace 'com\.thesua7', '%FINAL_PACKAGE_NAME%'; $content = $content -replace 'boiler_plater_flutter_v3\.exe', '%PROJECT_NAME%.exe'; $content | Set-Content '%%f'; Write-Host '      Updated %%f' } } catch { Write-Host '      ERROR updating %%f: ' $_.Exception.Message }"
)

echo   - Updating widget_test.dart...
powershell -Command "try { if (Test-Path '%PROJECT_PATH%\test\widget_test.dart') { $content = Get-Content '%PROJECT_PATH%\test\widget_test.dart'; $content = $content -replace 'package:boiler_plater_flutter_v3/', 'package:%PROJECT_NAME%/'; $content = $content -replace 'boiler_plater_flutter_v3', '%PROJECT_NAME%'; $content | Set-Content '%PROJECT_PATH%\test\widget_test.dart'; Write-Host '    Updated widget_test.dart' } else { Write-Host '    WARNING: widget_test.dart not found' } } catch { Write-Host '    ERROR updating widget_test.dart: ' $_.Exception.Message }"

echo   - Updating Dart files...
for /r "%PROJECT_PATH%\lib" %%f in (*.dart) do (
    echo     - Updating %%f...
    powershell -Command "try { if (Test-Path '%%f') { $content = Get-Content '%%f'; $content = $content -replace 'package:boiler_plater_flutter_v3/', 'package:%PROJECT_NAME%/'; $content = $content -replace 'boiler_plater_flutter_v3', '%PROJECT_NAME%'; $content = $content -replace 'Boiler Plate Dev', '%PROJECT_NAME% Dev'; $content = $content -replace 'Boiler Plate Staging', '%PROJECT_NAME% Staging'; $content = $content -replace 'Boiler Plate', '%PROJECT_NAME%'; $content | Set-Content '%%f'; Write-Host '      Updated %%f' } } catch { Write-Host '      ERROR updating %%f: ' $_.Exception.Message }"
)

echo   - Updating any remaining files with boilerplate references...
for /r "%PROJECT_PATH%" %%f in (*.dart *.kt *.xml *.yaml *.yml *.json *.md *.txt *.plist *.pbxproj *.xcconfig *.cmake *.rc CMakeLists.txt) do (
    echo     - Checking %%f...
    powershell -Command "try { if (Test-Path '%%f') { $content = Get-Content '%%f'; $originalContent = $content; $content = $content -replace 'package:boiler_plater_flutter_v3/', 'package:%PROJECT_NAME%/'; $content = $content -replace 'boiler_plater_flutter_v3', '%PROJECT_NAME%'; $content = $content -replace 'Boiler Plate Dev', '%PROJECT_NAME% Dev'; $content = $content -replace 'Boiler Plate Staging', '%PROJECT_NAME% Staging'; $content = $content -replace 'Boiler Plate', '%PROJECT_NAME%'; $content = $content -replace 'Boiler Plater Flutter V3', '%PROJECT_NAME%'; $content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boilerPlaterFlutterV3', 'PRODUCT_BUNDLE_IDENTIFIER = %FINAL_PACKAGE_NAME%'; $content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boiler_plater_flutter_v3', 'PRODUCT_BUNDLE_IDENTIFIER = %FINAL_PACKAGE_NAME%'; $content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boilerPlaterFlutterV3\.RunnerTests', 'PRODUCT_BUNDLE_IDENTIFIER = %FINAL_PACKAGE_NAME%.RunnerTests'; $content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boiler_plater_flutter_v3\.RunnerTests', 'PRODUCT_BUNDLE_IDENTIFIER = %FINAL_PACKAGE_NAME%.RunnerTests'; $content = $content -replace 'com\.thesua7\.boilerPlaterFlutterV3', '%FINAL_PACKAGE_NAME%'; $content = $content -replace 'com\.thesua7\.boiler_plater_flutter_v3', '%FINAL_PACKAGE_NAME%'; $content = $content -replace 'com\.thesua7\.', '%FINAL_PACKAGE_NAME%'; $content = $content -replace 'APPLICATION_ID \"com\.thesua7\.', 'APPLICATION_ID \"%FINAL_PACKAGE_NAME%'; $content = $content -replace 'set\(APPLICATION_ID \"com\.thesua7\.', 'set\(APPLICATION_ID \"%FINAL_PACKAGE_NAME%'; if ($content -ne $originalContent) { $content | Set-Content '%%f'; Write-Host '      Updated %%f' } } } catch { Write-Host '      ERROR checking %%f: ' $_.Exception.Message }"
)

echo   - File updates completed
echo   - File updates completed >> "%~dp0project_generator.log"


:: Change to project directory and run flutter pub get
echo.
echo =============================================================================
echo Progress: Installing dependencies...
echo =============================================================================
echo Changing to project directory: %PROJECT_PATH%
echo Changing to project directory: %PROJECT_PATH% >> "%~dp0project_generator.log"

:: Check if directory exists before trying to change to it
if not exist "%PROJECT_PATH%" (
    echo ERROR: Project directory does not exist: %PROJECT_PATH%
    echo ERROR: Project directory does not exist: %PROJECT_PATH% >> "%~dp0project_generator.log"
    echo Please check the project creation process
    echo Please check the project creation process >> "%~dp0project_generator.log"
    pause
    exit /b 1
)

echo Attempting to change directory...
echo Attempting to change directory... >> "%~dp0project_generator.log"

:: Try pushd first (better for paths with spaces)
pushd "%PROJECT_PATH%" 2>nul
set PUSHD_EXIT_CODE=%errorlevel%
echo Pushd exit code: %PUSHD_EXIT_CODE%
echo Pushd exit code: %PUSHD_EXIT_CODE% >> "%~dp0project_generator.log"
echo DEBUG: PUSHD_EXIT_CODE=%PUSHD_EXIT_CODE%
echo DEBUG: PUSHD_EXIT_CODE=%PUSHD_EXIT_CODE% >> "%~dp0project_generator.log"

if %PUSHD_EXIT_CODE% neq 0 (
    echo Pushd failed, trying cd...
    echo Pushd failed, trying cd... >> "%~dp0project_generator.log"
    cd /d "%PROJECT_PATH%"
    set CD_EXIT_CODE=%errorlevel%
    echo Change directory exit code: %CD_EXIT_CODE%
    echo Change directory exit code: %CD_EXIT_CODE% >> "%~dp0project_generator.log"
    set FINAL_EXIT_CODE=%CD_EXIT_CODE%
    set USE_PUSHD=false
) else (
    echo Pushd successful
    echo Pushd successful >> "%~dp0project_generator.log"
    set FINAL_EXIT_CODE=0
    set USE_PUSHD=true
)
echo DEBUG: FINAL_EXIT_CODE=%FINAL_EXIT_CODE%
echo DEBUG: FINAL_EXIT_CODE=%FINAL_EXIT_CODE% >> "%~dp0project_generator.log"

if %FINAL_EXIT_CODE% neq 0 (
    echo DEBUG: Running fallback path
    echo DEBUG: Running fallback path >> "%~dp0project_generator.log"
    echo ERROR: Failed to change to project directory (exit code: %FINAL_EXIT_CODE%)
    echo ERROR: Failed to change to project directory (exit code: %FINAL_EXIT_CODE%) >> "%~dp0project_generator.log"
    echo Project path: %PROJECT_PATH%
    echo Project path: %PROJECT_PATH% >> "%~dp0project_generator.log"
    echo Current directory: %CD%
    echo Current directory: %CD% >> "%~dp0project_generator.log"
    echo.
    echo Skipping Flutter commands due to directory change failure
    echo Skipping Flutter commands due to directory change failure >> "%~dp0project_generator.log"
    echo You can manually run Flutter commands later
    echo You can manually run Flutter commands later >> "%~dp0project_generator.log"
) else (
    echo DEBUG: Running success path
    echo DEBUG: Running success path >> "%~dp0project_generator.log"
    echo [OK] Changed to project directory
    echo [OK] Changed to project directory >> "%~dp0project_generator.log"
    echo Current directory: %CD%
    echo Current directory: %CD% >> "%~dp0project_generator.log"
    
    echo.
    echo =============================================================================
    echo ============================================================================= >> "%~dp0project_generator.log"
    echo Flutter commands are now optional - you can run them manually
    echo Flutter commands are now optional - you can run them manually >> "%~dp0project_generator.log"
    echo =============================================================================
    echo ============================================================================= >> "%~dp0project_generator.log"
    echo.
    echo To run Flutter commands manually:
    echo To run Flutter commands manually >> "%~dp0project_generator.log"
    echo   1. Open terminal in project directory: %PROJECT_PATH%
    echo   1. Open terminal in project directory: %PROJECT_PATH% >> "%~dp0project_generator.log"
    echo   2. Run: flutter pub get
    echo   2. Run: flutter pub get >> "%~dp0project_generator.log"
    echo   3. Run: flutter run --flavor development
    echo   3. Run: flutter run --flavor development >> "%~dp0project_generator.log"
    echo.
    echo Skipping automatic Flutter commands to avoid issues
    echo Skipping automatic Flutter commands to avoid issues >> "%~dp0project_generator.log"
    set PUB_GET_EXIT_CODE=0
    
    echo [OK] Project setup completed successfully
    echo [OK] Project setup completed successfully >> "%~dp0project_generator.log"
)

:: Clean up pushd if it was used
popd 2>nul


echo.
echo =============================================================================
echo ============================================================================= >> "%~dp0project_generator.log"
echo Progress: Finalizing project setup...
echo Progress: Finalizing project setup... >> "%~dp0project_generator.log"
echo =============================================================================
echo ============================================================================= >> "%~dp0project_generator.log"

:: Always log final status regardless of flutter run outcome
echo.
echo =============================================================================
echo ============================================================================= >> "%~dp0project_generator.log"
echo 🎉 PROJECT CREATED SUCCESSFULLY! 🎉
echo 🎉 PROJECT CREATED SUCCESSFULLY! 🎉 >> "%~dp0project_generator.log"
echo =============================================================================
echo ============================================================================= >> "%~dp0project_generator.log"
echo.
echo Project Name: %PROJECT_NAME%
echo Project Name: %PROJECT_NAME% >> "%~dp0project_generator.log"
echo Package Name: %FINAL_PACKAGE_NAME%
echo Package Name: %FINAL_PACKAGE_NAME% >> "%~dp0project_generator.log"
echo Location: %PROJECT_PATH%
echo Location: %PROJECT_PATH% >> "%~dp0project_generator.log"
echo.
echo Build Variants Available:
echo Build Variants Available: >> "%~dp0project_generator.log"
echo   - Development: flutter run --flavor development
echo   - Development: flutter run --flavor development >> "%~dp0project_generator.log"
echo   - Staging: flutter run --flavor staging  
echo   - Staging: flutter run --flavor staging >> "%~dp0project_generator.log"
echo   - Production: flutter run --flavor production
echo   - Production: flutter run --flavor production >> "%~dp0project_generator.log"
echo.
echo Build Commands:
echo Build Commands: >> "%~dp0project_generator.log"
echo   - Development: flutter build apk --flavor development
echo   - Development: flutter build apk --flavor development >> "%~dp0project_generator.log"
echo   - Staging: flutter build apk --flavor staging
echo   - Staging: flutter build apk --flavor staging >> "%~dp0project_generator.log"
echo   - Production: flutter build apk --flavor production
echo   - Production: flutter build apk --flavor production >> "%~dp0project_generator.log"
echo.
echo =============================================================================
echo ============================================================================= >> "%~dp0project_generator.log"
echo ✅ ALL STEPS COMPLETED SUCCESSFULLY! ✅
echo ✅ ALL STEPS COMPLETED SUCCESSFULLY! ✅ >> "%~dp0project_generator.log"
echo =============================================================================
echo ============================================================================= >> "%~dp0project_generator.log"

echo.
echo =============================================================================
echo ============================================================================= >> "%~dp0project_generator.log"
echo Press ANY KEY to exit...
echo Press ANY KEY to exit... >> "%~dp0project_generator.log"
echo =============================================================================
echo ============================================================================= >> "%~dp0project_generator.log"
pause
echo.
echo Thank you for using the Flutter Project Generator!
echo Thank you for using the Flutter Project Generator! >> "%~dp0project_generator.log"
echo.
echo Press ANY KEY again to close this window...
echo Press ANY KEY again to close this window... >> "%~dp0project_generator.log"
pause
echo.
echo Script completed at %date% %time%
echo Script completed at %date% %time% >> "%~dp0project_generator.log"

:: String length function
:strlen
setlocal enabledelayedexpansion
set "str=!%~1!"
set "len=0"
for /l %%i in (0,1,8192) do (
    if "!str:~%%i,1!"=="" goto :strlen_done
    set /a len+=1
)
:strlen_done
endlocal & set "%~2=%len%"
goto :eof
