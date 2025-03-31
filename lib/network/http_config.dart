import 'package:dio/dio.dart';

class HttpConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final Map<String, dynamic> commonHeaders;
  final List<Interceptor> interceptors;
  final bool enableLog;
  final bool enableCache;
  final int maxRetries;

  HttpConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.sendTimeout = const Duration(seconds: 15),
    this.commonHeaders = const {},
    this.interceptors = const [],
    this.enableLog = true,
    this.enableCache = false,
    this.maxRetries = 3,
  });
}

typedef TokenGetter = Future<String?> Function();
typedef OnTokenExpired = Future<String> Function();
typedef ErrorHandler = void Function(
    DioException error, ErrorInterceptorHandler handler);
