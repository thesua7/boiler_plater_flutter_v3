# Flutter Project Generator - Curl Setup

This document provides curl-based commands to directly download and set up your Flutter project without needing to clone the repository first.

## 🚀 Quick Start

### For Linux/macOS users:

```bash
# One-liner command
curl -sSL https://raw.githubusercontent.com/yourusername/boiler_plater_flutter_v3/main/scripts/setup_flutter_project.sh | bash
```

### For Windows users (PowerShell):

```powershell
# One-liner command
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yourusername/boiler_plater_flutter_v3/main/scripts/setup_flutter_project.ps1" | Invoke-Expression
```

### For Windows users (Command Prompt):

```cmd
# Download and run PowerShell script
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/yourusername/boiler_plater_flutter_v3/main/scripts/setup_flutter_project.ps1' | Invoke-Expression"
```

## 📋 Prerequisites

- Flutter SDK installed and in PATH
- Git (for downloading)
- Internet connection

## 🔧 What These Scripts Do

1. **Download**: Downloads your boilerplate repository as a ZIP file
2. **Extract**: Extracts the project files to a temporary location
3. **Copy**: Copies all necessary files to the new project directory
4. **Customize**: Updates all project files with your new project name and package name
5. **Setup**: Runs `flutter pub get` to install dependencies
6. **Clean**: Removes temporary files and cleans up

## 🎯 Usage Examples

### Basic Usage (Interactive)
```bash
curl -sSL https://raw.githubusercontent.com/yourusername/boiler_plater_flutter_v3/main/scripts/setup_flutter_project.sh | bash
```

### Advanced Usage (Non-interactive)
```bash
# Create a script with parameters
cat > create_my_project.sh << 'EOF'
#!/bin/bash
export PROJECT_NAME="my_awesome_app"
export PACKAGE_NAME="com.mycompany"
export TARGET_DIR="/path/to/projects"
curl -sSL https://raw.githubusercontent.com/yourusername/boiler_plater_flutter_v3/main/scripts/setup_flutter_project.sh | bash
EOF

chmod +x create_my_project.sh
./create_my_project.sh
```

## 🛠️ Customization

### Environment Variables
You can set these environment variables before running the script:

```bash
export PROJECT_NAME="my_app"
export PACKAGE_NAME="com.mycompany"
export TARGET_DIR="/path/to/projects"
curl -sSL https://raw.githubusercontent.com/yourusername/boiler_plater_flutter_v3/main/scripts/setup_flutter_project.sh | bash
```

### PowerShell Parameters
For Windows PowerShell, you can pass parameters:

```powershell
# Download the script first
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yourusername/boiler_plater_flutter_v3/main/scripts/setup_flutter_project.ps1" -OutFile "setup.ps1"

# Run with parameters
.\setup.ps1 -ProjectName "my_app" -PackageName "com.mycompany" -TargetDir "C:\Projects" -SkipPrompts
```

## 🔒 Security Considerations

- The scripts download and execute code from the internet
- Make sure you trust the source repository
- Review the scripts before running them
- Consider downloading and reviewing the scripts first:

```bash
# Download and review first
curl -sSL https://raw.githubusercontent.com/yourusername/boiler_plater_flutter_v3/main/scripts/setup_flutter_project.sh -o setup_flutter_project.sh
cat setup_flutter_project.sh  # Review the script
chmod +x setup_flutter_project.sh
./setup_flutter_project.sh
```

## 🐛 Troubleshooting

### Common Issues

1. **Flutter not found**
   ```bash
   # Install Flutter first
   # Add to PATH
   export PATH="$PATH:/path/to/flutter/bin"
   ```

2. **Permission denied**
   ```bash
   # Make script executable
   chmod +x setup_flutter_project.sh
   ```

3. **Network issues**
   ```bash
   # Use wget instead of curl
   wget -O - https://raw.githubusercontent.com/yourusername/boiler_plater_flutter_v3/main/scripts/setup_flutter_project.sh | bash
   ```

4. **PowerShell execution policy**
   ```powershell
   # Set execution policy
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## 📝 Notes

- The scripts automatically exclude unnecessary files (build artifacts, git history, etc.)
- All project files are updated with your new project name and package name
- The scripts handle both Android and iOS configuration files
- MainActivity.kt is moved to the correct package structure
- Dependencies are automatically installed

## 🎉 Benefits

- **No cloning required**: Direct download and setup
- **One command**: Single command to create a new project
- **Cross-platform**: Works on Windows, macOS, and Linux
- **Automated**: No manual file editing required
- **Clean**: Only necessary files are copied
- **Customized**: All files are updated with your project details

## 🔄 Alternative Methods

If you prefer not to use curl, you can still use the traditional method:

```bash
# Traditional method
git clone https://github.com/yourusername/boiler_plater_flutter_v3.git
cd boiler_plater_flutter_v3
./scripts/create_flutter_project.bat  # Windows
# or
./scripts/setup_flutter_project.sh    # Linux/macOS
```

The curl method is faster and doesn't require git, making it more accessible to users who just want to get started quickly.
