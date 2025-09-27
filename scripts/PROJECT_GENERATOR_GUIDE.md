# Flutter Project Generator Guide

This guide explains how to use the automated project generation scripts for the Flutter Boilerplate v3.

## 📋 Available Scripts

### 1. Windows Batch Script (`create_flutter_project.bat`)
- **Best for**: Windows users who prefer simple double-click execution
- **Features**: Interactive prompts, color-coded output, comprehensive error handling
- **Usage**: Double-click the file or run from command prompt

### 2. PowerShell Script (`create_flutter_project.ps1`)
- **Best for**: Advanced users, automation, CI/CD pipelines
- **Features**: Parameter support, better error handling, more flexible
- **Usage**: Run from PowerShell with optional parameters

## 🚀 Quick Start

### Method 1: Batch Script (Recommended for Windows)
1. **Double-click** `create_flutter_project.bat`
2. **Follow the prompts** to enter project details
3. **Wait for completion** and open your new project

### Method 2: PowerShell Script
```powershell
# Interactive mode
.\create_flutter_project.ps1

# With parameters (non-interactive)
.\create_flutter_project.ps1 -ProjectName "my_app" -PackageName "com.mycompany.myapp" -Description "My awesome app"
```

## 📝 Project Configuration

The scripts will prompt you for the following information:

### Required Information
- **Project Name**: 
  - Format: `my_awesome_app`
  - Rules: lowercase letters, numbers, underscores only
  - Must start with a letter
  - Example: `ecommerce_app`, `task_manager`, `social_media_app`

- **Package Name**: 
  - Format: `com.yourcompany.appname`
  - Rules: reverse domain notation
  - Example: `com.acme.ecommerce`, `com.mycompany.taskmanager`

### Optional Information
- **Description**: Brief description of your app
- **Organization**: Your company or organization name
- **Author**: Your name or team name
- **Target Directory**: Where to create the project (defaults to current directory)

## 🔧 What the Scripts Do

### 1. Validation
- ✅ Check Flutter installation
- ✅ Validate project name format
- ✅ Validate package name format
- ✅ Check target directory exists
- ✅ Handle existing project directories

### 2. Project Creation
- 📁 Create project directory
- 📋 Copy all boilerplate files
- 🧹 Remove boilerplate-specific files (like this generator)
- 🔄 Clean up Git history

### 3. Template Processing
- 📝 Update `pubspec.yaml` with new project name and description
- 🤖 Update Android configuration files
- 🍎 Update iOS configuration files
- 📱 Update all Dart files with new package name
- 📖 Update README.md with project-specific information

### 4. Flutter Setup
- 📦 Run `flutter pub get` to install dependencies
- 🌍 Run `flutter gen-l10n` to generate localizations
- 🧹 Run `flutter clean` to clean build artifacts
- 🔨 Attempt initial build to verify setup

## 🎯 Advanced Usage

### PowerShell Parameters

```powershell
# Full parameter example
.\create_flutter_project.ps1 `
    -ProjectName "my_ecommerce_app" `
    -PackageName "com.mycompany.ecommerce" `
    -Description "A modern e-commerce mobile application" `
    -Organization "My Company Ltd" `
    -Author "John Doe" `
    -TargetDir "C:\Projects" `
    -SkipPrompts

# Minimal example (will prompt for missing info)
.\create_flutter_project.ps1 -ProjectName "my_app" -PackageName "com.mycompany.myapp"
```

### Parameter Reference
- `-ProjectName`: Flutter project name
- `-PackageName`: Android package name / iOS bundle identifier
- `-Description`: Project description
- `-Organization`: Organization name
- `-Author`: Author name
- `-TargetDir`: Target directory for project creation
- `-SkipPrompts`: Skip interactive prompts (useful for automation)

## 🛠️ Troubleshooting

### Common Issues

#### 1. Flutter Not Found
```
Error: Flutter is not installed or not in PATH
```
**Solution**: 
- Install Flutter from [flutter.dev](https://flutter.dev)
- Add Flutter to your system PATH
- Restart your terminal/command prompt

#### 2. Invalid Project Name
```
Invalid project name! Use lowercase letters, numbers, and underscores only.
```
**Solution**: 
- Use only lowercase letters (a-z)
- Use numbers (0-9) and underscores (_)
- Start with a letter
- Examples: `my_app`, `task_manager_2024`, `ecommerce_app`

#### 3. Invalid Package Name
```
Invalid package name! Use reverse domain notation
```
**Solution**: 
- Use reverse domain notation
- Examples: `com.mycompany.myapp`, `org.nonprofit.app`, `io.github.username.app`

#### 4. Permission Denied
```
Error: Failed to create project directory
```
**Solution**: 
- Run as administrator
- Check target directory permissions
- Ensure target directory exists

#### 5. PowerShell Execution Policy
```
cannot be loaded because running scripts is disabled on this system
```
**Solution**: 
```powershell
# Set execution policy (run as administrator)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or run with bypass
PowerShell -ExecutionPolicy Bypass -File create_flutter_project.ps1
```

## 🔄 Customization

### Adding New Template Variables

To add new template variables that get replaced during project creation:

1. **Add to batch script**:
```batch
powershell -Command "(Get-Content '%PROJECT_PATH%\filename') -replace 'OLD_VALUE', 'NEW_VALUE' | Set-Content '%PROJECT_PATH%\filename'"
```

2. **Add to PowerShell script**:
```powershell
(Get-Content $FilePath) -replace 'OLD_VALUE', $NewValue | Set-Content $FilePath
```

### Custom File Processing

Add new file processing steps in the "FILE TEMPLATE PROCESSING" section of both scripts.

## 📁 Generated Project Structure

After running the script, you'll get a complete Flutter project with:

```
your_project_name/
├── android/                 # Android-specific files
├── ios/                     # iOS-specific files
├── lib/                     # Dart source code
│   ├── core/               # Core functionality
│   ├── features/           # Feature modules
│   ├── l10n/              # Localization files
│   └── main.dart          # App entry point
├── test/                   # Test files
├── pubspec.yaml           # Dependencies and metadata
├── README.md              # Project documentation
└── ...                    # Other Flutter files
```

## 🎉 Next Steps After Generation

1. **Open in IDE**:
   - Android Studio: File → Open → Select project folder
   - VS Code: `code your_project_name`

2. **Run the project**:
   ```bash
   flutter run --flavor development
   ```

3. **Customize**:
   - Update API endpoints in `lib/core/constants/api_constant.dart`
   - Modify app configuration in `lib/core/config/app_config.dart`
   - Add your features in `lib/features/`
   - Update app icons and splash screens

4. **Build for release**:
   ```bash
   flutter build apk --flavor production --release
   ```

## 🤝 Contributing

To improve the project generator:

1. Test with different project names and configurations
2. Add support for additional template variables
3. Improve error handling and validation
4. Add support for additional platforms (web, desktop)
5. Create additional script variants (Linux/macOS)

## 📞 Support

If you encounter issues:

1. Check the troubleshooting section above
2. Verify Flutter installation and PATH
3. Check file permissions
4. Review the error messages carefully
5. Create an issue in the repository with:
   - Operating system
   - Flutter version
   - Error message
   - Steps to reproduce

---

**Happy Project Generation! 🚀**
