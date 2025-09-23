import 'package:equatable/equatable.dart';

/// Send OTP States
abstract class SendOtpState extends Equatable {
  const SendOtpState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SendOtpInitial extends SendOtpState {
  const SendOtpInitial();
}

/// Loading state
class SendOtpLoading extends SendOtpState {
  const SendOtpLoading();
}

/// Success state
class SendOtpSuccess extends SendOtpState {
  final String message;

  const SendOtpSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Error state
class SendOtpError extends SendOtpState {
  final String message;

  const SendOtpError({required this.message});

  @override
  List<Object?> get props => [message];
}
