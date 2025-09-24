import 'package:get_it/get_it.dart';
import '../../features/splash/splash_binding.dart';
import '../config/app_config.dart';
import '../locale/language_service.dart';
import '../theme/theme_service.dart';
import '../../features/auth/auth_binding.dart';

/// App Binding for global dependency management using GetIt
class AppBinding {
  static final GetIt _getIt = GetIt.instance;

  /// Initialize app binding
  static Future<void> initialize() async {
    try {
      // Initialize app configuration with auto-detection
      AppConfig.initialize(AppConfig.detectFlavor());

      // Initialize theme service
      await ThemeService.loadInitialTheme();

      // Register core services
      _getIt.registerLazySingleton<ThemeService>(() => ThemeService());

      // Initialize language service and load saved language
      await LanguageService().initialize();
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  /// Get theme service
  static ThemeService get themeService {
    if (!_getIt.isRegistered<ThemeService>()) {
      throw StateError('ThemeService not registered. Call initialize() first.');
    }
    return _getIt<ThemeService>();
  }

  /// Reset all services (useful for testing)
  static Future<void> reset() async {
    try {
      if (_getIt.isRegistered<ThemeService>()) {
        _getIt<ThemeService>().dispose();
      }
      await _getIt.reset();
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  /// Check if app binding is initialized
  static bool get isInitialized => _getIt.isRegistered<ThemeService>();
}

/// Global app binding instance
AppBinding get appBinding => AppBinding();
