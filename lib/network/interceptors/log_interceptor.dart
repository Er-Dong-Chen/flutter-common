import 'dart:developer' as developer;

import 'package:dio/dio.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log('''
    
┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
│ ✅ [DIO] ${DateTime.now()} Request sent
│ Request: ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}
│ Headers: ${response.requestOptions.headers}
│ Query: ${response.requestOptions.data}
│ Response: ${response.data}
└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
''', name: 'DIO-LOGGER', level: 500);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log('''
    
┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
│ ❌ [DIO] ${DateTime.now()} Request sent
│ Request: ${err.requestOptions.method} ${err.requestOptions.uri}
│ Headers: ${err.requestOptions.headers}
│ Query: ${err.requestOptions.data}
│ Response: ${err.response?.data}
│ Error: ${err.toString()}
└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
''', name: 'DIO-LOGGER', level: 1000);
    handler.next(err);
  }
}
