import 'package:dio/dio.dart';
import 'package:flutter_chen_common/helper/dialog_helper.dart';

enum HttpMethod { get, post, put, patch, delete }

class HttpContentType {
  static String json = "application/json";
  static String form = "application/x-www-form-urlencoded";
}

class RequestClient {
  late Dio _dio;
  String baseUrl = "";
  static RequestClient? _instance;
  static RequestClient get instance => _instance!;

  factory RequestClient({
    String baseUrl = 'your_default_base_url',
    List<Interceptor>? interceptors,
  }) {
    _instance ??= RequestClient._internal(
      baseUrl: baseUrl,
      interceptors: interceptors,
    );
    return _instance!;
  }

  RequestClient._internal(
      {this.baseUrl = "", List<Interceptor>? interceptors}) {
    _dio = Dio(BaseOptions(
        // baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30)));

    // 添加自定义拦截器（如果提供了）
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  static Future<void> init({
    String baseUrl = "",
    List<Interceptor>? interceptors,
  }) async {
    _instance ??=
        RequestClient._internal(interceptors: interceptors, baseUrl: baseUrl);
  }

  Future<T> request<T>(
    String url, {
    String? baseUrl,
    String? method,
    Options? options,
    data,
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
        DialogHelper.showLoading();
      }
      Response response = await _dio.request(
        baseUrl != null ? baseUrl + url : this.baseUrl + url,
        data: data,
        queryParameters:
            options.method == HttpMethod.get.name.toUpperCase() ? data : null,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      if (showLoading) {
        DialogHelper.hideLoading();
      }
      return response.data;
    } catch (e) {
      if (showLoading) {
        DialogHelper.hideLoading();
      }
      throw e.toString();
    }
  }
}
