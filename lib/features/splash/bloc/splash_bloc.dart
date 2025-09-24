import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/storage_constant.dart';
import '../../../../core/data/sharedPref/secure_storage.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashInitial()) {
    on<CheckAuthenticationStatus>(_onCheckAuthenticationStatus);
  }

  Future<void> _onCheckAuthenticationStatus(
    CheckAuthenticationStatus event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoading());

    try {
      // Add a minimum splash duration for better UX
      await Future.delayed(const Duration(seconds: 2));

      // Check if user is logged in and has access token
      final isLoggedIn = await SecureStorageHelper.read(StorageConstant.isLoggedIn);
      final accessToken = await SecureStorageHelper.read(StorageConstant.accessToken);

      // Both conditions must be true for authentication
      if (isLoggedIn == "1" && accessToken != null && accessToken.isNotEmpty) {
        emit(const SplashAuthenticated());
      } else {
        // Clear any invalid data
        await _clearInvalidAuthData();
        emit(const SplashUnauthenticated());
      }
    } catch (e) {
      // On error, clear auth data and go to login
      await _clearInvalidAuthData();
      emit(SplashError(message: 'Authentication check failed: ${e.toString()}'));
    }
  }

  /// Clear invalid authentication data
  Future<void> _clearInvalidAuthData() async {
    try {
      await SecureStorageHelper.delete(StorageConstant.isLoggedIn);
      await SecureStorageHelper.delete(StorageConstant.accessToken);
      await SecureStorageHelper.delete(StorageConstant.refreshToken);
    } catch (e) {
      // Ignore errors when clearing data
    }
  }
}
