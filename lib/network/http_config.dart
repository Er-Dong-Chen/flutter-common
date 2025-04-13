import 'package:dio/dio.dart';

class HttpConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final Map<String, dynamic> commonHeaders;
  final List<Interceptor> interceptors;
  final bool enableLog;
  final bool enableToken;
  final int maxRetries;
  final String? Function()? getToken;
  final Future<String> Function()? onRefreshToken;
  final Future<void> Function()? onRefreshTokenFailed;

  HttpConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.sendTimeout = const Duration(seconds: 15),
    this.commonHeaders = const {},
    this.interceptors = const [],
    this.enableLog = true,
    this.enableToken = true,
    this.maxRetries = 3,
    this.getToken,
    this.onRefreshToken,
    this.onRefreshTokenFailed,
  });
}
