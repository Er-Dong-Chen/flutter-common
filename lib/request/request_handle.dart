import 'package:dio/dio.dart';

class DioErrorHandle {
  static String? handleError(DioException error) {
    String? message = "未知错误";
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = "连接超时";
        break;
      case DioExceptionType.receiveTimeout:
        message = "接收数据超时";
        break;
      case DioExceptionType.sendTimeout:
        message = "发送数据超时";
        break;
      case DioExceptionType.badResponse:
        message = error.message!.length > 20 ? "未知错误" : error.message;
        break;
      case DioExceptionType.cancel:
        message = "请求取消";
        break;
      case DioExceptionType.connectionError:
        message = "网络连接失败";
        break;
      case DioExceptionType.badCertificate:
        message = "SSL证书错误";
        break;
      case DioExceptionType.unknown:
        message = "网络异常";
    }
    return message;
  }
}
