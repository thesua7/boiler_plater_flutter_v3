import 'package:get_it/get_it.dart';
import '../config/app_config.dart';
import '../theme/theme_service.dart';
import '../../features/auth/auth_binding.dart';


/// App Binding for global dependency management using GetIt
class AppBinding {
  static final GetIt _getIt = GetIt.instance;

  /// Initialize app binding
  static Future<void> initialize() async {
    // Initialize app configuration with auto-detection
    AppConfig.initialize(AppConfig.detectFlavor());
    
    // Initialize theme service
    await ThemeService.loadInitialTheme();
    
    // Register core services
    _getIt.registerLazySingleton<ThemeService>(
      () => ThemeService(),
    );
    
    // Initialize auth module dependencies
    await AuthBinding.initialize();

  }

  /// Get theme service
  static ThemeService get themeService => _getIt<ThemeService>();

  /// Reset all services (useful for testing)
  static Future<void> reset() async {
    _getIt<ThemeService>().dispose();
    await _getIt.reset();
  }

  /// Check if app binding is initialized
  static bool get isInitialized => _getIt.isRegistered<ThemeService>();
}

/// Global app binding instance
AppBinding get appBinding => AppBinding();
