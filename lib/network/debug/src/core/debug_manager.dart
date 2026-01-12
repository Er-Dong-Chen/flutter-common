import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chen_common/network/debug/src/network/dio_interceptor.dart';

import 'debug_config.dart';
import 'log_models.dart';

class ComDebugManager {
  static final ComDebugManager _instance = ComDebugManager._internal();
  static ComDebugManager get instance => _instance;

  ComDebugManager._internal();
  ComDebugConfig config = const ComDebugConfig();
  final ValueNotifier<List<ComNetworkDebug>> logsNotifier = ValueNotifier([]);
  final ValueNotifier<bool> enabledNotifier = ValueNotifier(true);
  final Map<String, ComNetworkDebug> _logIndex = {};
  bool _initialized = false;
  Future<void> init({Dio? dio, ComDebugConfig? comDebugConfig}) async {
    if (_initialized) {
      if (comDebugConfig != null) updateConfig(comDebugConfig);
      return;
    }
    if (comDebugConfig != null) config = comDebugConfig;
    if (dio != null) {
      final exists =
          dio.interceptors.any((i) => i is ComNetworkDebugInterceptor);
      if (!exists) {
        dio.interceptors.add(ComNetworkDebugInterceptor());
      }
    }
    enabledNotifier.value = config.enabled;
    _initialized = true;
  }

  Future<void> setEnabled(bool enabled) async {
    if (enabledNotifier.value == enabled) return;
    enabledNotifier.value = enabled;
  }

  void updateConfig(ComDebugConfig newConfig) {
    config = newConfig;
    _trimToMax();
  }

  void addLog(ComNetworkDebug log) {
    if (!enabledNotifier.value) return;
    if (config.sanitize != null) {
      log = config.sanitize!(log);
    }
    final current = List<ComNetworkDebug>.from(logsNotifier.value);
    current.insert(0, log);
    logsNotifier.value = current;
    _logIndex[log.id] = log;
    _trimToMax();
  }

  void updateLog(ComNetworkDebug log) {
    _logIndex[log.id] = log;
    logsNotifier.value = List.from(logsNotifier.value);
  }

  void clearLogs() {
    logsNotifier.value = [];
    _logIndex.clear();
  }

  void _trimToMax() {
    if (logsNotifier.value.length > config.maxLogCount) {
      final trimmed = logsNotifier.value.sublist(0, config.maxLogCount);
      logsNotifier.value = trimmed;
      _logIndex
        ..clear()
        ..addEntries(trimmed.map((e) => MapEntry(e.id, e)));
    }
  }

  ComNetworkDebug? getLogById(String? id) {
    if (id == null) return null;
    return _logIndex[id];
  }
}
