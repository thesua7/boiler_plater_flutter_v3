/// Base response model for API responses
class BaseResponse {
  final bool success;
  final String? message;
  final dynamic data;
  final Map<String, dynamic>? errors;
  final int? statusCode;
  final String? code;

  BaseResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.statusCode,
    this.code,
  });

  /// Create from JSON
  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      success: json['success'] ?? json['status'] == 'success' || json['status'] == 200 || true, // JSONPlaceholder always succeeds
      message: json['message'] ?? json['msg'],
      data: json['data'] ?? json['result'] ?? json, // JSONPlaceholder returns data directly
      errors: json['errors'] ?? json['error'],
      statusCode: json['status_code'] ?? json['code'] ?? 200,
      code: json['code']?.toString(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'errors': errors,
      'status_code': statusCode,
      'code': code,
    };
  }

  /// Check if response is successful
  bool get isSuccess => success;

  /// Check if response has errors
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  /// Get first error message
  String? get firstError {
    if (errors == null || errors!.isEmpty) return null;
    final firstError = errors!.values.first;
    if (firstError is List && firstError.isNotEmpty) {
      return firstError.first.toString();
    }
    return firstError.toString();
  }

  /// Get all error messages
  List<String> get allErrors {
    if (errors == null || errors!.isEmpty) return [];
    
    final errorList = <String>[];
    errors!.forEach((key, value) {
      if (value is List) {
        errorList.addAll(value.map((e) => e.toString()));
      } else {
        errorList.add(value.toString());
      }
    });
    
    return errorList;
  }

  @override
  String toString() {
    return 'BaseResponse(success: $success, message: $message, data: $data, errors: $errors, statusCode: $statusCode, code: $code)';
  }
}
