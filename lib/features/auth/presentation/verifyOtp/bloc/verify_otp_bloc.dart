import 'package:boiler_plater_flutter_v3/features/auth/presentation/verifyOtp/bloc/verify_otp_event.dart';
import 'package:boiler_plater_flutter_v3/features/auth/presentation/verifyOtp/bloc/veriy_otp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final result = await verifyOtpUseCase.call(
      VerifyOtpParams(phone: event.phone, otp: event.otp),
    );
    result.fold(
      (failure) =>
          emit(VerifyOtpError(message: failure.message ?? 'An error occurred')),
      (message) => emit(VerifyOtpSuccess(message: message)),
    );
  }

  void _onVerifyOtpResend(
    VerifyOtpResend event,
    Emitter<VerifyOtpState> emit,
  ) {
    emit(VerifyOtpInitial());
  }
}
