import 'package:boiler_plater_flutter_v3/core/data/network/base_api_service.dart';

import '../../../../core/constants/api_constant.dart';
import '../../../../core/data/network/response/base_response.dart';
import '../../../../core/error/either.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/network_exceptions.dart';

class AuthRemoteDataSource extends BaseApiService {
  Future<Either<Failure, BaseResponse>> sendOtp({required String phone}) async {
    try {
      final response = await sendRequest(
        url: ApiConstants.sendOtp,
        params: {'phone': phone},
        method: HttpMethod.POST,
      );
      return Either.right(response);
    } catch (e) {
      if (e is AppException) {
        final failure = ExceptionHandler.exceptionToFailure(e);
        return Either.left(failure);
      } else {
        return Either.left(UnknownFailure(message: e.toString()));
      }
    }
  }

  Future<Either<Failure, BaseResponse>> verifyOtp({required String phone,required String otp}) async {
    try {
      final response = await sendRequest(
        url: ApiConstants.login,
        params: {'phone': phone,
        'otp':otp},
        method: HttpMethod.POST,
      );
      return Either.right(response);
    } catch (e) {
      if (e is AppException) {
        final failure = ExceptionHandler.exceptionToFailure(e);
        return Either.left(failure);
      } else {
        return Either.left(UnknownFailure(message: e.toString()));
      }
    }
  }
}