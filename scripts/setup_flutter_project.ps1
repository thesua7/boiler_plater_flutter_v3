# Flutter Project Generator - PowerShell Curl Version
# This script downloads and sets up a Flutter project from the boilerplate repository
# Usage: Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yourusername/boiler_plater_flutter_v3/main/scripts/setup_flutter_project.ps1" | Invoke-Expression

param(
    [string]$ProjectName = "",
    [string]$PackageName = "",
    [string]$TargetDir = "",
    [switch]$SkipPrompts
)

# Colors for output
$Colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    Blue = "Cyan"
    White = "White"
}

# Logging functions
function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $Message" -ForegroundColor $Color
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $Colors.Red
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $Colors.Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $Colors.Yellow
}

# Function to validate project name
function Test-ProjectName {
    param([string]$Name)
    return $Name -match '^[a-z][a-z0-9_]*$'
}

# Function to validate package name
function Test-PackageName {
    param([string]$Name)
    return $Name -match '^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)+$'
}

# Function to get user input with validation
function Get-ValidatedInput {
    param(
        [string]$Prompt,
        [scriptblock]$Validator,
        [string]$ErrorMessage
    )
    
    do {
        $value = Read-Host $Prompt
        if ([string]::IsNullOrWhiteSpace($value)) {
            Write-Error "This field cannot be empty"
            continue
        }
        if (& $Validator $value) {
            return $value
        } else {
            Write-Error $ErrorMessage
        }
    } while ($true)
}

# Function to replace strings in files
function Update-FileContent {
    param(
        [string]$FilePath,
        [string]$OldValue,
        [string]$NewValue
    )
    
    if (Test-Path $FilePath) {
        try {
            $content = Get-Content $FilePath -Raw
            $content = $content -replace [regex]::Escape($OldValue), $NewValue
            Set-Content $FilePath $content -NoNewline
            return $true
        } catch {
            Write-Warning "Failed to update $FilePath`: $($_.Exception.Message)"
            return $false
        }
    }
    return $false
}

# Function to replace strings in all files recursively
function Update-AllFiles {
    param(
        [string]$Directory,
        [string]$OldValue,
        [string]$NewValue,
        [string]$FilePattern = "*.dart"
    )
    
    if (Test-Path $Directory) {
        Get-ChildItem -Path $Directory -Recurse -Include $FilePattern | ForEach-Object {
            Update-FileContent $_.FullName $OldValue $NewValue
        }
    }
}

# Main function
function Main {
    # Display header
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor $Colors.Green
    Write-Host "║                Flutter Project Generator                     ║" -ForegroundColor $Colors.Green
    Write-Host "║                  (PowerShell Version)                       ║" -ForegroundColor $Colors.Green
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor $Colors.Green
    Write-Host ""
    
    # Check if Flutter is installed
    Write-Log "Checking Flutter installation..." $Colors.Blue
    try {
        $flutterVersion = flutter --version 2>$null
        if ($LASTEXITCODE -ne 0) {
            throw "Flutter not found"
        }
        Write-Success "Flutter found!"
    } catch {
        Write-Error "Flutter is not installed or not in PATH"
        Write-Error "Please install Flutter from https://flutter.dev"
        exit 1
    }
    
    # Get project details
    if (-not $SkipPrompts) {
        Write-Log "Please provide the following information:" $Colors.Blue
        Write-Host ""
        
        if ([string]::IsNullOrWhiteSpace($ProjectName)) {
            $ProjectName = Get-ValidatedInput "Enter project name (lowercase, underscores only)" { Test-ProjectName $args[0] } "Invalid project name! Use lowercase letters, numbers, and underscores only."
        }
        
        if ($ProjectName -eq "boiler_plater_flutter_v3") {
            Write-Error "Cannot use the same name as boilerplate!"
            exit 1
        }
        
        if ([string]::IsNullOrWhiteSpace($PackageName)) {
            $PackageName = Get-ValidatedInput "Enter package name (e.g., com.yourCompany)" { Test-PackageName $args[0] } "Invalid package name! Use reverse domain notation (e.g., com.yourcompany.appname)."
        }
        
        if ([string]::IsNullOrWhiteSpace($TargetDir)) {
            $TargetDir = Read-Host "Enter target directory (or press Enter for current)"
            if ([string]::IsNullOrWhiteSpace($TargetDir)) {
                $TargetDir = Get-Location
            }
        }
    }
    
    # Validate inputs
    if (-not (Test-ProjectName $ProjectName)) {
        Write-Error "Invalid project name: $ProjectName"
        exit 1
    }
    
    if (-not (Test-PackageName $PackageName)) {
        Write-Error "Invalid package name: $PackageName"
        exit 1
    }
    
    # Automatically append project name to package name
    $FinalPackageName = "$PackageName.$ProjectName"
    Write-Success "Package name will be: $FinalPackageName"
    
    # Validate target directory
    if (-not (Test-Path $TargetDir)) {
        Write-Error "Target directory does not exist: $TargetDir"
        exit 1
    }
    
    $ProjectPath = Join-Path $TargetDir $ProjectName
    
    # Check if project already exists
    if (Test-Path $ProjectPath) {
        Write-Error "Project directory already exists: $ProjectPath"
        Write-Error "Please choose a different name or location"
        exit 1
    }
    
    Write-Host ""
    Write-Log "Creating project: $ProjectName" $Colors.Blue
    Write-Log "Location: $ProjectPath" $Colors.Blue
    Write-Host ""
    
    # Create project directory
    Write-Log "Creating project directory..." $Colors.Blue
    New-Item -ItemType Directory -Path $ProjectPath -Force | Out-Null
    Write-Success "Project directory created"
    
    # Download boilerplate from GitHub
    Write-Log "Downloading boilerplate project..." $Colors.Blue
    
    $TempDir = Join-Path $env:TEMP "flutter_boilerplate_$(Get-Random)"
    New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
    
    try {
        # Download the repository as a zip file
        $ZipUrl = "https://github.com/yourusername/boiler_plater_flutter_v3/archive/refs/heads/main.zip"
        $ZipPath = Join-Path $TempDir "boilerplate.zip"
        
        Write-Log "Downloading from: $ZipUrl" $Colors.Blue
        Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath -UseBasicParsing
        
        # Extract the zip file
        Write-Log "Extracting project files..." $Colors.Blue
        Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force
        
        # Find the extracted directory
        $ExtractedDir = Get-ChildItem -Path $TempDir -Directory | Where-Object { $_.Name -like "*boiler_plater_flutter_v3*" } | Select-Object -First 1
        
        if (-not $ExtractedDir) {
            throw "Failed to find extracted boilerplate directory"
        }
        
        # Copy files to project directory (excluding certain files/directories)
        Write-Log "Copying project files..." $Colors.Blue
        
        $ExcludeItems = @(
            ".git",
            ".idea", 
            ".dart_tool",
            ".vscode",
            ".fvm",
            ".DS_Store",
            "pubspec.lock",
            "*.lock",
            "build",
            "scripts",
            "node_modules"
        )
        
        # Copy all files except excluded ones
        Get-ChildItem -Path $ExtractedDir.FullName -Recurse | ForEach-Object {
            $relativePath = $_.FullName.Substring($ExtractedDir.FullName.Length + 1)
            $shouldExclude = $false
            
            foreach ($excludeItem in $ExcludeItems) {
                if ($relativePath -like "*$excludeItem*") {
                    $shouldExclude = $true
                    break
                }
            }
            
            if (-not $shouldExclude) {
                $destPath = Join-Path $ProjectPath $relativePath
                $destDir = Split-Path $destPath -Parent
                
                if (-not (Test-Path $destDir)) {
                    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
                }
                
                if ($_.PSIsContainer -eq $false) {
                    Copy-Item $_.FullName $destPath -Force
                }
            }
        }
        
        Write-Success "Project files copied successfully"
        
    } finally {
        # Clean up temporary directory
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    # Update project files
    Write-Log "Updating project files..." $Colors.Blue
    
    # Update pubspec.yaml
    if (Update-FileContent "$ProjectPath\pubspec.yaml" "boiler_plater_flutter_v3" $ProjectName) {
        Write-Success "Updated pubspec.yaml"
    }
    
    # Update Android files
    if (Update-FileContent "$ProjectPath\android\app\src\main\AndroidManifest.xml" "boiler_plater_flutter_v3" $ProjectName) {
        Write-Success "Updated AndroidManifest.xml"
    }
    
    if (Update-FileContent "$ProjectPath\android\app\build.gradle.kts" "com.thesua7.boiler_plater_flutter_v3" $FinalPackageName) {
        Write-Success "Updated Android build.gradle.kts"
    }
    
    # Update iOS files
    if (Update-FileContent "$ProjectPath\ios\Runner\Info.plist" "boiler_plater_flutter_v3" $ProjectName) {
        Write-Success "Updated iOS Info.plist"
    }
    
    # Update README.md
    if (Update-FileContent "$ProjectPath\README.md" "boiler_plater_flutter_v3" $ProjectName) {
        Write-Success "Updated README.md"
    }
    
    # Update Dart files
    Write-Log "Updating Dart files..." $Colors.Blue
    Update-AllFiles "$ProjectPath\lib" "package:boiler_plater_flutter_v3/" "package:$ProjectName/" "*.dart"
    Update-AllFiles "$ProjectPath\lib" "boiler_plater_flutter_v3" $ProjectName "*.dart"
    Write-Success "Updated Dart files"
    
    # Update test files
    if (Update-FileContent "$ProjectPath\test\widget_test.dart" "package:boiler_plater_flutter_v3/" "package:$ProjectName/") {
        Write-Success "Updated test files"
    }
    
    # Update MainActivity.kt package structure
    $OldMainActivityPath = "$ProjectPath\android\app\src\main\kotlin\com\thesua7\boiler_plater_flutter_v3\MainActivity.kt"
    if (Test-Path $OldMainActivityPath) {
        # Create new package directory structure
        $NewPackageDir = "$ProjectPath\android\app\src\main\kotlin\" + ($FinalPackageName -replace '\.', '\')
        New-Item -ItemType Directory -Path $NewPackageDir -Force | Out-Null
        
        # Move and update MainActivity.kt
        $NewMainActivityPath = Join-Path $NewPackageDir "MainActivity.kt"
        Copy-Item $OldMainActivityPath $NewMainActivityPath
        Update-FileContent $NewMainActivityPath "com.thesua7.boiler_plater_flutter_v3" $FinalPackageName
        
        # Remove old package directory
        Remove-Item -Path "$ProjectPath\android\app\src\main\kotlin\com" -Recurse -Force -ErrorAction SilentlyContinue
        
        Write-Success "Updated MainActivity.kt package structure"
    }
    
    # Change to project directory
    Set-Location $ProjectPath
    
    # Run Flutter commands
    Write-Log "Installing dependencies..." $Colors.Blue
    try {
        flutter pub get
        Write-Success "Dependencies installed successfully"
    } catch {
        Write-Warning "Failed to install dependencies. You may need to run 'flutter pub get' manually."
    }
    
    # Clean up
    Write-Log "Cleaning up..." $Colors.Blue
    flutter clean 2>$null | Out-Null
    
    Write-Host ""
    Write-Success "🎉 PROJECT CREATED SUCCESSFULLY! 🎉"
    Write-Host ""
    Write-Host "Project Name: $ProjectName"
    Write-Host "Package Name: $FinalPackageName"
    Write-Host "Location: $ProjectPath"
    Write-Host ""
    Write-Host "Build Variants Available:"
    Write-Host "  - Development: flutter run --flavor development"
    Write-Host "  - Staging: flutter run --flavor staging"
    Write-Host "  - Production: flutter run --flavor production"
    Write-Host ""
    Write-Host "Build Commands:"
    Write-Host "  - Development: flutter build apk --flavor development"
    Write-Host "  - Staging: flutter build apk --flavor staging"
    Write-Host "  - Production: flutter build apk --flavor production"
    Write-Host ""
    Write-Host "✅ ALL STEPS COMPLETED SUCCESSFULLY! ✅"
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "1. Open the project in your IDE"
    Write-Host "2. Run: flutter run --flavor development"
    Write-Host "3. Start building your app!"
}

# Run main function
Main
