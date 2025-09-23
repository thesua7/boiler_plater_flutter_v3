import 'package:boiler_plater_flutter_v3/core/error/either.dart';
import 'package:boiler_plater_flutter_v3/core/error/failures.dart';
import 'package:boiler_plater_flutter_v3/features/auth/data/dataSource/auth_remote_data_source.dart';
import 'package:boiler_plater_flutter_v3/features/auth/domain/repository/auth_repository.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;

  AuthRepoImpl({required this.dataSource});

  @override
  Future<Either<Failure, String>> sendOtp(String phone) async {
    final result = await dataSource.sendOtp(phone: phone);

    return result.fold((failure) => Either.left(failure), (response) {
      if (response.isSuccess) {
        return Either.right(response.message ?? 'OTP sent successfully');
      } else {
        return Either.left(
          ValidationFailure(
            message: response.message ?? 'Failed to send OTP',
            statusCode: response.statusCode,
          ),
        );
      }
    });
  }
}
