import 'package:boiler_plater_flutter_v3/features/auth/data/dataSource/auth_remote_data_source.dart';
import 'package:boiler_plater_flutter_v3/features/auth/domain/repository/auth_repository.dart';
import 'package:boiler_plater_flutter_v3/features/auth/domain/usecases/send_otp_use_case.dart';
import 'package:boiler_plater_flutter_v3/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:boiler_plater_flutter_v3/features/auth/presentation/sendOtp/bloc/send_otp_bloc.dart';
import 'package:boiler_plater_flutter_v3/features/auth/presentation/verifyOtp/bloc/verify_otp_bloc.dart';
import '../../core/di/base_binding.dart';

import 'data/auth_repo_impl.dart';

/// Auth Binding for managing auth module dependencies
class AuthBinding extends BaseBinding {

  /// Initialize all auth dependencies
  static Future<void> initialize() async {
    try {
      // Check if already initialized
      if (isInitialized) {
        return;
      }

      // Register Data Sources
      BaseBinding.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(),
      );

      // Register Repository
      BaseBinding.registerLazySingleton<AuthRepository>(
        () => AuthRepoImpl(dataSource: BaseBinding.get<AuthRemoteDataSource>()),
      );

      // Register Use Cases
      BaseBinding.registerLazySingleton<SendOtpUseCase>(
        () => SendOtpUseCase(repository: BaseBinding.get<AuthRepository>()),
      );
      
      BaseBinding.registerLazySingleton<VerifyOtpUseCase>(
        () => VerifyOtpUseCase(repository: BaseBinding.get<AuthRepository>()),
      );

      // Register BLoCs
      BaseBinding.registerFactory<SendOtpBloc>(
        () => SendOtpBloc(sendOtpUseCase: BaseBinding.get<SendOtpUseCase>()),
      );

      BaseBinding.registerFactory<VerifyOtpBloc>(
        () => VerifyOtpBloc(verifyOtpUseCase: BaseBinding.get<VerifyOtpUseCase>()),
      );
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  // /// Get AuthRepository instance
  // static AuthRepository get authRepository => BaseBinding.get<AuthRepository>();
  //
  // /// Get SendOtpUseCase instance
  // static SendOtpUseCase get sendOtpUseCase => BaseBinding.get<SendOtpUseCase>();
  //
  // static VerifyOtpUseCase get verifyOtpUseCase => BaseBinding.get<VerifyOtpUseCase>();

  /// Get SendOtpBloc instance
  static SendOtpBloc get sendOtpBloc => BaseBinding.get<SendOtpBloc>();

  static VerifyOtpBloc get verifyOtpBloc => BaseBinding.get<VerifyOtpBloc>();

  /// Reset all auth dependencies
  static Future<void> reset() async {
    await BaseBinding.reset();
  }

  /// Check if auth dependencies are registered
  static bool get isInitialized => BaseBinding.isRegistered<AuthRepository>();
}