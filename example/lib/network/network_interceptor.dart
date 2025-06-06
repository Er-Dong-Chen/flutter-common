import 'package:dio/dio.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:module_base/module_base.dart';

import 'network_handle.dart';

class NetworkInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 如果不需要字段不为Authorization或者不需要加前缀就重新添加覆盖
    // if (SpUtil.hasKey("token")) {
    //   options.headers["Authorization"] = SpUtil.getString("token");
    // }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    final options = response.requestOptions;
    if (200 != response.statusCode || options.extra.containsKey("custom")) {
      return handler.next(response);
    }

    HttpResponse apiResponse = HttpResponse.fromJson(response.data);

    if (Constant.successCode == apiResponse.code) {
      response.data = apiResponse.data;
      handler.next(response);
    } else if (apiResponse.code != 401) {
      DialogUtil.showToast(apiResponse.message.toString());
      handler.reject(
        DioException(
            requestOptions: response.requestOptions,
            message: apiResponse.message,
            type: DioExceptionType.badResponse),
      );
    } else {
      handler.next(response);
    }
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    // 自定义拦截器都无需处理401错误
    if (err.response?.statusCode == 401) {
      return handler.next(err);
    }
    final message = DioErrorHandle.handleError(err);
    DialogUtil.showToast(message);
    return handler.next(err);
  }
}
