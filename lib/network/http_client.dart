import 'dart:io';

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
  HttpClient._internal({required this.config}) {
    _initDio();
  }

  /// 初始化单例，必须在应用启动时调用
  static void init({required HttpConfig config}) {
    _instance ??= HttpClient._internal(config: config);
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

    // token拦截
    if (config.enableToken) {
      interceptors.add(TokenInterceptor(
        dio: _dio,
        getToken: config.getToken ?? () => SpUtil.getString("token"),
        onRefreshToken: config.onRefreshToken,
        onRefreshTokenFailed: config.onRefreshTokenFailed,
      ));
    }

    // 重试拦截器
    interceptors.add(RetryInterceptor(
      dio: _dio,
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

    _dio.interceptors.addAll(interceptors);
  }

  Future<T?> request<T>(
    String path, {
    String? baseUrl,
    HttpMethod method = HttpMethod.get,
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
      options.method = method.name.toUpperCase();

      // 处理 GET 请求参数
      final isGetMethod = method == HttpMethod.get;
      final queryParams = isGetMethod ? _convertParams(data) : null;

      if (showLoading) {
        DialogUtil.showLoading();
      }
      Response response = await _dio.request(
        _buildUrl(path, baseUrl),
        data: data,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      if (fromJson != null) {
        if (response.data is Map<String, dynamic>) {
          return fromJson(response.data);
        } else if (response.data is List) {
          return data.map((e) => fromJson(e)).toList() as T;
        }
      }
      return response.data;
    } catch (e) {
      throw e.toString();
    } finally {
      if (showLoading) {
        DialogUtil.hideLoading();
      }
    }
  }

  /// 动态构建完整请求地址
  String _buildUrl(String path, String? baseUrl) {
    if (baseUrl != null) return baseUrl + path;
    if (path.startsWith(RegExp(r'https?://'))) return path;
    return config.baseUrl + path;
  }

  /// 转换请求参数
  Map<String, dynamic>? _convertParams(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    } else {
      return null;
    }
  }

  // 便捷请求方法 --------------------------------------------------------------

  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? data,
    String? baseUrl,
    Options? options,
    T Function(dynamic json)? fromJson,
    bool showLoading = false,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return request<T>(
      path,
      method: HttpMethod.get,
      data: data,
      baseUrl: baseUrl,
      options: options,
      fromJson: fromJson,
      showLoading: showLoading,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<T?> post<T>(
    String path, {
    dynamic data,
    String? baseUrl,
    Options? options,
    T Function(dynamic json)? fromJson,
    bool showLoading = false,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return request<T>(
      path,
      method: HttpMethod.post,
      data: data,
      baseUrl: baseUrl,
      options: options,
      fromJson: fromJson,
      showLoading: showLoading,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<T?> uploadFile<T>(
    String path,
    String filePath, {
    String? baseUrl,
    HttpMethod method = HttpMethod.post,
    Options? options,
    Map<String, dynamic>? extraFields,
    T Function(dynamic json)? fromJson,
    bool showLoading = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
      ...?extraFields,
    });

    return request<T>(
      path,
      method: method,
      baseUrl: baseUrl,
      data: formData,
      options: options,
      fromJson: fromJson,
      showLoading: showLoading,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<File> downloadFile(
    String path,
    String savePath, {
    String? baseUrl,
    Options? options,
    bool showLoading = false,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      if (showLoading) DialogUtil.showLoading();

      await _dio.download(
        _buildUrl(path, baseUrl),
        savePath,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return File(savePath);
    } on DioException catch (e) {
      throw e.toString();
    } finally {
      if (showLoading) DialogUtil.hideLoading();
    }
  }
}
