/// API Constants for different environments
class ApiConstants {
  // Base URLs for different environments
  static const String devBaseUrl = 'https://karmasangsthan.com.bd';
  static const String stagingBaseUrl = 'https://karmasangsthan.com.bd';
  static const String productionBaseUrl = 'https://karmasangsthan.com.bd';

  // API Endpoints
  static const String _apiVersion = '/api/v2';

  // Authentication endpoints
  static String get login => '$_apiVersion/auth/login';
  static String get sendOtp => '$_apiVersion/auth/sent-otp';


  
  static String get register => '$_apiVersion/auth/register';
  static String get refreshToken => '$_apiVersion/auth/refresh';
  static String get logout => '$_apiVersion/auth/logout';
  static String get forgotPassword => '$_apiVersion/auth/forgot-password';
  static String get resetPassword => '$_apiVersion/auth/reset-password';
  static String get verifyEmail => '$_apiVersion/auth/verify-email';



  // Request timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryInterval = Duration(seconds: 2);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File upload limits
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  static const List<String> allowedFileTypes = ['pdf', 'doc', 'docx', 'txt', 'zip'];

  // API Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Cache configuration
  static const Duration cacheExpiration = Duration(minutes: 5);
  static const int maxCacheSize = 50; // MB
}

/// App environment enumeration
enum AppEnvironment {
  dev,
  staging,
  production,
}

/// API Response status codes
class ApiStatusCodes {
  static const int success = 200;
  static const int created = 201;
  static const int noContent = 204;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;
  static const int internalServerError = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
}

/// API Error messages
class ApiErrorMessages {
  static const String networkError = 'Network error. Please check your connection.';
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unauthorizedError = 'Unauthorized. Please login again.';
  static const String forbiddenError = 'Access denied.';
  static const String notFoundError = 'Resource not found.';
  static const String validationError = 'Validation error.';
  static const String unknownError = 'An unknown error occurred.';
}
