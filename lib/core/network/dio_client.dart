import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/env_config.dart';
import '../config/api_constants.dart';

/// Dio client for making HTTP requests
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiBaseUrl,
        connectTimeout: EnvConfig.connectTimeout,
        receiveTimeout: EnvConfig.receiveTimeout,
        sendTimeout: EnvConfig.sendTimeout,
        headers: {
          ApiConstants.contentType: ApiConstants.applicationJson,
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
            print('Headers: ${options.headers}');
            if (options.data != null) {
              print('Data: ${options.data}');
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
            print('Data: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
            print('Message: ${error.message}');
            print('Response: ${error.response?.data}');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  /// Set authorization token
  void setToken(String token) {
    _dio.options.headers[ApiConstants.authorization] = ApiConstants.bearerToken(token);
  }

  /// Remove authorization token
  void removeToken() {
    _dio.options.headers.remove(ApiConstants.authorization);
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handler
  Exception _handleError(DioException error) {
    String message;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.badResponse:
        message = _handleStatusCode(error.response?.statusCode);
        if (error.response?.data != null && error.response?.data is Map) {
          final data = error.response?.data as Map;
          if (data.containsKey('message')) {
            message = data['message'].toString();
          }
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;
      default:
        message = 'Something went wrong. Please try again.';
    }

    return Exception(message);
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 409:
        return 'Conflict. Resource already exists.';
      case 500:
        return 'Internal server error';
      case 503:
        return 'Service unavailable';
      default:
        return 'Something went wrong';
    }
  }
}
