import 'dart:async';
import 'package:dio/dio.dart';
import '../../config/app_config.dart';
import 'response/base_response.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import '../../error/network_exceptions.dart';

/// HTTP Methods enum
enum HttpMethod { GET, POST, PATCH, PUT, DELETE }

/// Base API Service
class BaseApiService {
  late final Dio dio;

  BaseApiService() {
    dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
    ));
    
    // Add your existing interceptors
    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
      RetryInterceptor(dio: dio),
    ]);
  }

  /// Send HTTP request
  Future<BaseResponse> sendRequest({
    required String url,
    Map<String, dynamic>? params,
    HttpMethod method = HttpMethod.POST,
  }) async {
    print('[API] Request: $method $url');
    if (params != null) print('[API] Params: $params');
    try {
      Response response;
      switch (method) {
        case HttpMethod.POST:
          response = await dio.post(url, data: params);
          break;
        case HttpMethod.PATCH:
          response = await dio.patch(url, data: params);
          break;
        case HttpMethod.GET:
          response = await dio.get(url, queryParameters: params);
          break;
        case HttpMethod.PUT:
          response = await dio.put(url, data: params);
          break;
        case HttpMethod.DELETE:
          response = await dio.delete(url, queryParameters: params);
          break;
      }
      print('[API] Response: ${response.statusCode} ${response.data}');
      return BaseResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('[API] ERROR: ${e.response?.statusCode}');
      print('[API] ERROR BODY: ${e.response?.data}');
      if (e.response?.data is Map<String, dynamic>) {
        final err = e.response?.data;
        print('[API] ERROR MESSAGE: ${err['message']}');
        print('[API] ERROR ERRORS: ${err['errors'] ?? err['error']}');
      }
      
      // Convert DioException to AppException
      final appException = ExceptionHandler.handleDioException(e);
      throw appException;
    }
  }

  /// Uploads files and fields as multipart/form-data.
  Future<BaseResponse> uploadMultipart({
    required String url,
    Map<String, dynamic>? fields,
    Map<String, List<MultipartFile>>? fileMap,
    HttpMethod method = HttpMethod.POST,
  }) async {
    final formData = FormData();

    // Add text fields
    fields?.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    // Add files with dynamic field names
    if (fileMap != null && fileMap.isNotEmpty) {
      for (final entry in fileMap.entries) {
        final fieldName = entry.key;
        final files = entry.value;
        for (final file in files) {
          formData.files.add(MapEntry(fieldName, file));
        }
      }
    }

    print('[API] Multipart Request: $method $url');
    print('[API] Fields: $fields');
    print('[API] Files: ${fileMap?.map((k, v) => MapEntry(k, v.map((f) => f.filename).toList()))}');

    final Options options = Options(
      method: method.name,
    );

    try {
      final response = await dio.request(
        url,
        data: formData,
        options: options,
      );
      print('[API] Multipart Response: ${response.statusCode} ${response.data}');
      return BaseResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('[API] MULTIPART ERROR: ${e.response?.statusCode}');
      print('[API] MULTIPART ERROR BODY: ${e.response?.data}');
      if (e.response?.data is Map<String, dynamic>) {
        final err = e.response?.data;
        print('[API] ERROR MESSAGE: ${err['message']}');
        print('[API] ERROR ERRORS: ${err['errors'] ?? err['error']}');
      }
      
      // Convert DioException to AppException
      final appException = ExceptionHandler.handleDioException(e);
      throw appException;
    }
  }

}