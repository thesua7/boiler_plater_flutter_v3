import 'package:get_it/get_it.dart';
import 'bloc/splash_bloc.dart';
import '../../core/di/base_binding.dart';

class SplashBinding extends BaseBinding {

  static Future<void> initialize() async {
    try {
      if (!isInitialized) {
        BaseBinding.registerFactory<SplashBloc>(() => SplashBloc());
      }
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  /// Get SplashBloc instance
  static SplashBloc get splashBloc => BaseBinding.get<SplashBloc>();

  /// Reset Splash module
  static Future<void> reset() async {
    await BaseBinding.reset();
  }

  /// Check if splash dependencies are registered
  static bool get isInitialized => BaseBinding.isRegistered<SplashBloc>();
}
