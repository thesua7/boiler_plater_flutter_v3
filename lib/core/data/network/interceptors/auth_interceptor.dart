import 'package:dio/dio.dart';
import '../../sharedPref/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    try {
      final String? token = await SecureStorageHelper.read(_accessTokenKey);
      if (token != null && token.isNotEmpty) {
        options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
      }
    } catch (e) {
      // Log error but don't block the request
      print('Error reading access token: $e');
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    // Handle 401 Unauthorized - token might be expired
    if (err.response?.statusCode == 401) {
      try {
        final String? refreshToken = await SecureStorageHelper.read(_refreshTokenKey);
        if (refreshToken != null && refreshToken.isNotEmpty) {
          // Try to refresh the token
          final bool refreshSuccess = await _refreshAccessToken(refreshToken);
          if (refreshSuccess) {
            // Retry the original request with new token
            final String? newToken = await SecureStorageHelper.read(_accessTokenKey);
            if (newToken != null && newToken.isNotEmpty) {
              err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              // Retry the request
              try {
                final response = await Dio().fetch(err.requestOptions);
                return handler.resolve(response);
              } catch (e) {
                // If retry fails, continue with original error
              }
            }
          }
        }
      } catch (e) {
        print('Error during token refresh: $e');
      }
    }

    super.onError(err, handler);
  }

  /// Refresh access token using refresh token
  Future<bool> _refreshAccessToken(String refreshToken) async {
    try {
      // TODO: Implement your token refresh logic here
      // This is a placeholder - you'll need to implement the actual API call
      // to your backend's refresh token endpoint
      
      // Example implementation:
      // final response = await Dio().post(
      //   '${ApiConstants.baseUrl}/auth/refresh',
      //   data: {'refresh_token': refreshToken},
      // );
      // 
      // if (response.statusCode == 200) {
      //   final newAccessToken = response.data['access_token'];
      //   await SecureStorageHelper.write(_accessTokenKey, newAccessToken);
      //   return true;
      // }
      
      return false;
    } catch (e) {
      print('Token refresh failed: $e');
      return false;
    }
  }
}