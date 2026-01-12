import 'log_models.dart';

typedef ComLogSanitizer = ComNetworkDebug Function(ComNetworkDebug);

class ComDebugConfig {
  const ComDebugConfig({
    this.maxLogCount = 100,
    this.sanitize,
    this.enabled = true,
  });
  final int maxLogCount;
  final ComLogSanitizer? sanitize;
  final bool enabled;
}
