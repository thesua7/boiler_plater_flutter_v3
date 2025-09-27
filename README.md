# Flutter Boilerplate v3

A comprehensive, production-ready Flutter boilerplate with clean architecture, state management, internationalization, theming, and multi-environment support.

## 🚀 Features

### Core Architecture
- **Clean Architecture** with Domain, Data, and Presentation layers
- **BLoC Pattern** for state management using `flutter_bloc`
- **Dependency Injection** using `get_it`
- **Repository Pattern** for data abstraction
- **Use Cases** for business logic separation

### State Management & Navigation
- **Flutter BLoC** for reactive state management
- **GoRouter** for declarative navigation
- **Custom Transitions** for smooth page animations
- **Lazy BLoC Creation** for optimal performance

### UI/UX Features
- **Responsive Design** with `flutter_screenutil`
- **Dark/Light Theme** support with persistence
- **Custom Widget Themes** for consistent design
- **Material 3** design system
- **Custom Fonts** (Poppins)

### Internationalization (i18n)
- **Multi-language Support** (English & Bangla)
- **Language Persistence** with secure storage
- **Reactive Language Changes**
- **Localized Form Validation**
- **Language Switcher Widget**

### Network & Data
- **Dio HTTP Client** with interceptors
- **Retry Logic** for failed requests
- **Request/Response Logging**
- **Secure Storage** for sensitive data
- **Data Encryption** support

### Development Features
- **Multi-Environment Support** (Development, Staging, Production)
- **Flavor-based Configuration**
- **Debug Mode Toggle**
- **Comprehensive Logging**
- **Error Handling** with custom exceptions

## 📦 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_secure_storage: ^9.2.4  # Secure data storage
  encrypt: ^5.0.3                  # Data encryption
  dio: ^5.9.0                     # HTTP client
  get_it: ^8.2.0                 # Dependency injection
  flutter_bloc: ^8.1.6           # State management
  equatable: ^2.0.5              # Value equality
  go_router: ^14.2.7             # Navigation
  flutter_screenutil: ^5.9.3     # Responsive design
```

### Development Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0          # Code linting
```

## 🏗️ Project Structure

```
lib/
├── core/                        # Core functionality
│   ├── config/                  # App configuration
│   │   └── app_config.dart      # Environment & flavor config
│   ├── constants/               # App constants
│   │   ├── api_constant.dart    # API endpoints & config
│   │   ├── colors.dart          # Color palette
│   │   ├── sizes.dart           # Size constants
│   │   └── storage_constant.dart # Storage keys
│   ├── data/                    # Data layer
│   │   ├── network/             # Network services
│   │   │   ├── base_api_service.dart
│   │   │   ├── dio_client.dart
│   │   │   ├── dio_configs.dart
│   │   │   ├── interceptors/    # Request interceptors
│   │   │   └── response/         # Response models
│   │   └── sharedPref/          # Local storage
│   │       └── secure_storage.dart
│   ├── di/                      # Dependency injection
│   │   ├── app_binding.dart     # App-level DI
│   │   └── base_binding.dart    # Base DI setup
│   ├── error/                   # Error handling
│   │   ├── either.dart          # Either monad
│   │   ├── failures.dart        # Failure types
│   │   └── network_exceptions.dart
│   ├── locale/                  # Internationalization
│   │   └── language_service.dart
│   ├── route/                   # Navigation
│   │   ├── app_route.dart       # Route configuration
│   │   ├── custom_transition.dart
│   │   └── route_constant.dart
│   ├── theme/                   # Theming
│   │   ├── app_theme.dart       # Theme configuration
│   │   ├── theme_service.dart   # Theme management
│   │   └── widget_themes/       # Custom widget themes
│   ├── usecase/                 # Business logic
│   │   └── base_usecase.dart
│   ├── util/                    # Utilities
│   └── widgets/                 # Reusable widgets
│       ├── language_switcher.dart
│       ├── otp_input_field.dart
│       └── responsive/
├── features/                    # Feature modules
│   ├── auth/                    # Authentication
│   │   ├── data/                # Data layer
│   │   │   ├── auth_repo_impl.dart
│   │   │   ├── dataSource/
│   │   │   └── model/
│   │   ├── domain/              # Domain layer
│   │   │   ├── entities/
│   │   │   ├── repository/
│   │   │   └── usecases/
│   │   ├── presentation/        # Presentation layer
│   │   │   ├── sendOtp/
│   │   │   └── verifyOtp/
│   │   └── auth_binding.dart
│   ├── home/                    # Home feature
│   └── splash/                  # Splash screen
├── l10n/                        # Localization files
│   ├── app_en.arb              # English translations
│   ├── app_bn.arb              # Bangla translations
│   └── app_localizations.dart  # Generated localizations
├── examplePages/                # Example pages
│   ├── screenutil_demo_page.dart
│   └── theme_test_page.dart
└── main.dart                    # App entry point
```

## 🛠️ Setup & Installation

### Prerequisites
- Flutter SDK (^3.9.0)
- Dart SDK
- Android Studio / VS Code
- Git

### Quick Start - Create New Project

**🚀 One-Command Setup (Recommended)**

Generate a new Flutter project instantly with a single command:

**Windows (PowerShell):**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/thesua7/boiler_plater_flutter_v3/master/scripts/setup_flutter_project.ps1" | Invoke-Expression
```

**Linux/macOS (Bash):**
```bash
curl -fsSL https://raw.githubusercontent.com/thesua7/boiler_plater_flutter_v3/master/scripts/setup_flutter_project.sh | bash
```

**📁 Local Project Generator**

1. **Double-click** `create_new_project.bat` in the root directory
2. **Follow the prompts** to create your new Flutter project
3. **Start coding** immediately with a fully configured project

**📁 Manual Setup (For Development)**

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd boiler_plater_flutter_v3
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localizations**
   ```bash
   flutter gen-l10n
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Project Generator Features

The project generator automatically:
- ✅ Creates new Flutter projects using this boilerplate as template
- ✅ Updates all configuration files with your project details
- ✅ Installs dependencies and generates localizations
- ✅ Sets up multi-environment configuration
- ✅ Provides comprehensive error handling and validation
- ✅ Updates macOS and Windows specific files (BuildableName, bundle identifiers, etc.)
- ✅ Handles C++ files (main.cpp, my_application.cc) with proper string replacements

**Usage Options**:
- **One-Command**: Use the curl commands above for instant setup
- **Local**: Double-click `create_new_project.bat` or run `scripts/create_flutter_project.bat`

## 🎯 Environment Configuration

### Supported Environments
- **Development** - Debug mode, local APIs
- **Staging** - Testing environment
- **Production** - Live environment

### Environment Commands

#### Development
```bash
# Run development build
flutter run --flavor development

# Build development APK
flutter build apk --flavor development

# Build development App Bundle
flutter build appbundle --flavor development
```

#### Staging
```bash
# Run staging build
flutter run --flavor staging

# Build staging APK
flutter build apk --flavor staging

# Build staging App Bundle
flutter build appbundle --flavor staging
```

#### Production
```bash
# Run production build
flutter run --flavor production

# Build production APK
flutter build apk --flavor production

# Build production App Bundle
flutter build appbundle --flavor production
```

### Release Builds
```bash
# Development Release
flutter build apk --flavor development --release

# Staging Release
flutter build apk --flavor staging --release

# Production Release
flutter build apk --flavor production --release
```

## 🌍 Internationalization

### Supported Languages
- **English (en)** - Default language
- **Bangla (bn)** - Bengali language support

### Adding New Languages

1. **Create new ARB file**: `lib/l10n/app_[language_code].arb`
2. **Add translations** following the existing pattern
3. **Update supported locales** in `main.dart`:
   ```dart
   supportedLocales: const [
     Locale('en', ''), // English
     Locale('bn', ''), // Bangla
     Locale('hi', ''), // Hindi (example)
   ],
   ```
4. **Regenerate localizations**:
   ```bash
   flutter gen-l10n
   ```

### Using Localizations
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.appTitle)
```

### Language Persistence
The selected language is automatically saved and restored on app restart:
```dart
// Change language (automatically saved)
await LanguageService().changeLanguage(const Locale('bn', ''));

// Reset to default
await LanguageService().resetToDefault();
```

## 🎨 Theming

### Theme Features
- **Material 3** design system
- **Dark/Light** theme support
- **Theme persistence**
- **Custom widget themes**
- **Responsive design**

### Theme Management
```dart
// Change theme
ThemeService().toggleTheme();

// Set specific theme
ThemeService().setTheme(ThemeMode.dark);

// Get current theme
ThemeMode currentTheme = ThemeService().currentTheme;
```

### Custom Themes
The app includes custom themes for:
- AppBar
- Bottom Sheet
- Checkbox
- Chip
- Elevated Button
- Outlined Button
- Text Field
- Text Theme

## 🧭 Navigation

### Route Configuration
Routes are configured in `lib/core/route/app_route.dart` using GoRouter:

```dart
final GoRouter appRoute = GoRouter(
  initialLocation: RouteConstant.splash,
  routes: [
    // Route definitions with lazy BLoC creation
  ],
);
```

### Available Routes
- `/` - Splash screen
- `/send-otp` - Send OTP page
- `/verify-otp` - Verify OTP page
- `/home` - Home page
- `/test-theme` - Theme test page
- `/screen-util-demo` - ScreenUtil demo page

### Navigation Usage
```dart
// Navigate to a route
context.go('/home');

// Navigate with parameters
context.go('/verify-otp?phone=1234567890');

// Navigate with custom transitions
context.go('/home', extra: {'transition': AppTransition.fade});
```

## 🔐 Authentication

### Authentication Flow
1. **Splash Screen** - App initialization
2. **Send OTP** - Phone number input
3. **Verify OTP** - OTP verification
4. **Home** - Main app screen

### Authentication Features
- **Phone number validation**
- **OTP verification**
- **Secure token storage**
- **Auto-logout on token expiry**

## 📱 Responsive Design

### ScreenUtil Integration
The app uses `flutter_screenutil` for responsive design:

```dart
// Design size configuration
ScreenUtilInit(
  designSize: const Size(375, 812), // iPhone X design size
  minTextAdapt: true,
  splitScreenMode: true,
  useInheritedMediaQuery: true,
  builder: (context, child) {
    return MaterialApp.router(/* ... */);
  },
);
```

### Responsive Usage
```dart
// Responsive sizing
Container(
  width: 100.w,    // 100% of screen width
  height: 50.h,    // 50% of screen height
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 16.sp), // Responsive font size
  ),
)
```

## 🔧 Development Tools

### Code Quality
- **Flutter Lints** for code quality
- **Analysis Options** configuration
- **Consistent code formatting**

### Debug Features
- **Debug mode toggle** per environment
- **Comprehensive logging**
- **Network request/response logging**
- **Error tracking**

### Testing
```bash
# Run tests
flutter test

# Run integration tests
flutter test integration_test/
```

## 📊 API Configuration

### Base URLs
- **Development**: `https://karmasangsthan.com.bd`
- **Staging**: `https://karmasangsthan.com.bd`
- **Production**: `https://karmasangsthan.com.bd`

### API Features
- **Automatic retry** on failure
- **Request/response interceptors**
- **Timeout configuration**
- **Error handling**

### API Usage
```dart
// API service usage
final apiService = BaseApiService();
final response = await apiService.get('/endpoint');
```

## 🔒 Security Features

### Data Protection
- **Secure storage** for sensitive data
- **Data encryption** support
- **Token-based authentication**
- **Secure API communication**

### Storage Keys
```dart
class StorageConstants {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userData = 'user_data';
  static const String language = 'language';
  static const String theme = 'theme';
}
```

## 🚀 Deployment

### Android Deployment
```bash
# Build release APK
flutter build apk --flavor production --release

# Build release App Bundle
flutter build appbundle --flavor production --release
```

### iOS Deployment
```bash
# Build iOS release
flutter build ios --flavor production --release
```

## 📝 Best Practices

### Code Organization
- **Feature-based structure**
- **Clean architecture principles**
- **Separation of concerns**
- **Dependency injection**

### State Management
- **BLoC pattern** for complex state
- **Immutable state** objects
- **Event-driven architecture**
- **Reactive programming**

### Error Handling
- **Custom exception types**
- **Either monad** for error handling
- **User-friendly error messages**
- **Logging and monitoring**

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Check the documentation
- Review the example pages

## 🔄 Version History

- **v3.0.0** - Current version with clean architecture, BLoC, and multi-environment support
- **v2.x.x** - Previous versions with different architecture patterns

---

**Happy Coding! 🎉**
