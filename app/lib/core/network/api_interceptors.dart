import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage.dart';
import '../errors/exceptions.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _secureStorage.deleteToken();
    }
    return handler.next(err);
  }
}

class ErrorInterceptor extends Interceptor {
  String _extractErrorMessage(dynamic data) {
    if (data is Map) {
      if (data['detail'] != null) {
        if (data['detail'] is String) {
          return data['detail'] as String;
        } else if (data['detail'] is List && (data['detail'] as List).isNotEmpty) {
          final first = (data['detail'] as List).first;
          if (first is Map && first['msg'] != null) {
            return first['msg'].toString();
          }
          return first.toString();
        }
      }
      if (data['message'] != null) {
        return data['message'].toString();
      }
    }
    return 'Server error';
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        throw NetworkException('Connection failed. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final data = err.response?.data;
        final message = _extractErrorMessage(data);
        
        if (statusCode == 401) {
          throw AuthException(message);
        } else if (statusCode == 422) {
          throw ValidationException(message, errors: data is Map ? data['detail'] as Map<String, dynamic>? : null);
        } else if (statusCode != null && statusCode >= 500) {
          throw ServerException(message, code: statusCode.toString());
        } else {
          throw ServerException(message, code: statusCode?.toString(), data: data);
        }
      case DioExceptionType.cancel:
        throw ServerException('Request cancelled');
      default:
        throw ServerException('Something went wrong. Please try again.');
    }
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('➡️ REQUEST[${options.method}] => PATH: ${options.path}');
    debugPrint('Headers: ${options.headers}');
    if (options.data != null) debugPrint('Data: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('⬅️ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    debugPrint('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    debugPrint('Message: ${err.message}');
    super.onError(err, handler);
  }
}
