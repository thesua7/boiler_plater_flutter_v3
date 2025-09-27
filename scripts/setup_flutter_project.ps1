# Flutter Project Generator - PowerShell Curl Version
# This script downloads and sets up a Flutter project from the boilerplate repository
# Usage: Invoke-WebRequest -Uri "https://raw.githubusercontent.com/thesua7/boiler_plater_flutter_v3/master/scripts/setup_flutter_project.ps1" | Invoke-Expression

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
            Update-FileContent $_.FullName $OldValue $NewValue | Out-Null
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
        $ZipUrl = "https://github.com/thesua7/boiler_plater_flutter_v3/archive/refs/heads/master.zip"
        $ZipPath = Join-Path $TempDir "boilerplate.zip"
        
        Write-Log "Downloading from: $ZipUrl" $Colors.Blue
        Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath -UseBasicParsing
        
        # Extract the zip file
        Write-Log "Extracting project files..." $Colors.Blue
        Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force
        
        # Find the extracted directory
        $ExtractedDir = Get-ChildItem -Path $TempDir -Directory | Where-Object { $_.Name -like "*boiler_plater_flutter_v3-master*" } | Select-Object -First 1
        
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
        
        # Use xcopy directly (more reliable for paths with spaces)
        Write-Log "Using xcopy for reliable file copying..." $Colors.Blue
        
        # Create exclude list file (like your working script)
        $excludeListPath = Join-Path $TempDir "exclude_list.txt"
        $excludeListContent = @"
.git
.idea
.dart_tool
.vscode
.fvm
.DS_Store
pubspec.lock
*.lock
build
scripts
"@
        Set-Content -Path $excludeListPath -Value $excludeListContent
        
        # Use xcopy with exclude list (like your working script)
        $xcopyCmd = "xcopy `"$($ExtractedDir.FullName)\*`" `"$ProjectPath\`" /E /I /H /Y /EXCLUDE:`"$excludeListPath`""
        Write-Log "Xcopy command: $xcopyCmd" $Colors.Blue
        
        $xcopyResult = cmd /c $xcopyCmd
        $xcopyExitCode = $LASTEXITCODE
        Write-Log "Xcopy exit code: $xcopyExitCode" $Colors.Blue
        
        if ($xcopyExitCode -ne 0) {
            Write-Warning "Xcopy failed, trying robocopy fallback..."
            # Fallback to robocopy
            $robocopyCmd = "robocopy `"$($ExtractedDir.FullName)`" `"$ProjectPath`" /E /XD .git .idea .dart_tool .vscode .fvm build scripts /XF *.lock pubspec.lock /NFL /NDL /NJH /NJS"
            Write-Log "Robocopy command: $robocopyCmd" $Colors.Blue
            cmd /c $robocopyCmd
            $robocopyExitCode = $LASTEXITCODE
            Write-Log "Robocopy exit code: $robocopyExitCode" $Colors.Blue
            
            if ($robocopyExitCode -gt 7) {
                Write-Warning "Robocopy also failed, trying PowerShell copy..."
                # Final fallback to PowerShell copy
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
            }
        } else {
            Write-Log "Xcopy completed successfully" $Colors.Blue
        }
        
        # Clean up exclude list
        Remove-Item $excludeListPath -Force -ErrorAction SilentlyContinue
        
        Write-Success "Project files copied successfully"
        
        # Verify key files were copied (like your working script)
        Write-Log "Verifying copied files..." $Colors.Blue
        if (Test-Path "$ProjectPath\lib") {
            Write-Success "    [OK] lib directory copied"
        } else {
            Write-Warning "    [ERROR] lib directory NOT found"
        }
        if (Test-Path "$ProjectPath\android") {
            Write-Success "    [OK] android directory copied"
        } else {
            Write-Warning "    [ERROR] android directory NOT found"
        }
        if (Test-Path "$ProjectPath\pubspec.yaml") {
            Write-Success "    [OK] pubspec.yaml copied"
        } else {
            Write-Warning "    [ERROR] pubspec.yaml NOT found"
        }
        if (Test-Path "$ProjectPath\android\app\build.gradle.kts") {
            Write-Success "    [OK] android/app/build.gradle.kts found"
        } else {
            Write-Warning "    [ERROR] android/app/build.gradle.kts NOT found"
        }
        if (Test-Path "$ProjectPath\android\build.gradle.kts") {
            Write-Success "    [OK] android/build.gradle.kts found"
        } else {
            Write-Warning "    [ERROR] android/build.gradle.kts NOT found"
        }
        
    } finally {
        # Clean up temporary directory
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    # Update project files - COMPREHENSIVE UPDATES (matching working batch script)
    Write-Log "Updating project files..." $Colors.Blue
    Write-Log "=============================================================================" $Colors.Blue
    
    # Update pubspec.yaml
    Write-Log "  - Updating pubspec.yaml..." $Colors.Blue
    if (Test-Path "$ProjectPath\pubspec.yaml") {
        $content = Get-Content "$ProjectPath\pubspec.yaml" -Raw
        $content = $content -replace "boiler_plater_flutter_v3", $ProjectName
        Set-Content "$ProjectPath\pubspec.yaml" $content -NoNewline
        Write-Success "    Updated pubspec.yaml"
    } else {
        Write-Warning "    WARNING: pubspec.yaml not found"
    }
    
    # Update Android manifest
    Write-Log "  - Updating Android manifest..." $Colors.Blue
    if (Test-Path "$ProjectPath\android\app\src\main\AndroidManifest.xml") {
        $content = Get-Content "$ProjectPath\android\app\src\main\AndroidManifest.xml" -Raw
        $content = $content -replace 'android:label="boiler_plater_flutter_v3"', "android:label=`"$ProjectName`""
        $content = $content -replace "boiler_plater_flutter_v3", $ProjectName
        Set-Content "$ProjectPath\android\app\src\main\AndroidManifest.xml" $content -NoNewline
        Write-Success "    Updated AndroidManifest.xml"
    } else {
        Write-Warning "    WARNING: AndroidManifest.xml not found"
    }
    
    # Update iOS Info.plist
    Write-Log "  - Updating iOS Info.plist..." $Colors.Blue
    if (Test-Path "$ProjectPath\ios\Runner\Info.plist") {
        $content = Get-Content "$ProjectPath\ios\Runner\Info.plist" -Raw
        $content = $content -replace "boiler_plater_flutter_v3", $ProjectName
        Set-Content "$ProjectPath\ios\Runner\Info.plist" $content -NoNewline
        Write-Success "    Updated Info.plist"
    } else {
        Write-Warning "    WARNING: Info.plist not found"
    }
    
    # Update README.md
    Write-Log "  - Updating README.md..." $Colors.Blue
    if (Test-Path "$ProjectPath\README.md") {
        $content = Get-Content "$ProjectPath\README.md" -Raw
        $content = $content -replace "boiler_plater_flutter_v3", $ProjectName
        Set-Content "$ProjectPath\README.md" $content -NoNewline
        Write-Success "    Updated README.md"
    } else {
        Write-Warning "    WARNING: README.md not found"
    }
    
    # Update Android build.gradle.kts (comprehensive)
    Write-Log "  - Updating Android build.gradle.kts..." $Colors.Blue
    if (Test-Path "$ProjectPath\android\app\build.gradle.kts") {
        $content = Get-Content "$ProjectPath\android\app\build.gradle.kts" -Raw
        $content = $content -replace 'namespace = "com\.thesua7\.boiler_plater_flutter_v3"', "namespace = `"$FinalPackageName`""
        $content = $content -replace 'applicationId = "com\.thesua7\.boiler_plater_flutter_v3"', "applicationId = `"$FinalPackageName`""
        $content = $content -replace "Boiler Plate Dev", "$ProjectName Dev"
        $content = $content -replace "Boiler Plate Staging", "$ProjectName Staging"
        $content = $content -replace "Boiler Plate", $ProjectName
        $content = $content -replace "Boiler Plater Flutter V3", $ProjectName
        $content = $content -replace "com\.thesua7\.boiler_plater_flutter_v3", $FinalPackageName
        $content = $content -replace "com\.thesua7\.", $FinalPackageName
        Set-Content "$ProjectPath\android\app\build.gradle.kts" $content -NoNewline
        Write-Success "    Updated android/app/build.gradle.kts"
    } else {
        Write-Warning "    WARNING: android/app/build.gradle.kts not found"
    }
    
    # Update Android root build.gradle.kts
    Write-Log "  - Updating Android root build.gradle.kts..." $Colors.Blue
    if (Test-Path "$ProjectPath\android\build.gradle.kts") {
        $content = Get-Content "$ProjectPath\android\build.gradle.kts" -Raw
        $content = $content -replace "boiler_plater_flutter_v3", $ProjectName
        Set-Content "$ProjectPath\android\build.gradle.kts" $content -NoNewline
        Write-Success "    Updated android/build.gradle.kts"
    } else {
        Write-Warning "    WARNING: android/build.gradle.kts not found"
    }
    
    # Update and move MainActivity.kt
    Write-Log "  - Updating and moving MainActivity.kt..." $Colors.Blue
    $oldPath = "$ProjectPath\android\app\src\main\kotlin\com\thesua7\boiler_plater_flutter_v3\MainActivity.kt"
    $newPackagePath = $FinalPackageName -replace '\.', '\'
    $newDir = "$ProjectPath\android\app\src\main\kotlin\$newPackagePath"
    $newPath = "$newDir\MainActivity.kt"
    
    if (Test-Path $oldPath) {
        $content = Get-Content $oldPath -Raw
        $content = $content -replace "com\.thesua7\.boiler_plater_flutter_v3", $FinalPackageName
        if (-not (Test-Path $newDir)) {
            New-Item -ItemType Directory -Path $newDir -Force | Out-Null
        }
        Set-Content $newPath $content -NoNewline
        Remove-Item $oldPath -Force
        Write-Success "    Updated and moved MainActivity.kt to new package structure"
    } else {
        Write-Warning "    WARNING: MainActivity.kt not found"
    }
    
    # Clean up old package directory
    Write-Log "  - Cleaning up old package directory..." $Colors.Blue
    $oldDir = "$ProjectPath\android\app\src\main\kotlin\com\thesua7\boiler_plater_flutter_v3"
    if (Test-Path $oldDir) {
        Remove-Item $oldDir -Recurse -Force
        Write-Success "    Cleaned up old package directory"
    }
    
    # Update iOS project.pbxproj
    Write-Log "  - Updating iOS project.pbxproj..." $Colors.Blue
    if (Test-Path "$ProjectPath\ios\Runner.xcodeproj\project.pbxproj") {
        $content = Get-Content "$ProjectPath\ios\Runner.xcodeproj\project.pbxproj" -Raw
        $content = $content -replace "PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boilerPlaterFlutterV3", "PRODUCT_BUNDLE_IDENTIFIER = $FinalPackageName"
        $content = $content -replace "PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boiler_plater_flutter_v3", "PRODUCT_BUNDLE_IDENTIFIER = $FinalPackageName"
        $content = $content -replace "PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boilerPlaterFlutterV3\.RunnerTests", "PRODUCT_BUNDLE_IDENTIFIER = $FinalPackageName.RunnerTests"
        $content = $content -replace "PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boiler_plater_flutter_v3\.RunnerTests", "PRODUCT_BUNDLE_IDENTIFIER = $FinalPackageName.RunnerTests"
        $content = $content -replace "com\.thesua7\.boilerPlaterFlutterV3", $FinalPackageName
        $content = $content -replace "com\.thesua7\.boiler_plater_flutter_v3", $FinalPackageName
        $content = $content -replace "boiler_plater_flutter_v3", $ProjectName
        $content = $content -replace "Boiler Plater Flutter V3", $ProjectName
        Set-Content "$ProjectPath\ios\Runner.xcodeproj\project.pbxproj" $content -NoNewline
        Write-Success "    Updated ALL PRODUCT_BUNDLE_IDENTIFIER instances and project.pbxproj"
    } else {
        Write-Warning "    WARNING: project.pbxproj not found"
    }
    
    # Update AppInfo.xcconfig
    Write-Log "  - Updating AppInfo.xcconfig..." $Colors.Blue
    if (Test-Path "$ProjectPath\macos\Runner\Configs\AppInfo.xcconfig") {
        $content = Get-Content "$ProjectPath\macos\Runner\Configs\AppInfo.xcconfig" -Raw
        $content = $content -replace "boiler_plater_flutter_v3", $ProjectName
        Set-Content "$ProjectPath\macos\Runner\Configs\AppInfo.xcconfig" $content -NoNewline
        Write-Success "    Updated AppInfo.xcconfig"
    } else {
        Write-Warning "    WARNING: AppInfo.xcconfig not found"
    }
    
    # Update all .xcconfig files
    Write-Log "  - Updating all .xcconfig files..." $Colors.Blue
    Get-ChildItem -Path $ProjectPath -Recurse -Include "*.xcconfig" | ForEach-Object {
        Write-Log "    - Updating $($_.Name)..." $Colors.Blue
        if (Test-Path $_.FullName) {
            $content = Get-Content $_.FullName -Raw
            $content = $content -replace "boiler_plater_flutter_v3", $ProjectName
            $content = $content -replace "com\.thesua7\.boilerPlaterFlutterV3", $FinalPackageName
            $content = $content -replace "com\.thesua7\.boiler_plater_flutter_v3", $FinalPackageName
            $content = $content -replace "com\.thesua7\.", $FinalPackageName
            Set-Content $_.FullName $content -NoNewline
            Write-Success "      Updated $($_.Name)"
        }
    }
    
    # Update all CMake files
    Write-Log "  - Updating all CMake files..." $Colors.Blue
    Get-ChildItem -Path $ProjectPath -Recurse -Include "*.cmake", "CMakeLists.txt" | ForEach-Object {
        Write-Log "    - Updating $($_.Name)..." $Colors.Blue
        if (Test-Path $_.FullName) {
            $content = Get-Content $_.FullName -Raw
            $content = $content -replace "boiler_plater_flutter_v3", $ProjectName
            $content = $content -replace "com\.thesua7\.boilerPlaterFlutterV3", $FinalPackageName
            $content = $content -replace "com\.thesua7\.boiler_plater_flutter_v3", $FinalPackageName
            $content = $content -replace "com\.thesua7\.", $FinalPackageName
            Set-Content $_.FullName $content -NoNewline
            Write-Success "      Updated $($_.Name)"
        }
    }
    
    # Update Windows resource files
    Write-Log "  - Updating Windows resource files..." $Colors.Blue
    Get-ChildItem -Path $ProjectPath -Recurse -Include "*.rc" | ForEach-Object {
        Write-Log "    - Updating $($_.Name)..." $Colors.Blue
        if (Test-Path $_.FullName) {
            $content = Get-Content $_.FullName -Raw
            $content = $content -replace "boiler_plater_flutter_v3", $ProjectName
            $content = $content -replace "com\.thesua7", $FinalPackageName
            $content = $content -replace "boiler_plater_flutter_v3\.exe", "$ProjectName.exe"
            Set-Content $_.FullName $content -NoNewline
            Write-Success "      Updated $($_.Name)"
        }
    }
    
    # Update widget_test.dart
    Write-Log "  - Updating widget_test.dart..." $Colors.Blue
    if (Test-Path "$ProjectPath\test\widget_test.dart") {
        $content = Get-Content "$ProjectPath\test\widget_test.dart" -Raw
        $content = $content -replace "package:boiler_plater_flutter_v3/", "package:$ProjectName/"
        $content = $content -replace "boiler_plater_flutter_v3", $ProjectName
        Set-Content "$ProjectPath\test\widget_test.dart" $content -NoNewline
        Write-Success "    Updated widget_test.dart"
    } else {
        Write-Warning "    WARNING: widget_test.dart not found"
    }
    
    # Update Dart files
    Write-Log "  - Updating Dart files..." $Colors.Blue
    Get-ChildItem -Path "$ProjectPath\lib" -Recurse -Include "*.dart" | ForEach-Object {
        Write-Log "    - Updating $($_.Name)..." $Colors.Blue
        if (Test-Path $_.FullName) {
            $content = Get-Content $_.FullName -Raw
            $content = $content -replace "package:boiler_plater_flutter_v3/", "package:$ProjectName/"
            $content = $content -replace "boiler_plater_flutter_v3", $ProjectName
            $content = $content -replace "Boiler Plate Dev", "$ProjectName Dev"
            $content = $content -replace "Boiler Plate Staging", "$ProjectName Staging"
            $content = $content -replace "Boiler Plate", $ProjectName
            Set-Content $_.FullName $content -NoNewline
            Write-Success "      Updated $($_.Name)"
        }
    }
    
    # Update any remaining files with boilerplate references
    Write-Log "  - Updating any remaining files with boilerplate references..." $Colors.Blue
    Get-ChildItem -Path $ProjectPath -Recurse -Include "*.dart", "*.kt", "*.xml", "*.yaml", "*.yml", "*.json", "*.md", "*.txt", "*.plist", "*.pbxproj", "*.xcconfig", "*.cmake", "*.rc", "CMakeLists.txt" | ForEach-Object {
        Write-Log "    - Checking $($_.Name)..." $Colors.Blue
        if (Test-Path $_.FullName) {
            $content = Get-Content $_.FullName -Raw
            $originalContent = $content
            $content = $content -replace "package:boiler_plater_flutter_v3/", "package:$ProjectName/"
            $content = $content -replace "boiler_plater_flutter_v3", $ProjectName
            $content = $content -replace "Boiler Plate Dev", "$ProjectName Dev"
            $content = $content -replace "Boiler Plate Staging", "$ProjectName Staging"
            $content = $content -replace "Boiler Plate", $ProjectName
            $content = $content -replace "Boiler Plater Flutter V3", $ProjectName
            $content = $content -replace "PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boilerPlaterFlutterV3", "PRODUCT_BUNDLE_IDENTIFIER = $FinalPackageName"
            $content = $content -replace "PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boiler_plater_flutter_v3", "PRODUCT_BUNDLE_IDENTIFIER = $FinalPackageName"
            $content = $content -replace "PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boilerPlaterFlutterV3\.RunnerTests", "PRODUCT_BUNDLE_IDENTIFIER = $FinalPackageName.RunnerTests"
            $content = $content -replace "PRODUCT_BUNDLE_IDENTIFIER = com\.thesua7\.boiler_plater_flutter_v3\.RunnerTests", "PRODUCT_BUNDLE_IDENTIFIER = $FinalPackageName.RunnerTests"
            $content = $content -replace "com\.thesua7\.boilerPlaterFlutterV3", $FinalPackageName
            $content = $content -replace "com\.thesua7\.boiler_plater_flutter_v3", $FinalPackageName
            $content = $content -replace "com\.thesua7\.", $FinalPackageName
            $content = $content -replace 'APPLICATION_ID "com\.thesua7\.', "APPLICATION_ID `"$FinalPackageName"
            $content = $content -replace 'set\(APPLICATION_ID "com\.thesua7\.', "set(APPLICATION_ID `"$FinalPackageName"
            if ($content -ne $originalContent) {
                Set-Content $_.FullName $content -NoNewline
                Write-Success "      Updated $($_.Name)"
            }
        }
    }
    
    Write-Success "  - File updates completed"
    
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
