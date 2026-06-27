import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// REST API client — ready for backend integration.
class ApiClient {
  ApiClient({String? baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? 'https://api.acttconnect.com/v1',
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Attach auth token when available
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;
  Dio get dio => _dio;

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

/// API endpoint constants.
abstract final class ApiEndpoints {
  static const String login = '/auth/login';
  static const String customers = '/customers';
  static const String suppliers = '/suppliers';
  static const String products = '/products';
  static const String invoices = '/invoices';
  static const String purchases = '/purchases';
  static const String payments = '/payments';
  static const String reports = '/reports';
  static const String dashboard = '/dashboard/stats';
}
