import 'package:flutter/foundation.dart';
import '../constants/api_constant.dart';

/// App flavor enumeration
enum AppFlavour { 
  development, 
  staging, 
  production 
}

/// Professional app configuration class
class AppConfig {
  static late AppFlavour _flavour;
  static late AppEnvironment _environment;

  /// Initialize app configuration
  static void initialize(AppFlavour flavour) {
    _flavour = flavour;
    _environment = _createEnvironment(flavour);
  }

  /// Create environment configuration
  static AppEnvironment _createEnvironment(AppFlavour flavour) {
    switch (flavour) {
      case AppFlavour.development:
        return AppEnvironment(
          name: 'Development',
          baseUrl: ApiConstants.devBaseUrl,
          appName: 'Boiler Plate Dev',
          enableDebugMode: true,
          enableLogging: true,
          enableCrashReporting: false,
          enableAnalytics: false,
          enablePushNotifications: false,
          enableBiometricAuth: false,
          enableOfflineMode: true,
          color: 0xFF4CAF50, // Green
        );
      case AppFlavour.staging:
        return AppEnvironment(
          name: 'Staging',
          baseUrl: ApiConstants.stagingBaseUrl,
          appName: 'Boiler Plate Staging',
          enableDebugMode: false,
          enableLogging: true,
          enableCrashReporting: true,
          enableAnalytics: true,
          enablePushNotifications: true,
          enableBiometricAuth: true,
          enableOfflineMode: true,
          color: 0xFFFF9800, // Orange
        );
      case AppFlavour.production:
        return AppEnvironment(
          name: 'Production',
          baseUrl: ApiConstants.productionBaseUrl,
          appName: 'Boiler Plate',
          enableDebugMode: false,
          enableLogging: false,
          enableCrashReporting: true,
          enableAnalytics: true,
          enablePushNotifications: true,
          enableBiometricAuth: true,
          enableOfflineMode: true,
          color: 0xFF2196F3, // Blue
        );
    }
  }

  /// Get current flavor
  static AppFlavour get flavour => _flavour;

  /// Get current environment
  static AppEnvironment get environment => _environment;

  /// Get base URL
  static String get baseUrl => _environment.baseUrl;

  /// Get app name
  static String get appName => _environment.appName;

  /// Get environment name
  static String get environmentName => _environment.name;

  /// Get environment color
  static int get environmentColor => _environment.color;

  /// Check if current flavor is development
  static bool get isDevelopment => _flavour == AppFlavour.development;

  /// Check if current flavor is staging
  static bool get isStaging => _flavour == AppFlavour.staging;

  /// Check if current flavor is production
  static bool get isProduction => _flavour == AppFlavour.production;

  /// Get debug mode setting
  static bool get enableDebugMode => _environment.enableDebugMode;

  /// Get logging setting
  static bool get enableLogging => _environment.enableLogging;

  /// Get crash reporting setting
  static bool get enableCrashReporting => _environment.enableCrashReporting;

  /// Get analytics setting
  static bool get enableAnalytics => _environment.enableAnalytics;

  /// Get push notifications setting
  static bool get enablePushNotifications => _environment.enablePushNotifications;

  /// Get biometric auth setting
  static bool get enableBiometricAuth => _environment.enableBiometricAuth;

  /// Get offline mode setting
  static bool get enableOfflineMode => _environment.enableOfflineMode;

  /// Auto-detect flavor based on build mode
  static AppFlavour detectFlavor() {
    if (kDebugMode) {
      return AppFlavour.development;
    } else if (kProfileMode) {
      return AppFlavour.staging;
    } else {
      return AppFlavour.production;
    }
  }
}

/// Environment configuration class
class AppEnvironment {
  final String name;
  final String baseUrl;
  final String appName;
  final bool enableDebugMode;
  final bool enableLogging;
  final bool enableCrashReporting;
  final bool enableAnalytics;
  final bool enablePushNotifications;
  final bool enableBiometricAuth;
  final bool enableOfflineMode;
  final int color;

  const AppEnvironment({
    required this.name,
    required this.baseUrl,
    required this.appName,
    required this.enableDebugMode,
    required this.enableLogging,
    required this.enableCrashReporting,
    required this.enableAnalytics,
    required this.enablePushNotifications,
    required this.enableBiometricAuth,
    required this.enableOfflineMode,
    required this.color,
  });

  /// Get API configuration
  ApiConfig get apiConfig {
    return ApiConfig(
      baseUrl: baseUrl,
      connectionTimeout: 30000,
      receiveTimeout: 30000,
      sendTimeout: 30000,
      maxRetries: 3,
      retryInterval: const Duration(seconds: 2),
    );
  }

  /// Get logging configuration
  LoggingConfig get loggingConfig {
    return LoggingConfig(
      enableNetworkLogging: enableLogging,
      enableCrashLogging: enableCrashReporting,
      enableAnalyticsLogging: enableAnalytics,
      logLevel: enableDebugMode ? LogLevel.debug : LogLevel.info,
    );
  }

  /// Get feature flags
  FeatureFlags get featureFlags {
    return FeatureFlags(
      enablePushNotifications: enablePushNotifications,
      enableBiometricAuth: enableBiometricAuth,
      enableOfflineMode: enableOfflineMode,
      enableDebugMode: enableDebugMode,
    );
  }
}

/// API configuration
class ApiConfig {
  final String baseUrl;
  final int connectionTimeout;
  final int receiveTimeout;
  final int sendTimeout;
  final int maxRetries;
  final Duration retryInterval;

  const ApiConfig({
    required this.baseUrl,
    required this.connectionTimeout,
    required this.receiveTimeout,
    required this.sendTimeout,
    required this.maxRetries,
    required this.retryInterval,
  });
}

/// Logging configuration
class LoggingConfig {
  final bool enableNetworkLogging;
  final bool enableCrashLogging;
  final bool enableAnalyticsLogging;
  final LogLevel logLevel;

  const LoggingConfig({
    required this.enableNetworkLogging,
    required this.enableCrashLogging,
    required this.enableAnalyticsLogging,
    required this.logLevel,
  });
}

/// Feature flags
class FeatureFlags {
  final bool enablePushNotifications;
  final bool enableBiometricAuth;
  final bool enableOfflineMode;
  final bool enableDebugMode;

  const FeatureFlags({
    required this.enablePushNotifications,
    required this.enableBiometricAuth,
    required this.enableOfflineMode,
    required this.enableDebugMode,
  });
}

/// Log levels
enum LogLevel {
  debug,
  info,
  warning,
  error,
}
