import 'package:dio/dio.dart';

class DioErrorHandle {
  static String handleError(DioException error) {
    String message = "网络错误";
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = "连接超时";
        break;
      case DioExceptionType.receiveTimeout:
        message = "请求接收超时";
        break;
      case DioExceptionType.sendTimeout:
        message = "请求发送超时";
        break;
      case DioExceptionType.badResponse:
        message = error.message ?? message;
        break;
      case DioExceptionType.cancel:
        message = "请求取消";
        break;
      case DioExceptionType.connectionError:
        message = "网络错误";
        break;
      case DioExceptionType.badCertificate:
        message = "证书过期";
        break;
      case DioExceptionType.unknown:
        message = "网络错误";
    }
    return message;
  }
}
