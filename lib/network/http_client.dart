import 'package:dio/dio.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';

import 'interceptors/log_interceptor.dart';
import 'interceptors/token_interceptor.dart';

enum HttpMethod { get, post, put, delete, patch }

class HttpClient {
  static HttpClient? _instance;

  static late final Dio _dio;
  final HttpConfig config;

  // 私有构造函数
  HttpClient._internal({
    required this.config,
  }) {
    _initDio();
  }

  /// 初始化单例，必须在应用启动时调用
  static void init({
    required HttpConfig config,
  }) {
    if (_instance != null) {
      throw Exception('HttpClient already initialized. Only call init once!');
    }
    _instance = HttpClient._internal(
      config: config,
    );
  }

  /// 获取单例实例
  static HttpClient get instance {
    if (_instance == null) {
      throw Exception(
          'HttpClient not initialized. Call HttpClient.init() first.');
    }
    return _instance!;
  }

  void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      headers: config.commonHeaders,
    ));

    // 添加内置拦截器
    _addCoreInterceptors();

    // 添加自定义拦截器
    _dio.interceptors.addAll(config.interceptors);
  }

  void _addCoreInterceptors() {
    final interceptors = <Interceptor>[];

    // 日志拦截器
    if (config.enableLog) {
      interceptors.add(LoggerInterceptor());
    }

    // 重试拦截器
    interceptors.add(RetryInterceptor(
      dio: _dio,
      maxRetries: config.maxRetries,
    ));

    // token拦截
    if (config.enableToken) {
      interceptors.add(TokenInterceptor(
        dio: _dio,
        getToken: config.getToken ?? () => SpUtil.getString("token"),
        onRefreshToken: config.onRefreshToken,
        onRefreshTokenFailed: config.onRefreshTokenFailed,
      ));
    }

    // // 错误处理拦截器
    // interceptors.add(ErrorHandlerInterceptor(
    //   errorHandler: _errorHandler,
    // ));

    // // 缓存拦截器
    // if (config.enableCache) {
    //   interceptors.add(CacheInterceptor(
    //     cacheBox: Hive.box(config.cacheBoxName),
    //   ));
    // }

    _dio.interceptors.addAll(interceptors);
  }

  Future request<T>(
    String path, {
    String? baseUrl,
    String? method,
    Options? options,
    dynamic data,
    T Function(dynamic json)? fromJson,
    bool showLoading = false,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      options ??= Options();
      options.method =
          method?.toUpperCase() ?? HttpMethod.get.name.toUpperCase();

      if (showLoading) {
        DialogUtil.showLoading();
      }
      Response response = await _dio.request(
        baseUrl != null ? baseUrl + path : config.baseUrl + path,
        data: options.method != HttpMethod.get.name.toUpperCase() ? data : null,
        queryParameters: options.method == HttpMethod.get.name.toUpperCase()
            ? (data is Map<String, dynamic> ? data : null)
            : null,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      if (showLoading) {
        DialogUtil.hideLoading();
      }

      if (fromJson != null) {
        if (response.data is Map<String, dynamic>) {
          return fromJson(response.data);
        } else if (response.data is List) {
          return (response.data as List).map(fromJson).toList();
        }
      }
      return response.data;
    } catch (e) {
      if (showLoading) {
        DialogUtil.hideLoading();
      }
      throw e.toString();
    }
  }
}
