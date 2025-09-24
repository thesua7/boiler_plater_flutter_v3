import 'package:dio/dio.dart';
import 'failures.dart';

/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;

  const AppException({
    required this.message,
    this.statusCode,
    this.code,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Network exception
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.statusCode,
    super.code,
  });
}

/// Server exception
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.code,
  });
}

/// Authentication exception
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.statusCode,
    super.code,
  });
}

/// Validation exception
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.statusCode,
    super.code,
  });
}

/// Cache exception
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.statusCode,
    super.code,
  });
}

/// Unknown exception
class UnknownException extends AppException {
  const UnknownException({
    required super.message,
    super.statusCode,
    super.code,
  });
}

/// Exception handler utility
class ExceptionHandler {
  /// Convert DioException to AppException
  static AppException handleDioException(dynamic e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkException(
            message: 'Connection timeout. Please check your internet connection.',
            statusCode: 408,
            code: 'TIMEOUT',
          );

        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode ?? 500;
          final responseData = e.response?.data;
          
          // Try to extract the actual error message from the response
          String message = _getErrorMessageFromStatusCode(statusCode);
          if (responseData is Map<String, dynamic>) {
            final apiMessage = responseData['message'];
            if (apiMessage != null && apiMessage.toString().isNotEmpty) {
              message = apiMessage.toString();
            }
          }
          
          return ServerException(
            message: message,
            statusCode: statusCode,
            code: 'HTTP_$statusCode',
          );

        case DioExceptionType.cancel:
          return NetworkException(
            message: 'Request was cancelled',
            statusCode: 0,
            code: 'CANCELLED',
          );

        case DioExceptionType.connectionError:
          return NetworkException(
            message: 'Connection error. Please check your internet connection.',
            statusCode: 0,
            code: 'CONNECTION_ERROR',
          );

        case DioExceptionType.badCertificate:
          return NetworkException(
            message: 'Certificate error',
            statusCode: 0,
            code: 'CERTIFICATE_ERROR',
          );

        case DioExceptionType.unknown:
        default:
          return UnknownException(
            message: 'An unknown error occurred',
            statusCode: 0,
            code: 'UNKNOWN',
          );
      }
    }

    return UnknownException(
      message: e.toString(),
      statusCode: 0,
      code: 'UNKNOWN',
    );
  }

  /// Get error message from status code
  static String _getErrorMessageFromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'Resource not found.';
      case 422:
        return 'Validation error. Please check your input.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      case 504:
        return 'Gateway timeout. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  /// Convert AppException to Failure
  static Failure exceptionToFailure(AppException exception) {
    if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    } else if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    } else if (exception is CacheException) {
      return CacheFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    } else {
      return UnknownFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    }
  }
}