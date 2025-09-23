import '../error/either.dart';
import '../error/failures.dart';
import '../error/network_exceptions.dart';

/// Base use case class
abstract class BaseUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params) async {
    try {
      return await execute(params);
    } catch (e) {
      return Either.left(_handleError(e));
    }
  }

  /// Execute the use case logic
  Future<Either<Failure, Type>> execute(Params params);

  /// Handle errors using existing error handling
  Failure _handleError(dynamic error) {
    if (error is Failure) {
      return error;
    } else if (error is AppException) {
      return ExceptionHandler.exceptionToFailure(error);
    } else {
      return UnknownFailure(
        message: error.toString(),
        statusCode: 0,
      );
    }
  }
}
