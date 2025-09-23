import 'package:boiler_plater_flutter_v3/features/auth/data/dataSource/auth_remote_data_source.dart';
import 'package:boiler_plater_flutter_v3/features/auth/domain/repository/auth_repository.dart';
import 'package:boiler_plater_flutter_v3/features/auth/domain/usecases/send_otp_use_case.dart';
import 'package:boiler_plater_flutter_v3/features/auth/presentation/bloc/send_otp_bloc.dart';
import 'package:get_it/get_it.dart';

import 'data/auth_repo_impl.dart';

/// Auth Binding for managing auth module dependencies
class AuthBinding {
  static final GetIt _getIt = GetIt.instance;

  /// Initialize all auth dependencies
  static Future<void> initialize() async {
    // Register Data Sources
    _getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(),
    );

    // Register Repository
    _getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepoImpl(dataSource: _getIt<AuthRemoteDataSource>()),
    );

    // Register Use Cases
    _getIt.registerLazySingleton<SendOtpUseCase>(
      () => SendOtpUseCase(repository: _getIt<AuthRepository>()),
    );

    // Register BLoCs
    _getIt.registerFactory<SendOtpBloc>(
      () => SendOtpBloc(sendOtpUseCase: _getIt<SendOtpUseCase>()),
    );
  }

  /// Get AuthRepository instance
  static AuthRepository get authRepository => _getIt<AuthRepository>();

  /// Get SendOtpUseCase instance
  static SendOtpUseCase get sendOtpUseCase => _getIt<SendOtpUseCase>();

  /// Get SendOtpBloc instance
  static SendOtpBloc get sendOtpBloc => _getIt<SendOtpBloc>();

  /// Reset all auth dependencies
  static Future<void> reset() async {
    await _getIt.reset();
  }

  /// Check if auth dependencies are registered
  static bool get isInitialized => _getIt.isRegistered<AuthRepository>();
}