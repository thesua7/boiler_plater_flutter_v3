import 'package:flutter/material.dart';
import '../data/sharedPref/secure_storage.dart';

class ThemeService extends ValueNotifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';
  static ThemeMode? _initialTheme;
  
  ThemeService() : super(_initialTheme ?? ThemeMode.system) {
    // Theme is already loaded in main() before this constructor is called
  }

  /// Load theme from secure storage synchronously during app initialization
  static Future<ThemeMode> loadInitialTheme() async {
    try {
      final savedTheme = await SecureStorageHelper.read(_themeKey);
      if (savedTheme != null) {
        switch (savedTheme) {
          case 'light':
            _initialTheme = ThemeMode.light;
            break;
          case 'dark':
            _initialTheme = ThemeMode.dark;
            break;
          case 'system':
          default:
            _initialTheme = ThemeMode.system;
            break;
        }
      } else {
        _initialTheme = ThemeMode.system;
      }
    } catch (e) {
      // If there's an error loading theme, default to system
      _initialTheme = ThemeMode.system;
    }
    return _initialTheme!;
  }


  /// Save theme to secure storage
  Future<void> _saveTheme(ThemeMode themeMode) async {
    try {
      String themeString;
      switch (themeMode) {
        case ThemeMode.light:
          themeString = 'light';
          break;
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.system:
          themeString = 'system';
          break;
      }
      await SecureStorageHelper.write(_themeKey, themeString);
    } catch (e) {
      // Handle error silently or log it
      debugPrint('Error saving theme: $e');
    }
  }

  /// Set theme mode and save to storage
  Future<void> setThemeMode(ThemeMode themeMode) async {
    value = themeMode;
    await _saveTheme(themeMode);
  }

  /// Toggle between light and dark mode (ignores system mode)
  Future<void> toggleTheme() async {
    if (value == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Get current theme mode as string
  String get currentThemeString {
    switch (value) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Check if current theme is dark
  bool get isDarkMode => value == ThemeMode.dark;

  /// Check if current theme is light
  bool get isLightMode => value == ThemeMode.light;

  /// Check if current theme is system
  bool get isSystemMode => value == ThemeMode.system;

  /// Get theme icon
  IconData get themeIcon {
    switch (value) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  /// Dispose and clean up
  @override
  void dispose() {
    super.dispose();
  }
}
