import 'package:boiler_plater_flutter_v3/features/auth/domain/entities/user_info_entity.dart';

import '../../../../core/error/either.dart';
import '../../../../core/error/failures.dart';


abstract class AuthRepository {


  Future<Either<Failure, String>> sendOtp(String phone);
  Future<Either<Failure, UserInfoEntity>> verifyOtp(String phone,String otp);




}