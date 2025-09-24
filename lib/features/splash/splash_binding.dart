import 'package:get_it/get_it.dart';
import 'bloc/splash_bloc.dart';

class SplashBinding {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> initialize() async {
    try {
      if (!isInitialized) {
        _getIt.registerFactory<SplashBloc>(() => SplashBloc());
      }
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  /// Get SplashBloc instance
  static SplashBloc get splashBloc {
    if (!_getIt.isRegistered<SplashBloc>()) {
      throw StateError('SplashBloc not registered. Call initialize() first.');
    }
    return _getIt<SplashBloc>();
  }

  /// Reset Splash module
  static Future<void> reset() async {
    try {
      await _getIt.reset();
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  /// Check if splash dependencies are registered
  static bool get isInitialized => _getIt.isRegistered<SplashBloc>();
}
