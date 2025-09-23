import 'package:boiler_plater_flutter_v3/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/error/either.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/base_usecase.dart';


/// Login use case parameters
class SendOtpParams {
  final String phone;

  const SendOtpParams({
    required this.phone,
  });
}

/// Login use case
class SendOtpUseCase extends BaseUseCase<String, SendOtpParams> {
  final AuthRepository repository;
  SendOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> execute(SendOtpParams params) async {
    return await repository.sendOtp(params.phone);
  }
}