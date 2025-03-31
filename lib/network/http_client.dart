import 'package:dio/dio.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';

enum HttpMethod { get, post, put, delete, patch }

class HttpClient {
  static HttpClient? _instance;

  late final Dio dio;
  final HttpConfig config;
  final TokenGetter? _tokenGetter;
  final OnTokenExpired? _onTokenExpired;
  final ErrorHandler? _errorHandler;

  // 私有构造函数
  HttpClient._internal({
    required this.config,
    TokenGetter? tokenGetter,
    OnTokenExpired? onTokenExpired,
    ErrorHandler? errorHandler,
  })  : _tokenGetter = tokenGetter,
        _onTokenExpired = onTokenExpired,
        _errorHandler = errorHandler {
    _initDio();
  }

  /// 初始化单例，必须在应用启动时调用
  static void init({
    required HttpConfig config,
    TokenGetter? tokenGetter,
    OnTokenExpired? onTokenExpired,
    ErrorHandler? errorHandler,
  }) {
    if (_instance != null) {
      throw Exception('HttpClient already initialized. Only call init once!');
    }
    _instance = HttpClient._internal(
      config: config,
      tokenGetter: tokenGetter,
      onTokenExpired: onTokenExpired,
      errorHandler: errorHandler,
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
    dio = Dio(BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      headers: config.commonHeaders,
    ));

    // 添加内置拦截器
    _addCoreInterceptors();

    // 添加自定义拦截器
    dio.interceptors.addAll(config.interceptors);
  }

  void _addCoreInterceptors() {
    final interceptors = <Interceptor>[];

    // 日志拦截器
    if (config.enableLog) {
      interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }

    // 重试拦截器
    interceptors.add(RetryInterceptor(
      dio: dio,
      maxRetries: config.maxRetries,
    ));

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

    dio.interceptors.addAll(interceptors);
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
      Response response = await dio.request(
        baseUrl != null ? baseUrl + path : config.baseUrl + path,
        data: data,
        queryParameters:
            options.method == HttpMethod.get.name.toUpperCase() ? data : null,
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
