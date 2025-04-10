import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter_chen_common/log/filter/log_filter.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'log_config.dart';
import 'output/isolate_file_output.dart';
import 'output/silent_file_output.dart';

class Log {
  static Logger? _logger;
  static late LogConfig _config;
  static late IsolateFileOutput _fileOutput;
  static late SilentFileOutput _silentOutput;

  static Future<void> init(LogConfig config) async {
    _config = config;
    final outputs = <LogOutput>[ConsoleOutput()];

    if (config.enableFileLog) {
      _fileOutput = IsolateFileOutput(config);
      outputs.add(_fileOutput);
      _silentOutput = SilentFileOutput(_fileOutput);
    }

    if (config.output != null) {
      outputs.addAll(outputs);
    }

    _logger = Logger(
      filter: ComLogFilter(config.logLevel),
      printer: PrettyPrinter(),
      output: MultiOutput(outputs),
    );
  }

  static Future<Directory> getLogDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final logDir = Directory('${dir.path}/logs');
    if (!await logDir.exists()) await logDir.create(recursive: true);
    return logDir;
  }

  static Future<List<String>> readLogsByDate({DateTime? date}) async {
    date ??= DateTime.now();
    final dir = await getApplicationDocumentsDirectory();
    final dateStr =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final file = File('${dir.path}/logs/log_$dateStr.log');
    if (await file.exists()) {
      return await file.readAsLines();
    }
    return [];
  }

  static void console(
    dynamic message, {
    DateTime? time,
    int level = 500,
    String name = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    final logLevel = _developerLevelToLoggerLevel(level);

    developer.log(
      message.toString(),
      time: time ?? DateTime.now(),
      level: level,
      name: name.isNotEmpty ? name : 'CONSOLE',
      error: error,
      stackTrace: stackTrace,
    );

    if (_config.enableFileLog) {
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
    } else {
      developer.log('SilentOutput not initialized!', level: 900);
    }
  }

  /// 映射 developer.log 的 int level 到 Logger 的 Level 枚举
  static Level _developerLevelToLoggerLevel(int developerLevel) {
    return switch (developerLevel) {
      >= 1000 => Level.error, // FINE
      >= 900 => Level.warning, // CONFIG
      >= 800 => Level.info, // INFO
      >= 500 => Level.debug, // WARNING
      _ => Level.all, // SEVERE/SHOUT
    };
  }

  static void d(dynamic message) => _logger?.d(message);
  static void i(dynamic message) => _logger?.i(message);
  static void w(dynamic message) => _logger?.w(message);
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger?.e(message, error: error, stackTrace: stackTrace);
}
