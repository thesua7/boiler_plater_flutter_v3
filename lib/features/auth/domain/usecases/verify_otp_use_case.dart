import 'package:boiler_plater_flutter_v3/core/error/either.dart';
import 'package:boiler_plater_flutter_v3/core/error/failures.dart';
import 'package:boiler_plater_flutter_v3/features/auth/domain/entities/user_info_entity.dart';

import '../repository/auth_repository.dart';

class VerifyOtpParams {
  final String phone;
  final String otp;
  VerifyOtpParams({required this.phone, required this.otp});
}

class VerifyOtpUseCase {
  final AuthRepository repository;
  VerifyOtpUseCase({required this.repository});

  Future<Either<Failure, UserInfoEntity>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.phone, params.otp);
  }
}