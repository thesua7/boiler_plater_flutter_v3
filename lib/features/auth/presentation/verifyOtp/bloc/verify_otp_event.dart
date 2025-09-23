import 'package:equatable/equatable.dart';

abstract class VerifyOtpEvent extends Equatable{
  const VerifyOtpEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class VerifyOtp extends VerifyOtpEvent{
  final String phone;
  final String otp;
  const VerifyOtp({required this.phone,required this.otp});
  @override
  List<Object?> get props => [phone,otp];

}

class VerifyOtpResend extends VerifyOtpEvent{
  const VerifyOtpResend();

}
