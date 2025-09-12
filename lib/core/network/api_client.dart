import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:foxxhealth/core/network/api_logger_interceptor.dart';
import 'package:foxxhealth/core/utils/app_storage.dart';
import 'package:foxxhealth/features/presentation/screens/loginScreen/login_screen.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  static final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  static final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://fastapi-backend-v2-788993188947.us-central1.run.app',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Remove this line
    // dio.addSentry();

    dio.interceptors.add(LoggerInterceptor());
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(ApiLoggerInterceptor());
    
    // Load credentials from storage on initialization
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    await AppStorage.loadCredentials();
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.delete(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = options.headers['Authorization'] as String?;

    ApiClient.logger
        .i('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
    ApiClient.logger.d(
        '📋 Headers: {Content-Type: ${options.headers['Content-Type']}, Accept: ${options.headers['Accept']}}');
    ApiClient.logger.d('🔑 Token: ${token ?? 'No token'}');

    if (options.data != null) {
      final sanitizedData = _sanitizeData(options.data);
      ApiClient.logger.d('📦 Request Data: $sanitizedData');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    ApiClient.logger.i(
        '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');

    final sanitizedData = _sanitizeData(response.data);
    ApiClient.logger.d('📄 Response Data: $sanitizedData');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    ApiClient.logger.e(
      '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      error: err.error,
      stackTrace: err.stackTrace,
    );

    if (err.response?.statusCode == 401) {
      // Only clear credentials and redirect to login for certain endpoints
      // Don't clear credentials for onboarding endpoint as it might be a server-side issue
      final path = err.requestOptions.path;
      if (!path.contains('/api/v1/accounts/me/onboarding')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        GetStorage().erase();
        // Clear AppStorage
        await AppStorage.clearCredentials();
        Navigator.of(getx.Get.context!).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LoginScreen(
                showBackButton: false,
                isSign: true,
              ),
            ),
            (route) => false);
      } else {
        ApiClient.logger.w('⚠️ 401 error on onboarding endpoint - not clearing credentials');
      }
    }

    if (err.response?.data != null) {
      final sanitizedData = _sanitizeData(err.response?.data);
      ApiClient.logger.e('🚫 Error Response Data: $sanitizedData');
    }
    super.onError(err, handler);
  }

  Map<String, dynamic> _sanitizeData(dynamic data) {
    if (data is Map) {
      final sanitized = Map<String, dynamic>.from(data);
      if (sanitized.containsKey('password')) {
        sanitized['password'] = '******';
      }
      return sanitized;
    }
    return {'data': data.toString()};
  }
}

class AuthInterceptor extends Interceptor {
  // List of endpoints that don't require authentication
  static const List<String> _noAuthEndpoints = [

    '/api/v1/auth/register',
    '/api/v1/auth/login',
  ];

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Check if this endpoint requires authentication
    final requiresAuth = !_noAuthEndpoints.any((endpoint) => 
        options.path.contains(endpoint));
    
    ApiClient.logger.d('🔍 AuthInterceptor - Path: ${options.path}');
    ApiClient.logger.d('🔍 AuthInterceptor - Requires Auth: $requiresAuth');
    ApiClient.logger.d('🔍 AuthInterceptor - No Auth Endpoints: $_noAuthEndpoints');
    
    if (requiresAuth) {
      final token = AppStorage.accessToken;
      ApiClient.logger.d('🔍 AuthInterceptor - Token from AppStorage: ${token != null ? "Present (${token.length} chars)" : "NULL"}');
      
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        ApiClient.logger.d('🔍 AuthInterceptor - Authorization header set: Bearer ${token.substring(0, 20)}...');
      } else {
        ApiClient.logger.w('⚠️ AuthInterceptor - No token available for authenticated endpoint');
      }
    } else {
      ApiClient.logger.d('🔍 AuthInterceptor - Skipping auth for endpoint: ${options.path}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final path = err.requestOptions.path;
      if (!path.contains('/api/v1/accounts/me/onboarding')) {
        await AppStorage.clearCredentials();
        ApiClient.logger.w('🔑 Token expired or invalid. Clearing credentials.');
      } else {
        ApiClient.logger.w('🔑 401 error on onboarding endpoint - not clearing credentials in AuthInterceptor');
      }
    }
    super.onError(err, handler);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = 'An error occurred';

    if (err.response?.statusCode == 401) {
      errorMessage = 'Session has expired please login again';
    } else if (err.response?.data != null && err.response?.data is Map) {
      errorMessage = err.response?.data['detail'] ??
          err.response?.data['message'] ??
          errorMessage;
    } else if (err.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'Connection timeout';
    } else if (err.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Server not responding';
    } else if (err.type == DioExceptionType.connectionError) {
      errorMessage = 'No internet connection';
    }

    ApiClient.scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          maxLines: 1,
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );

    super.onError(err, handler);
  }
}
