import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:logger/logger.dart';

import 'filter/log_filter.dart';
import 'log_config.dart';
import 'log_level.dart';
import 'output/isolate_file_output.dart';

class Log {
  static Logger? _logger;
  static late LogConfig _config;
  static late IsolateFileOutput _fileOutput;
  static late List<LogOutput> _outputs;

  static Future<void> init(LogConfig config) async {
    _config = config;
    List<LogOutput> outputs = [ConsoleOutput()];

    if (config.canWriteToFile) {
      _fileOutput = IsolateFileOutput(config);
      await _fileOutput.init();
      outputs.add(_fileOutput);
    }

    if (config.output != null) {
      outputs = [...outputs, ...config.output!];
    }

    if (config.composeOutputs != null) {
      outputs = config.composeOutputs!(outputs);
    }

    _logger = Logger(
      filter:
          config.filter ?? ComLogFilter(LevelAdapter.toLevel(config.logLevel)),
      printer: config.printer ?? PrettyPrinter(),
      output: MultiOutput(outputs),
    );
    _outputs = outputs;
  }

  static Future<Directory> getLogDir() async {
    if (_config.logDirectory == null) {
      throw Exception('Log directory not configured');
    }
    return _config.logDirectory!;
  }

  static Future<List<String>> readLatestLogs() async {
    if (!_config.canWriteToFile) return [];
    if (_config.logDirectory == null) return [];
    final file =
        File('${_config.logDirectory!.path}/${_config.latestFileName}');
    if (await file.exists()) return await file.readAsLines();
    return [];
  }

  static Future<int> getLogDirectorySize() async {
    if (!_config.canWriteToFile) return 0;
    if (_config.logDirectory == null) return 0;
    final dir = _config.logDirectory!;
    if (!await dir.exists()) return 0;
    var total = 0;
    await for (final entity in dir.list(recursive: false, followLinks: false)) {
      if (entity is File && entity.path.endsWith('.log')) {
        try {
          final stat = await entity.stat();
          total += stat.size;
        } catch (_) {}
      }
    }
    return total;
  }

  static Future<bool> clearLogDirectoryLogs() async {
    if (!_config.canWriteToFile) return false;
    if (_config.logDirectory == null) return false;
    final dir = _config.logDirectory!;
    if (!await dir.exists()) {
      try {
        await dir.create(recursive: true);
      } catch (_) {
        return false;
      }
    }
    var ok = true;
    await for (final entity in dir.list(recursive: false, followLinks: false)) {
      if (entity is File && entity.path.endsWith('.log')) {
        try {
          await entity.delete();
        } catch (_) {
          ok = false;
        }
      }
    }
    try {
      final latest = File('${dir.path}/${_config.latestFileName}');
      await latest.create(recursive: true);
      await latest.writeAsString('', mode: FileMode.write);
    } catch (_) {
      ok = false;
    }
    return ok;
  }

  static void console(
    String message, {
    DateTime? time,
    int level = 500,
    String name = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    final logLevel = _developerLevelToLoggerLevel(level);

    developer.log(
      message,
      time: time ?? DateTime.now(),
      level: level,
      name: name.isNotEmpty ? name : 'CONSOLE',
      error: error,
      stackTrace: stackTrace,
    );

    try {
      final outputEvent = OutputEvent(
        LogEvent(
          logLevel,
          message,
          error: error,
          stackTrace: stackTrace,
          time: time ?? DateTime.now(),
        ),
        [message.toString()],
      );
      for (final output in _outputs) {
        if (output is ConsoleOutput) continue;
        output.output(outputEvent);
      }
    } catch (e) {
      developer.log('日志写入失败: $e');
    }
  }

  /// 映射枚举
  static Level _developerLevelToLoggerLevel(int developerLevel) {
    return switch (developerLevel) {
      >= 1000 => Level.error,
      >= 900 => Level.warning,
      >= 800 => Level.info,
      >= 500 => Level.debug,
      _ => Level.all,
    };
  }

  static void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger?.d(message, time: time, error: error, stackTrace: stackTrace);

  static void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger?.i(message, time: time, error: error, stackTrace: stackTrace);

  static void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger?.w(message, time: time, error: error, stackTrace: stackTrace);

  static void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger?.e(message, time: time, error: error, stackTrace: stackTrace);
}
