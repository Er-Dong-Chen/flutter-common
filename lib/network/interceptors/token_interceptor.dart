import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;
  final String? Function() getToken;
  final Future<String> Function()? onRefreshToken;
  final Future<void> Function()? onRefreshTokenFailed;

  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  TokenInterceptor({
    required this.dio,
    required this.getToken,
    required this.onRefreshToken,
    this.onRefreshTokenFailed,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && onRefreshToken != null) {
      final requestOptions = err.requestOptions;

      // 避免重复处理
      if (requestOptions.extra['_retried'] == true) {
        return handler.next(err);
      }

      // 加入待处理队列
      _pendingRequests.add(requestOptions);

      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          final newToken = await onRefreshToken!();
          // 更新全局 headers
          dio.options.headers['Authorization'] = 'Bearer $newToken';

          // 重试所有 pending 的请求
          for (var options in _pendingRequests) {
            try {
              final response = await _retryRequest(options);

              // 如果是原始请求则返回结果
              if (options == requestOptions) {
                handler.resolve(response);
              }
            } catch (e) {
              // 单个请求重试失败
              if (options == requestOptions) {
                handler.reject(DioException(requestOptions: options, error: e));
              }
            }
          }
        } catch (e) {
          await onRefreshTokenFailed?.call();
          // 刷新失败，全部请求失败
          handler.reject(DioException(
            requestOptions: requestOptions,
            error: 'Token refresh failed: $e',
          ));
        } finally {
          _isRefreshing = false;
          _pendingRequests.clear();
        }
      } else {
        // 已经在刷新 token，等待完成
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  Future<Response> _retryRequest(RequestOptions options) async {
    final newOptions = options.copyWith(
      headers: {...options.headers, ...dio.options.headers},
      extra: {...options.extra, '_retried': true},
    );
    return dio.fetch(newOptions);
  }
}
