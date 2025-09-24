import 'package:boiler_plater_flutter_v3/core/error/either.dart';
import 'package:boiler_plater_flutter_v3/core/error/failures.dart';
import 'package:boiler_plater_flutter_v3/features/auth/data/dataSource/auth_remote_data_source.dart';
import 'package:boiler_plater_flutter_v3/features/auth/domain/entities/user_info_entity.dart';
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

  @override
  Future<Either<Failure, UserInfoEntity>> verifyOtp(String phone, String otp
      ) async {
    final result = await dataSource.verifyOtp(phone: phone,otp: otp);

    return result.fold((failure) => Either.left(failure), (response) {
      if (response.isSuccess) {
        return Either.right(UserInfoEntity.fromJson(response.data));
      } else {
        return Either.left(
          ValidationFailure(
            message: response.message ?? 'Failed to verify OTP',
            statusCode: response.statusCode,
          ),
        );
      }
    });
  }
}
