
import 'package:boiler_plater_flutter_v3/features/auth/domain/entities/user_info_entity.dart';
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
  final UserInfoEntity user;
  const VerifyOtpSuccess({required this.user});
}

class VerifyOtpError extends VerifyOtpState {
  final String message;
  const VerifyOtpError({required this.message});
}