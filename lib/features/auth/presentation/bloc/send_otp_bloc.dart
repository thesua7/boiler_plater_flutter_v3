import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/send_otp_use_case.dart';
import 'send_otp_event.dart';
import 'send_otp_state.dart';

/// Send OTP BLoC
class SendOtpBloc extends Bloc<SendOtpEvent, SendOtpState> {
  final SendOtpUseCase sendOtpUseCase;

  SendOtpBloc({required this.sendOtpUseCase}) : super(const SendOtpInitial()) {
    on<SendOtpRequested>(_onSendOtpRequested);
    on<SendOtpReset>(_onSendOtpReset);
  }

  /// Handle send OTP request
  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<SendOtpState> emit,
  ) async {
    emit(const SendOtpLoading());

    final result = await sendOtpUseCase.call(
      SendOtpParams(phone: event.phoneNumber),
    );

    result.fold(
      (failure) => emit(SendOtpError(message: failure.message ?? 'An error occurred')),
      (message) => emit(SendOtpSuccess(message: message)),
    );
  }

  /// Handle reset event
  void _onSendOtpReset(
    SendOtpReset event,
    Emitter<SendOtpState> emit,
  ) {
    emit(const SendOtpInitial());
  }

}
