import '../../../../core/error/either.dart';
import '../../../../core/error/failures.dart';


abstract class AuthRepository {


  Future<Either<Failure, String>> sendOtp(String phone);
  Future<Either<Failure, String>> verifyOtp(String phone,String otp);




}