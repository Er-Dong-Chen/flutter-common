import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:logger/logger.dart';

import 'filter/log_filter.dart';
import 'output/isolate_file_output.dart';
import 'output/silent_file_output.dart';

class Log {
  static Logger? _logger;
  static late LogConfig _config;
  static late IsolateFileOutput _fileOutput;
  static late SilentFileOutput _silentOutput;

  static Future<void> init(LogConfig config) async {
    _config = config;
    List<LogOutput> outputs = [ConsoleOutput()];

    if (config.canWriteToFile) {
      _fileOutput = IsolateFileOutput(config);
      await _fileOutput.init();
      outputs.add(_fileOutput);
      _silentOutput = SilentFileOutput(_fileOutput);
    }

    if (config.output != null) {
      outputs = [...outputs, ...config.output!];
    }

    _logger = Logger(
      filter: ComLogFilter(LevelAdapter.toLevel(config.logLevel)),
      printer: PrettyPrinter(),
      output: MultiOutput(outputs),
    );
  }

  static Future<Directory> getLogDir() async {
    if (_config.logDirectory == null) {
      throw Exception('Log directory not configured');
    }
    return _config.logDirectory!;
  }

  static Future<List<String>> readLogsByDate({DateTime? date}) async {
    if (!_config.canWriteToFile) {
      return [];
    }

    date ??= DateTime.now();
    final dateStr =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final file = File('${_config.logDirectory!.path}/log_$dateStr.log');
    if (await file.exists()) {
      return await file.readAsLines();
    }
    return [];
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

    if (_config.canWriteToFile) {
      try {
        final outputEvent = OutputEvent(
          LogEvent(
            logLevel,
            message,
            error: error,
            stackTrace: stackTrace,
            time: time,
          ),
          [message.toString()],
        );
        _silentOutput.output(outputEvent);
      } catch (e) {
        developer.log('日志写入失败: $e');
      }
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

  static void d(dynamic message) => _logger?.d(message);
  static void i(dynamic message) => _logger?.i(message);
  static void w(dynamic message) => _logger?.w(message);
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger?.e(message, error: error, stackTrace: stackTrace);
}
