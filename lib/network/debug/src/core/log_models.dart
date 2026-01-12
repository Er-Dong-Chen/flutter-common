class ComNetworkDebug {
  ComNetworkDebug({
    String? id,
    required this.timestamp,
    required this.method,
    required this.url,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();
  final String id;
  final DateTime timestamp;
  final String method;
  final String url;
  ComRequestDetails? request;
  ComResponseDetails? response;
  ComErrorDetails? error;
  int? durationMs;
  bool get isError =>
      error != null ||
      (response != null && (response!.statusCode ?? 200) >= 400);
  int get statusCode => response?.statusCode ?? 0;
}

class ComRequestDetails {
  ComRequestDetails({
    this.headers = const {},
    this.body,
    this.contentType = '',
  });
  final Map<String, dynamic> headers;
  final dynamic body;
  final String contentType;
}

class ComResponseDetails {
  ComResponseDetails({
    this.statusCode,
    this.headers = const {},
    this.body,
    required this.timestamp,
  });
  final int? statusCode;
  final Map<String, dynamic> headers;
  final dynamic body;
  final DateTime timestamp;
}

class ComErrorDetails {
  ComErrorDetails({
    required this.errorMessage,
    this.errorType,
    this.errorObject,
    this.stackTrace,
  });
  final String errorMessage;
  final String? errorType;
  final dynamic errorObject;
  final String? stackTrace;
}
