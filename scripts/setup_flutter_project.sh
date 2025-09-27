#!/bin/bash

# Flutter Project Generator - Curl Version
# This script downloads and sets up a Flutter project from the boilerplate repository
# Usage: curl -sSL https://raw.githubusercontent.com/thesua7/boiler_plater_flutter_v3/master/scripts/setup_flutter_project.sh | bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to validate project name
validate_project_name() {
    local name="$1"
    if [[ ! "$name" =~ ^[a-z][a-z0-9_]*$ ]]; then
        return 1
    fi
    return 0
}

# Function to validate package name
validate_package_name() {
    local name="$1"
    if [[ ! "$name" =~ ^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)+$ ]]; then
        return 1
    fi
    return 0
}

# Function to get user input with validation
get_input() {
    local prompt="$1"
    local validator="$2"
    local error_msg="$3"
    local value=""
    
    while true; do
        read -p "$prompt: " value
        if [[ -n "$value" ]]; then
            if $validator "$value"; then
                echo "$value"
                return
            else
                error "$error_msg"
            fi
        else
            error "This field cannot be empty"
        fi
    done
}

# Function to replace strings in files
replace_in_file() {
    local file="$1"
    local old="$2"
    local new="$3"
    
    if [[ -f "$file" ]]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s|$old|$new|g" "$file"
        else
            # Linux
            sed -i "s|$old|$new|g" "$file"
        fi
    fi
}

# Function to replace strings in all files recursively
replace_in_all_files() {
    local dir="$1"
    local old="$2"
    local new="$3"
    local extensions="$4"
    
    if [[ -d "$dir" ]]; then
        find "$dir" -type f \( $extensions \) -exec sed -i "s|$old|$new|g" {} \;
    fi
}

# Main script
main() {
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                Flutter Project Generator                     ║"
    echo "║                    (Curl Version)                            ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Check if Flutter is installed
    log "Checking Flutter installation..."
    if ! command_exists flutter; then
        error "Flutter is not installed or not in PATH"
        error "Please install Flutter from https://flutter.dev"
        exit 1
    fi
    success "Flutter found!"
    
    # Get project details
    echo
    log "Please provide the following information:"
    echo
    
    PROJECT_NAME=$(get_input "Enter project name (lowercase, underscores only)" validate_project_name "Invalid project name! Use lowercase letters, numbers, and underscores only.")
    
    if [[ "$PROJECT_NAME" == "boiler_plater_flutter_v3" ]]; then
        error "Cannot use the same name as boilerplate!"
        exit 1
    fi
    
    PACKAGE_NAME=$(get_input "Enter package name (e.g., com.yourCompany)" validate_package_name "Invalid package name! Use reverse domain notation (e.g., com.yourcompany.appname).")
    
    # Automatically append project name to package name
    FINAL_PACKAGE_NAME="${PACKAGE_NAME}.${PROJECT_NAME}"
    success "Package name will be: $FINAL_PACKAGE_NAME"
    
    # Get target directory
    read -p "Enter target directory (or press Enter for current): " TARGET_DIR
    if [[ -z "$TARGET_DIR" ]]; then
        TARGET_DIR="$(pwd)"
    fi
    
    # Validate target directory
    if [[ ! -d "$TARGET_DIR" ]]; then
        error "Target directory does not exist: $TARGET_DIR"
        exit 1
    fi
    
    PROJECT_PATH="$TARGET_DIR/$PROJECT_NAME"
    
    # Check if project already exists
    if [[ -d "$PROJECT_PATH" ]]; then
        error "Project directory already exists: $PROJECT_PATH"
        error "Please choose a different name or location"
        exit 1
    fi
    
    echo
    log "Creating project: $PROJECT_NAME"
    log "Location: $PROJECT_PATH"
    echo
    
    # Create project directory
    log "Creating project directory..."
    mkdir -p "$PROJECT_PATH"
    success "Project directory created"
    
    # Download boilerplate from GitHub
    log "Downloading boilerplate project..."
    
    # Create temporary directory for download
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Download the repository as a zip file
    if command_exists curl; then
        curl -L -o boilerplate.zip "https://github.com/thesua7/boiler_plater_flutter_v3/archive/refs/heads/master.zip"
    elif command_exists wget; then
        wget -O boilerplate.zip "https://github.com/thesua7/boiler_plater_flutter_v3/archive/refs/heads/master.zip"
    else
        error "Neither curl nor wget is available. Please install one of them."
        exit 1
    fi
    
    # Extract the zip file
    if command_exists unzip; then
        unzip -q boilerplate.zip
    else
        error "unzip is not available. Please install unzip."
        exit 1
    fi
    
    # Find the extracted directory
    EXTRACTED_DIR=$(find . -name "boiler_plater_flutter_v3-master" -type d | head -1)
    
    if [[ -z "$EXTRACTED_DIR" ]]; then
        error "Failed to extract boilerplate project"
        exit 1
    fi
    
    # Copy files to project directory (excluding certain files/directories)
    log "Copying project files..."
    
    # Create exclude list
    EXCLUDE_LIST=(
        ".git"
        ".idea"
        ".dart_tool"
        ".vscode"
        ".fvm"
        ".DS_Store"
        "pubspec.lock"
        "*.lock"
        "build"
        "scripts"
        "node_modules"
    )
    
    # Build rsync exclude options
    RSYNC_EXCLUDE=""
    for item in "${EXCLUDE_LIST[@]}"; do
        RSYNC_EXCLUDE="$RSYNC_EXCLUDE --exclude=$item"
    done
    
    # Use rsync if available, otherwise use cp
    if command_exists rsync; then
        rsync -av $RSYNC_EXCLUDE "$EXTRACTED_DIR/" "$PROJECT_PATH/"
    else
        # Fallback to cp with find
        find "$EXTRACTED_DIR" -type f \( -name "*.lock" -o -name ".DS_Store" \) -delete
        cp -r "$EXTRACTED_DIR"/* "$PROJECT_PATH/"
    fi
    
    # Clean up temporary directory
    cd "$TARGET_DIR"
    rm -rf "$TEMP_DIR"
    
    success "Project files copied successfully"
    
    # Update project files
    log "Updating project files..."
    
    # Update pubspec.yaml
    if [[ -f "$PROJECT_PATH/pubspec.yaml" ]]; then
        replace_in_file "$PROJECT_PATH/pubspec.yaml" "boiler_plater_flutter_v3" "$PROJECT_NAME"
        success "Updated pubspec.yaml"
    fi
    
    # Update Android files
    if [[ -f "$PROJECT_PATH/android/app/src/main/AndroidManifest.xml" ]]; then
        replace_in_file "$PROJECT_PATH/android/app/src/main/AndroidManifest.xml" "boiler_plater_flutter_v3" "$PROJECT_NAME"
        success "Updated AndroidManifest.xml"
    fi
    
    if [[ -f "$PROJECT_PATH/android/app/build.gradle.kts" ]]; then
        replace_in_file "$PROJECT_PATH/android/app/build.gradle.kts" "com.thesua7.boiler_plater_flutter_v3" "$FINAL_PACKAGE_NAME"
        replace_in_file "$PROJECT_PATH/android/app/build.gradle.kts" "Boiler Plate Dev" "$PROJECT_NAME Dev"
        replace_in_file "$PROJECT_PATH/android/app/build.gradle.kts" "Boiler Plate Staging" "$PROJECT_NAME Staging"
        replace_in_file "$PROJECT_PATH/android/app/build.gradle.kts" "Boiler Plate" "$PROJECT_NAME"
        replace_in_file "$PROJECT_PATH/android/app/build.gradle.kts" "Boiler Plater Flutter V3" "$PROJECT_NAME"
        success "Updated Android build.gradle.kts"
    fi
    
    # Update iOS files
    if [[ -f "$PROJECT_PATH/ios/Runner/Info.plist" ]]; then
        replace_in_file "$PROJECT_PATH/ios/Runner/Info.plist" "boiler_plater_flutter_v3" "$PROJECT_NAME"
        success "Updated iOS Info.plist"
    fi
    
    # Update README.md
    if [[ -f "$PROJECT_PATH/README.md" ]]; then
        replace_in_file "$PROJECT_PATH/README.md" "boiler_plater_flutter_v3" "$PROJECT_NAME"
        success "Updated README.md"
    fi
    
    # Update Dart files
    log "Updating Dart files..."
    replace_in_all_files "$PROJECT_PATH/lib" "package:boiler_plater_flutter_v3/" "package:$PROJECT_NAME/" "-name '*.dart'"
    replace_in_all_files "$PROJECT_PATH/lib" "boiler_plater_flutter_v3" "$PROJECT_NAME" "-name '*.dart'"
    success "Updated Dart files"
    
    # Update test files
    if [[ -f "$PROJECT_PATH/test/widget_test.dart" ]]; then
        replace_in_file "$PROJECT_PATH/test/widget_test.dart" "package:boiler_plater_flutter_v3/" "package:$PROJECT_NAME/"
        replace_in_file "$PROJECT_PATH/test/widget_test.dart" "boiler_plater_flutter_v3" "$PROJECT_NAME"
        success "Updated test files"
    fi
    
    # Update MainActivity.kt package structure
    if [[ -f "$PROJECT_PATH/android/app/src/main/kotlin/com/thesua7/boiler_plater_flutter_v3/MainActivity.kt" ]]; then
        # Create new package directory structure
        NEW_PACKAGE_DIR="$PROJECT_PATH/android/app/src/main/kotlin/$(echo $FINAL_PACKAGE_NAME | tr '.' '/')"
        mkdir -p "$NEW_PACKAGE_DIR"
        
        # Move and update MainActivity.kt
        cp "$PROJECT_PATH/android/app/src/main/kotlin/com/thesua7/boiler_plater_flutter_v3/MainActivity.kt" "$NEW_PACKAGE_DIR/MainActivity.kt"
        replace_in_file "$NEW_PACKAGE_DIR/MainActivity.kt" "com.thesua7.boiler_plater_flutter_v3" "$FINAL_PACKAGE_NAME"
        
        # Remove old package directory
        rm -rf "$PROJECT_PATH/android/app/src/main/kotlin/com"
        
        success "Updated MainActivity.kt package structure"
    fi
    
    # Change to project directory
    cd "$PROJECT_PATH"
    
    # Run Flutter commands
    log "Installing dependencies..."
    if flutter pub get; then
        success "Dependencies installed successfully"
    else
        warning "Failed to install dependencies. You may need to run 'flutter pub get' manually."
    fi
    
    # Clean up
    log "Cleaning up..."
    flutter clean > /dev/null 2>&1 || true
    
    echo
    success "🎉 PROJECT CREATED SUCCESSFULLY! 🎉"
    echo
    echo "Project Name: $PROJECT_NAME"
    echo "Package Name: $FINAL_PACKAGE_NAME"
    echo "Location: $PROJECT_PATH"
    echo
    echo "Build Variants Available:"
    echo "  - Development: flutter run --flavor development"
    echo "  - Staging: flutter run --flavor staging"
    echo "  - Production: flutter run --flavor production"
    echo
    echo "Build Commands:"
    echo "  - Development: flutter build apk --flavor development"
    echo "  - Staging: flutter build apk --flavor staging"
    echo "  - Production: flutter build apk --flavor production"
    echo
    echo "✅ ALL STEPS COMPLETED SUCCESSFULLY! ✅"
    echo
    echo "Next steps:"
    echo "1. Open the project in your IDE"
    echo "2. Run: flutter run --flavor development"
    echo "3. Start building your app!"
}

# Run main function
main "$@"
