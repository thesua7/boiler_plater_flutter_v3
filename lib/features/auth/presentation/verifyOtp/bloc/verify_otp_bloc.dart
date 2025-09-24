import 'package:boiler_plater_flutter_v3/core/constants/storage_constant.dart';
import 'package:boiler_plater_flutter_v3/features/auth/presentation/verifyOtp/bloc/verify_otp_event.dart';
import 'package:boiler_plater_flutter_v3/features/auth/presentation/verifyOtp/bloc/veriy_otp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/data/sharedPref/secure_storage.dart';
import '../../../domain/usecases/verify_otp_use_case.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;

  VerifyOtpBloc({required this.verifyOtpUseCase}) : super(VerifyOtpInitial()) {
    on<VerifyOtp>(_onVerifyOtp);
    on<VerifyOtpResend>(_onVerifyOtpResend);
  }

  Future<void> _onVerifyOtp(
    VerifyOtp event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(VerifyOtpLoading());
    
    try {
      final result = await verifyOtpUseCase.call(
        VerifyOtpParams(phone: event.phone, otp: event.otp),
      );
      
      await result.fold(
        (failure) async {
          // Handle specific error cases
          String errorMessage = failure.message ?? 'An error occurred';
          
          // // Check if it's an OTP expired error
          // if (failure.statusCode == 403 &&
          //     (errorMessage.toLowerCase().contains('expired') ||
          //      errorMessage.toLowerCase().contains('invalid'))) {
          //   errorMessage = 'Your OTP has expired. Please request a new one.';
          // }
          //
          emit(VerifyOtpError(message: errorMessage));
        },
        (user) async {
          try {
            // Save token to secure storage
            await SecureStorageHelper.write(StorageConstant.accessToken, user.token);
            await SecureStorageHelper.write(StorageConstant.isLoggedIn, "1"); // 1 means true & 0 means false
            // Emit success state after token is saved
            emit(VerifyOtpSuccess(user: user));
          } catch (e) {
            // If token saving fails, still emit success but log the error
            emit(VerifyOtpSuccess(user: user));
          }
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      emit(VerifyOtpError(message: 'An unexpected error occurred. Please try again.'));
    }
  }

  void _onVerifyOtpResend(
    VerifyOtpResend event,
    Emitter<VerifyOtpState> emit,
  ) {
    emit(VerifyOtpInitial());
  }
}
