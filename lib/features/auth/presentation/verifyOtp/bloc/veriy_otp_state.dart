
import 'package:equatable/equatable.dart';

abstract class VerifyOtpState extends Equatable{
  const VerifyOtpState();
  @override
  List<Object?> get props => [];

}

class VerifyOtpInitial extends VerifyOtpState{
  const VerifyOtpInitial();

}

class VerifyOtpLoading extends VerifyOtpState {
  const VerifyOtpLoading();

}

class VerifyOtpSuccess extends VerifyOtpState {
  final String message;
  const VerifyOtpSuccess({required this.message});
}

class VerifyOtpError extends VerifyOtpState {
  final String message;
  const VerifyOtpError({required this.message});
}