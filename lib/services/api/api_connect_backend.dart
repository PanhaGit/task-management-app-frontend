import 'package:dio/dio.dart';
import 'package:frontend_app_task/util/env.dart';

class ApiConnectBackend {
  final Dio _dio;
  static const int receiveTimeout = 15000;
  static const int connectTimeout = 15000;
  static const int sendTimeout = 15000;

  ApiConnectBackend({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: Env.BASE_URL, // Access the static field directly
      connectTimeout: const Duration(milliseconds: connectTimeout),
      receiveTimeout: const Duration(milliseconds: receiveTimeout),
      sendTimeout: const Duration(milliseconds: sendTimeout),
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
  /// @author Tho Panha
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
      final response = await _dio.request<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          headers: headers,
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiException(
          message: e.response?.data['message'] ?? 'Server error occurred',
          statusCode: e.response?.statusCode ?? 500,
        );
      } else {
        throw ApiException(
          message: e.message ?? 'Network error occurred',
          statusCode: 0,
        );
      }
    } catch (e) {
      throw ApiException(
        message: 'Unexpected error occurred: $e',
        statusCode: 0,
      );
    }
  }

  /// Simplified GET request
  Future<Response<T>> fetchData<T>({
    String method = "GET",
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return request<T>(
      method: method,
      endpoint: endpoint,
      queryParameters: queryParameters,
      headers: headers,
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

/**
 *
 * Example used
 * // Initialize
    final apiService = ApiService();

    // GET request
    try {
    final response = await apiService.get<Map<String, dynamic>>('/users');
    print(response.data);
    } on ApiException catch (e) {
    print(e);
    }

    // POST request
    try {
    final response = await apiService.post<Map<String, dynamic>>(
    '/users',
    data: {'name': 'Vibol Sava'},
    );
    print(response.data);
    } on ApiException catch (e) {
    print(e);
    }
 *
 * */