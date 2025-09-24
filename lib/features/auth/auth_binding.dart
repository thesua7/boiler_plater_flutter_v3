import 'package:boiler_plater_flutter_v3/features/auth/data/dataSource/auth_remote_data_source.dart';
import 'package:boiler_plater_flutter_v3/features/auth/domain/repository/auth_repository.dart';
import 'package:boiler_plater_flutter_v3/features/auth/domain/usecases/send_otp_use_case.dart';
import 'package:boiler_plater_flutter_v3/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:boiler_plater_flutter_v3/features/auth/presentation/sendOtp/bloc/send_otp_bloc.dart';
import 'package:boiler_plater_flutter_v3/features/auth/presentation/verifyOtp/bloc/verify_otp_bloc.dart';
import 'package:get_it/get_it.dart';

import 'data/auth_repo_impl.dart';

/// Auth Binding for managing auth module dependencies
class AuthBinding {
  static final GetIt _getIt = GetIt.instance;

  /// Initialize all auth dependencies
  static Future<void> initialize() async {
    try {
      // Check if already initialized
      if (isInitialized) {
        return;
      }

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
      
      _getIt.registerLazySingleton<VerifyOtpUseCase>(
        () => VerifyOtpUseCase(repository: _getIt<AuthRepository>()),
      );

      // Register BLoCs
      _getIt.registerFactory<SendOtpBloc>(
        () => SendOtpBloc(sendOtpUseCase: _getIt<SendOtpUseCase>()),
      );

      _getIt.registerFactory<VerifyOtpBloc>(
        () => VerifyOtpBloc(verifyOtpUseCase: _getIt<VerifyOtpUseCase>()),
      );
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  /// Get AuthRepository instance
  static AuthRepository get authRepository {
    if (!_getIt.isRegistered<AuthRepository>()) {
      throw StateError('AuthRepository not registered. Call initialize() first.');
    }
    return _getIt<AuthRepository>();
  }

  /// Get SendOtpUseCase instance
  static SendOtpUseCase get sendOtpUseCase {
    if (!_getIt.isRegistered<SendOtpUseCase>()) {
      throw StateError('SendOtpUseCase not registered. Call initialize() first.');
    }
    return _getIt<SendOtpUseCase>();
  }

  static VerifyOtpUseCase get verifyOtpUseCase {
    if (!_getIt.isRegistered<VerifyOtpUseCase>()) {
      throw StateError('VerifyOtpUseCase not registered. Call initialize() first.');
    }
    return _getIt<VerifyOtpUseCase>();
  }

  /// Get SendOtpBloc instance
  static SendOtpBloc get sendOtpBloc {
    if (!_getIt.isRegistered<SendOtpBloc>()) {
      throw StateError('SendOtpBloc not registered. Call initialize() first.');
    }
    return _getIt<SendOtpBloc>();
  }

  static VerifyOtpBloc get verifyOtpBloc {
    if (!_getIt.isRegistered<VerifyOtpBloc>()) {
      throw StateError('VerifyOtpBloc not registered. Call initialize() first.');
    }
    return _getIt<VerifyOtpBloc>();
  }

  /// Reset all auth dependencies
  static Future<void> reset() async {
    try {
      await _getIt.reset();
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  /// Check if auth dependencies are registered
  static bool get isInitialized => _getIt.isRegistered<AuthRepository>();
}