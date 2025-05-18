import 'package:dio/dio.dart';
import 'package:frontend_app_task/env.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio;
  static const int receiveTimeout = 15000;
  static const int connectTimeout = 15000;
  static const int sendTimeout = 15000;

  final FlutterSecureStorage _storage = const FlutterSecureStorage(); // Secure storage instance

  ApiService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: Env.BASE_URL,
      connectTimeout: Duration(milliseconds: connectTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      sendTimeout: Duration(milliseconds: sendTimeout),
      headers: {
        'Content-Type': 'application/json', // Default header for all requests
        'Accept': 'application/json',
      },
    );

    // Add interceptors if needed - moved inside the constructor
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  /// Generic HTTP request method
  /// [method] HTTP method (GET, POST, PUT, DELETE, etc.)
  /// [endpoint] API endpoint
  /// [data] Request body
  /// [queryParameters] Query parameters
  /// [headers] Additional headers
  Future<Response<T>> request<T>({
    required String method,
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      // Read access token from secure storage
      final token = await _storage.read(key: 'access_token');

      // Merge headers (preserve existing + auth if token exists)
      final Map<String, dynamic> allHeaders = {
        ...?_dio.options.headers, // Include default headers
        if (headers != null) ...headers,
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await _dio.request<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          headers: allHeaders,
        ),
      );
      return response;
    } on DioException catch (e) {
      // Handle Dio-specific errors (timeout, network, etc.)
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        throw ApiException(
          message: 'Request timeout. Please try again.',
          statusCode: 408, // 408 = Request Timeout
        );
      } else if (e.response != null) {
        // Handle server errors (4xx, 5xx)
        throw ApiException(
          message: e.response?.data['message'] ?? 'Server error occurred',
          statusCode: e.response?.statusCode ?? 500,
        );
      } else {
        // Handle other Dio errors (no connection, etc.)
        throw ApiException(
          message: e.message ?? 'Network error occurred',
          statusCode: 0,
        );
      }
    } catch (e) {
      // Fallback for unexpected errors
      throw ApiException(
        message: 'Unexpected error occurred: $e',
        statusCode: 0,
      );
    }
  }

  /// Simplified GET request
  Future<Response<T>> fetchData<T>({
    String method = "GET", // post /put / delete
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    dynamic data,
  }) async {
    return request<T>(
      method: method,
      endpoint: endpoint,
      queryParameters: queryParameters,
      headers: headers,
      data: data,
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status code: $statusCode)';
}