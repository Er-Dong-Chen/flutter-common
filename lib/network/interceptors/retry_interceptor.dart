import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration initialDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
  });

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final retryCount = options.extra['retryCount'] ?? 0;

    if (_shouldRetry(err) && retryCount < maxRetries) {
      final delay = _exponentialDelay(retryCount);
      await Future.delayed(delay);

      options.extra['retryCount'] = retryCount + 1;
      try {
        final clonedOptions = options.copyWith();
        final response = await dio.fetch(clonedOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }
    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout;
  }

  Duration _exponentialDelay(int retryCount) {
    return Duration(seconds: initialDelay.inSeconds * (1 << retryCount));
  }
}
