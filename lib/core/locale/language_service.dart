import 'package:boiler_plater_flutter_v3/core/constants/storage_constant.dart';
import 'package:flutter/material.dart';
import '../data/sharedPref/secure_storage.dart';

/// Language Service to manage app language with persistence
class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();


  
  Locale _currentLocale = const Locale('en', '');
  bool _isInitialized = false;
  
  Locale get currentLocale => _currentLocale;
  bool get isInitialized => _isInitialized;
  
  /// Initialize language service and load saved language
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final savedLanguage = await SecureStorageHelper.read(StorageConstant.currentLanguage);
      if (savedLanguage != null && savedLanguage.isNotEmpty) {
        _currentLocale = Locale(savedLanguage, '');
      } else {
        _currentLocale = const Locale('en', ''); // Default to English
      }
    } catch (e) {
      // If there's an error reading, default to English
      _currentLocale = const Locale('en', '');
    }
    
    _isInitialized = true;
    notifyListeners();
  }
  
  /// Change language and save to secure storage
  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale != locale) {
      _currentLocale = locale;
      
      try {
        await SecureStorageHelper.write(StorageConstant.currentLanguage, locale.languageCode);
      } catch (e) {
        // If saving fails, still update the current locale
        // but log the error for debugging
        debugPrint('Failed to save language preference: $e');
      }
      
      notifyListeners();
    }
  }
  
  /// Reset to default language (English)
  Future<void> resetToDefault() async {
    await changeLanguage(const Locale('en', ''));
  }
  
  /// Get available languages
  static List<Locale> get supportedLocales => const [
    Locale('en', ''), // English
    Locale('bn', ''), // Bangla
  ];
  
  bool get isEnglish => _currentLocale.languageCode == 'en';
  bool get isBangla => _currentLocale.languageCode == 'bn';
}
