import 'log_models.dart';

typedef ComLogSanitizer = ComNetworkDebug Function(ComNetworkDebug);

class ComDebugConfig {
  const ComDebugConfig({
    this.maxLogCount = 100,
    this.sanitize,
  });
  final int maxLogCount;
  final ComLogSanitizer? sanitize;
}
