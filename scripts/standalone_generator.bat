@echo off
:: Standalone Flutter Project Generator
:: This version includes the boilerplate files and can run independently

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
echo Flutter found!
echo.

:: Get project details
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

echo.
echo =============================================================================
echo Creating project: %PROJECT_NAME%
echo Location: %PROJECT_PATH%
echo =============================================================================
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

:: Create basic Flutter project structure
echo Progress: Creating Flutter project structure...

:: Create pubspec.yaml
echo Creating pubspec.yaml...
(
echo name: %PROJECT_NAME%
echo description: A new Flutter project.
echo publish_to: 'none'
echo.
echo version: 1.0.0+1
echo.
echo environment:
echo   sdk: '>=3.0.0 ^<4.0.0'
echo.
echo dependencies:
echo   flutter:
echo     sdk: flutter
echo   cupertino_icons: ^^1.0.2
echo.
echo dev_dependencies:
echo   flutter_test:
echo     sdk: flutter
echo   flutter_lints: ^^2.0.0
echo.
echo flutter:
echo   uses-material-design: true
) > "%PROJECT_PATH%\pubspec.yaml"

:: Create lib directory and main.dart
mkdir "%PROJECT_PATH%\lib" 2>nul
(
echo import 'package:flutter/material.dart'^;
echo.
echo void main^(^) {
echo   runApp^(const MyApp^(^)^)^;
echo }
echo.
echo class MyApp extends StatelessWidget {
echo   const MyApp^({super.key}^)^;
echo.
echo   @override
echo   Widget build^(BuildContext context^) {
echo     return MaterialApp^(
echo       title: '%PROJECT_NAME%',
echo       theme: ThemeData^(
echo         colorScheme: ColorScheme.fromSeed^(seedColor: Colors.deepPurple^)^,
echo         useMaterial3: true,
echo       ^)^,
echo       home: const MyHomePage^(title: '%PROJECT_NAME%'^)^,
echo     ^)^;
echo   }
echo }
echo.
echo class MyHomePage extends StatefulWidget {
echo   const MyHomePage^({super.key, required this.title}^)^;
echo.
echo   final String title^;
echo.
echo   @override
echo   State^<MyHomePage^> createState^(^) => _MyHomePageState^(^)^;
echo }
echo.
echo class _MyHomePageState extends State^<MyHomePage^> {
echo   int _counter = 0^;
echo.
echo   void _incrementCounter^(^) {
echo     setState^(^) {
echo       _counter++^;
echo     }
echo   }
echo.
echo   @override
echo   Widget build^(BuildContext context^) {
echo     return Scaffold^(
echo       appBar: AppBar^(
echo         backgroundColor: Theme.of^(context^).colorScheme.inversePrimary,
echo         title: Text^(widget.title^)^,
echo       ^)^,
echo       body: Center^(
echo         child: Column^(
echo           mainAxisAlignment: MainAxisAlignment.center,
echo           children: ^<Widget^>[
echo             const Text^(
echo               'You have pushed the button this many times:',
echo             ^)^,
echo             Text^(
echo               '$_counter',
echo               style: Theme.of^(context^).textTheme.headlineMedium,
echo             ^)^,
echo           ^],
echo         ^)^,
echo       ^)^,
echo       floatingActionButton: FloatingActionButton^(
echo         onPressed: _incrementCounter,
echo         tooltip: 'Increment',
echo         child: const Icon^(Icons.add^)^,
echo       ^)^,
echo     ^)^;
echo   }
echo }
) > "%PROJECT_PATH%\lib\main.dart"

:: Create test directory and widget_test.dart
mkdir "%PROJECT_PATH%\test" 2>nul
(
echo import 'package:flutter/material.dart'^;
echo import 'package:flutter_test/flutter_test.dart'^;
echo.
echo import 'package:%PROJECT_NAME%/main.dart'^;
echo.
echo void main^(^) {
echo   testWidgets^('Counter increments smoke test', ^(WidgetTester tester^) async {
echo     // Build our app and trigger a frame.
echo     await tester.pumpWidget^(const MyApp^(^)^)^;
echo.
echo     // Verify that our counter starts at 0.
echo     expect^(find.text^('0'^), findsOneWidget^)^;
echo     expect^(find.text^('1'^), findsNothing^)^;
echo.
echo     // Tap the '+' icon and trigger a frame.
echo     await tester.tap^(find.byIcon^(Icons.add^)^)^;
echo     await tester.pump^(^)^;
echo.
echo     // Verify that our counter has incremented.
echo     expect^(find.text^('0'^), findsNothing^)^;
echo     expect^(find.text^('1'^), findsOneWidget^)^;
echo   ^})^;
echo }
) > "%PROJECT_PATH%\test\widget_test.dart"

:: Create README.md
(
echo # %PROJECT_NAME%
echo.
echo A new Flutter project.
echo.
echo ## Getting Started
echo.
echo This project is a starting point for a Flutter application.
echo.
echo A few resources to get you started if this is your first Flutter project:
echo.
echo - [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab^)
echo - [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook^)
echo.
echo For help getting started with Flutter development, view the
echo [online documentation](https://docs.flutter.dev/^), which offers tutorials,
echo samples, guidance on mobile development, and a full API reference.
) > "%PROJECT_PATH%\README.md"

:: Create .gitignore
(
echo # Miscellaneous
echo *.class
echo *.log
echo *.pyc
echo *.swp
echo .DS_Store
echo .atom/
echo .buildlog/
echo .history
echo .svn/
echo mfpdebug.log
echo mfpdebugz.log
echo.
echo # IntelliJ related
echo *.iml
echo *.ipr
echo *.iws
echo .idea/
echo.
echo # The .vscode folder contains launch configuration and tasks you configure in
echo # VS Code which you may wish to be included in version control, so this line
echo # is commented out by default.
echo #.vscode/
echo.
echo # Flutter/Dart/Pub related
echo **/doc/api/
echo **/ios/Flutter/.last_build_id
echo .dart_tool/
echo .flutter-plugins
echo .flutter-plugins-dependencies
echo .packages
echo .pub-cache/
echo .pub/
echo build/
echo.
echo # Web related
echo lib/generated_plugin_registrant.dart
echo.
echo # Symbolication related
echo app.*.symbols
echo.
echo # Obfuscation related
echo app.*.map.json
echo.
echo # Android Studio will place build artifacts here
echo /android/app/debug
echo /android/app/profile
echo /android/app/release
) > "%PROJECT_PATH%\.gitignore"

:: Create analysis_options.yaml
(
echo include: package:flutter_lints/flutter.yaml
echo.
echo linter:
echo   rules:
echo     prefer_const_constructors: true
echo     prefer_const_literals_to_create_immutables: true
) > "%PROJECT_PATH%\analysis_options.yaml"

echo [OK] Basic Flutter project structure created

echo.
echo =============================================================================
echo Project created successfully!
echo =============================================================================
echo.
echo Project Name: %PROJECT_NAME%
echo Package Name: %FINAL_PACKAGE_NAME%
echo Location: %PROJECT_PATH%
echo.
echo Next steps:
echo 1. Navigate to your project: cd "%PROJECT_PATH%"
echo 2. Get dependencies: flutter pub get
echo 3. Run the app: flutter run
echo.
echo Build commands:
echo - Development: flutter run --flavor development
echo - Staging: flutter run --flavor staging
echo - Production: flutter run --flavor production
echo.
pause
