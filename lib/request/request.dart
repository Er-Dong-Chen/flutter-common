import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_chen_common/common/helper/common_helper.dart';

enum HttpType { get, post, put, patch, delete }

class RequestClient {
  late Dio _dio;

  static RequestClient? _instance;

  static RequestClient get instance => _instance!;

  RequestClient._internal(
      {required String baseUrl, List<Interceptor>? interceptors}) {
    _dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30)));

    // 添加默认拦截器
    _dio.interceptors.add(CookieManager(CookieJar()));

    // 添加自定义拦截器（如果提供了）
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  static Future<void> init({
    required String baseUrl,
    List<Interceptor>? interceptors,
  }) async {
    _instance ??=
        RequestClient._internal(interceptors: interceptors, baseUrl: baseUrl);
  }

  RequestClient({
    String baseUrl = 'your_default_base_url',
    List<Interceptor>? interceptors,
  }) : _dio = Dio(BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30))) {
    // 添加默认拦截器
    _dio.interceptors.add(CookieManager(CookieJar()));

    // 添加自定义拦截器
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  Future<T> request<T>(
    String url, {
    String? method,
    data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    bool showLoading = false,
  }) async {
    try {
      Options options = Options(
        method: method ?? HttpType.post.name,
        extra: extra,
        headers: headers,
      );

      if (showLoading) {
        CommonHelper.showLoading();
      }
      Response response = await _dio.request(url,
          queryParameters: data, data: data, options: options);
      if (showLoading) {
        CommonHelper.hideLoading();
      }
      return response.data;
    } on DioException catch (e) {
      if (showLoading) {
        CommonHelper.hideLoading();
      }
      throw e.toString();
    }
  }
}
