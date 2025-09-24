import 'package:get_it/get_it.dart';

import 'bloc/splash_bloc.dart';

class SplashBinding {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> initialize() async {
    _getIt.registerFactory<SplashBloc>(() => SplashBloc());
  }

  /// Get SplashBloc instance
  static SplashBloc get splashBloc => _getIt<SplashBloc>();
}
