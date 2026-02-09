import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class ApiProvider extends GetxService {
  static const String appVersion = "1.0.0";

  static const String rootUrl = "https://anggotaperadi.or.id";

  static const String imageUrl = "$rootUrl/storage";
  static const String baseUrl = "$rootUrl/api";

  late dio.Dio _dio;

  Future<ApiProvider> init() async {
    dio.BaseOptions options = dio.BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    _dio = dio.Dio(options);

    // ================
    // 🔐 Interceptor Token Sanctum
    // ================
    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        // =====================
        // 🔥 HANDLE 401 UNAUTHENTICATED
        // =====================
        onError: (dio.DioException e, handler) async {
          return handler.next(e);
        },
      ),
    );

    // Logger saat debug
    if (kDebugMode) {
      _dio.interceptors.add(
        dio.LogInterceptor(requestBody: true, responseBody: true),
      );
    }

    return this;
  }

  dio.Dio get client => _dio;

  // =====================
  // GET
  // =====================
  Future<dio.Response> get(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    try {
      return await _dio.get(endpoint, queryParameters: query);
    } on dio.DioException catch (e) {
      throw _handleError(e);
    }
  }

  // =====================
  // POST
  // =====================
  Future<dio.Response> post(
    String endpoint, {
    dynamic data, // bisa JSON atau FormData
    dio.Options? options,
  }) async {
    try {
      return await _dio.post(endpoint, data: data, options: options);
    } on dio.DioException catch (e) {
      throw _handleError(e);
    }
  }

  // =====================
  // ERROR HANDLER
  // =====================
  Exception _handleError(dio.DioException e) {
    if (e.response != null) {
      return Exception("Error ${e.response?.statusCode}: ${e.response?.data}");
    } else {
      return Exception("Network error: ${e.message}");
    }
  }
}
