import 'package:boiler_plater_flutter_v3/core/error/either.dart';
import 'package:boiler_plater_flutter_v3/core/error/failures.dart';
import 'package:boiler_plater_flutter_v3/core/usecase/base_usecase.dart';

import '../repository/auth_repository.dart';


class VerifyOtpParams{
  final String phone;
  final String otp;
  VerifyOtpParams({required this.phone,required this.otp});
}
class VerifyOtpUseCase extends BaseUseCase<String,VerifyOtpParams>{
  final AuthRepository repository;
  VerifyOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> execute(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.phone, params.otp);
  }


}