import 'package:dio/dio.dart';

import '../core/debug_manager.dart';
import '../core/log_models.dart';

class ComNetworkDebugInterceptor extends Interceptor {
  ComNetworkDebugInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestId = DateTime.now().microsecondsSinceEpoch.toString();
    final log = ComNetworkDebug(
      id: requestId,
      timestamp: DateTime.now(),
      method: options.method,
      url: options.uri.toString(),
    );
    log.request = ComRequestDetails(
      headers: options.headers,
      body: options.data,
      contentType: options.contentType ?? '',
    );
    ComDebugManager.instance.addLog(log);
    options.extra['com_debug_id'] = requestId;
    options.extra['com_debug_start_time'] =
        DateTime.now().millisecondsSinceEpoch;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final requestId = response.requestOptions.extra['com_debug_id'] as String?;
    final startTime =
        response.requestOptions.extra['com_debug_start_time'] as int?;
    final log = ComDebugManager.instance.getLogById(requestId);
    if (log != null) {
      log.response = ComResponseDetails(
        statusCode: response.statusCode,
        headers: response.headers.map,
        body: response.data,
        timestamp: DateTime.now(),
      );
      if (startTime != null) {
        log.durationMs = DateTime.now().millisecondsSinceEpoch - startTime;
      }
      ComDebugManager.instance.updateLog(log);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestId = err.requestOptions.extra['com_debug_id'] as String?;
    final startTime = err.requestOptions.extra['com_debug_start_time'] as int?;
    final log = ComDebugManager.instance.getLogById(requestId);
    if (log != null) {
      log.error = ComErrorDetails(
        errorMessage: err.message ?? 'Unknown Error',
        errorType: err.type.toString(),
        errorObject: err.error,
        stackTrace: err.stackTrace?.toString(),
      );
      if (err.response != null) {
        log.response = ComResponseDetails(
          statusCode: err.response?.statusCode,
          headers: err.response?.headers.map ?? {},
          body: err.response?.data,
          timestamp: DateTime.now(),
        );
      }
      if (startTime != null) {
        log.durationMs = DateTime.now().millisecondsSinceEpoch - startTime;
      }
      ComDebugManager.instance.updateLog(log);
    }
    super.onError(err, handler);
  }
}
