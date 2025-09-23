# Flavor Commands

## Android Commands

### Run with specific flavor
```bash
# Development
flutter run --flavor development

# Staging
flutter run --flavor staging

# Production
flutter run --flavor production
```

### Build APK with specific flavor
```bash
# Development
flutter build apk --flavor development

# Staging
flutter build apk --flavor staging

# Production
flutter build apk --flavor production
```

### Build App Bundle with specific flavor
```bash
# Development
flutter build appbundle --flavor development

# Staging
flutter build appbundle --flavor staging

# Production
flutter build appbundle --flavor production
```

## iOS Commands

### Run with specific flavor
```bash
# Development
flutter run --flavor development

# Staging
flutter run --flavor staging

# Production
flutter run --flavor production
```

### Build iOS with specific flavor
```bash
# Development
flutter build ios --flavor development

# Staging
flutter build ios --flavor staging

# Production
flutter build ios --flavor production
```

## Quick Commands

### Development
```bash
flutter run --flavor development
```

### Staging
```bash
flutter run --flavor staging
```

### Production
```bash
flutter run --flavor production
```

## Build for Release

### Android
```bash
# Development Release
flutter build apk --flavor development --release

# Staging Release
flutter build apk --flavor staging --release

# Production Release
flutter build apk --flavor production --release
```

### iOS
```bash
# Development Release
flutter build ios --flavor development --release

# Staging Release
flutter build ios --flavor staging --release

# Production Release
flutter build ios --flavor production --release
```

## Check Current Flavor

Add this to your app to see the current flavor:
```dart
print('Current flavor: ${AppConfig.flavour}');
print('Base URL: ${AppConfig.baseUrl}');
print('App Name: ${AppConfig.appName}');
```
