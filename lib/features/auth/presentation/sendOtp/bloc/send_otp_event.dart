import 'package:equatable/equatable.dart';

/// Send OTP Events
abstract class SendOtpEvent extends Equatable {
  const SendOtpEvent();

  @override
  List<Object?> get props => [];
}

/// Event to send OTP to phone number
class SendOtpRequested extends SendOtpEvent {
  final String phoneNumber;

  const SendOtpRequested({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

/// Event to reset the form
class SendOtpReset extends SendOtpEvent {
  const SendOtpReset();
}
