import 'dart:convert';

import 'package:dio/dio.dart';

import '../../log/logger.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['request_time'] = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final duration = _calculateDuration(response.requestOptions);
    final time = _getTime(response.requestOptions);
    final statusEmoji = response.statusCode == 200 ? '✅' : '⚠️';
    Log.console('''
    
┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
│ $statusEmoji [HTTP] $time Request sent [Duration] ${duration}ms
│ Request: ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}
│ Headers: ${_formatJson(response.requestOptions.headers)}
│ Query: ${_indentMultiline(_formatJson(response.requestOptions.data))}
│ Response: ${_indentMultiline(_formatJson(response.data))}
└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
''', name: 'NETWORK', level: 800);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final duration = _calculateDuration(err.requestOptions);
    final time = _getTime(err.requestOptions);
    Log.console('''
    
┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
│ ❌ [HTTP] $time Request sent [Duration] ${duration}ms
│ Request: ${err.requestOptions.method} ${err.requestOptions.uri}
│ Headers: ${_formatJson(err.requestOptions.headers)}
│ Query: ${_formatJson(err.requestOptions.data)}
│ Response: ${_indentMultiline(_formatJson(err.response?.data))}
│ Error: ${_indentMultiline(err.toString())}
└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
''', name: 'NETWORK-ERROR', level: 1000);
    handler.next(err);
  }

  String _formatJson(dynamic data) {
    if (data == null) return 'null';

    try {
      if (data is Map || data is List) {
        return const JsonEncoder().convert(data);
      }
      return data.toString();
    } catch (e) {
      return '⚠️ Invalid Data';
    }
  }

  int _calculateDuration(RequestOptions options) {
    final start = options.extra['request_time'] == null
        ? DateTime.now().millisecondsSinceEpoch
        : (options.extra['request_time'] as DateTime).millisecondsSinceEpoch;
    return DateTime.now().millisecondsSinceEpoch - start;
  }

  String _getTime(RequestOptions options) {
    final time = options.extra['request_time'] == null
        ? DateTime.now()
        : (options.extra['request_time'] as DateTime);
    return time.toString().substring(0, 19);
  }

  String _indentMultiline(String? text) {
    if (text == null) return 'null';
    return text.replaceAll('\n', '\n│    ');
  }
}
