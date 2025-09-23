# Localization Guide

This Flutter boilerplate now supports internationalization (i18n) with English and Bangla languages.

## Features

- ✅ English (en) - Default language
- ✅ Bangla (bn) - Bengali language support
- ✅ Language switcher widget
- ✅ Reactive language changes
- ✅ **Language persistence** - Selected language saved securely
- ✅ **Auto-restore** - Language loads on app restart
- ✅ Localized form validation messages
- ✅ Localized UI text

## How to Use

### 1. Adding New Languages

To add a new language (e.g., Hindi):

1. Create a new ARB file: `lib/l10n/app_hi.arb`
2. Copy the content from `app_en.arb` and translate the values
3. Add the locale to `main.dart`:
   ```dart
   supportedLocales: const [
     Locale('en', ''), // English
     Locale('bn', ''), // Bangla
     Locale('hi', ''), // Hindi
   ],
   ```

### 2. Adding New Localized Strings

1. Add the key-value pair to `lib/l10n/app_en.arb`:
   ```json
   {
     "newKey": "New English Text",
     "@newKey": {
       "description": "Description of the new key"
     }
   }
   ```

2. Add the same key to other language files with translations:
   ```json
   {
     "newKey": "নতুন বাংলা টেক্সট"
   }
   ```

3. Run `flutter gen-l10n` to regenerate localization files

4. Use in your widget:
   ```dart
   final l10n = AppLocalizations.of(context)!;
   Text(l10n.newKey)
   ```

### 3. Language Switcher

The `LanguageSwitcher` widget is already integrated into the app bar. It provides a popup menu to switch between supported languages.

### 4. Programmatic Language Change

```dart
final languageService = LanguageService();
await languageService.changeLanguage(const Locale('bn', ''));
```

### 5. Language Persistence

The selected language is automatically saved to secure storage and restored on app restart:

```dart
// Language is automatically loaded on app startup
await LanguageService().initialize();

// Change language (automatically saved)
await languageService.changeLanguage(const Locale('bn', ''));

// Reset to default language
await languageService.resetToDefault();
```

## File Structure

```
lib/
├── l10n/
│   ├── app_en.arb          # English translations
│   ├── app_bn.arb          # Bangla translations
│   └── app_localizations.dart  # Generated localization class
├── core/
│   ├── services/
│   │   └── language_service.dart  # Language management service
│   └── widgets/
│       └── language_switcher.dart  # Language switcher widget
└── l10n.yaml              # Localization configuration
```

## Current Localized Strings

- `appTitle` - Application title
- `enterPhoneNumber` - Phone number input header
- `sendVerificationCode` - Verification code subtitle
- `phoneNumber` - Phone number label
- `phoneNumberHint` - Phone number hint text
- `sendOtp` - Send OTP button text
- `reset` - Reset button text
- `success` - Success dialog title
- `ok` - OK button text
- `pleaseEnterPhoneNumber` - Phone number validation error
- `pleaseEnterValidPhoneNumber` - Invalid phone number error
- `termsAndPrivacy` - Terms and privacy policy text

## Testing

1. Run the app: `flutter run`
2. Use the language switcher in the app bar to change languages
3. Verify that all text changes to the selected language
4. Test form validation messages in both languages
5. **Test persistence**: 
   - Change language to Bangla
   - Close and restart the app
   - Verify the app opens in Bangla
   - Change back to English and restart to verify

## Notes

- The app defaults to English
- Language changes are reactive and update the UI immediately
- **Selected language is persisted using secure storage**
- **Language preference is restored on app restart**
- All form validation messages are localized
- The language switcher shows the current language with a checkmark
- Language service initialization happens before app startup
