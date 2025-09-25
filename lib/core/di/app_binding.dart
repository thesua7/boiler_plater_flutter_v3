import '../../features/splash/splash_binding.dart';
import '../config/app_config.dart';
import '../locale/language_service.dart';
import '../theme/theme_service.dart';
import '../../features/auth/auth_binding.dart';
import 'base_binding.dart';

/// App Binding for global dependency management using GetIt
class AppBinding extends BaseBinding {

  /// Initialize app binding
  static Future<void> initialize() async {
    try {
      // Initialize app configuration with auto-detection
      AppConfig.initialize(AppConfig.detectFlavor());

      // Initialize theme service
      await ThemeService.loadInitialTheme();

      // Register core services
      BaseBinding.registerLazySingleton<ThemeService>(() => ThemeService());

      // Initialize language service and load saved language
      await LanguageService().initialize();
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  /// Get theme service
  static ThemeService get themeService => BaseBinding.get<ThemeService>();

  /// Reset all services (useful for testing)
  static Future<void> reset() async {
    await BaseBinding.dispose<ThemeService>();
    await BaseBinding.reset();
  }

  /// Check if app binding is initialized
  static bool get isInitialized => BaseBinding.isRegistered<ThemeService>();
}

/// Global app binding instance
AppBinding get appBinding => AppBinding();
