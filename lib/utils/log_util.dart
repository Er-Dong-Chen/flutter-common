import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

/// 增强版日志配置
class LogConfig {
  /// 日志保留天数（默认3天）
  final int retentionDays;

  /// 单个日志文件最大大小（单位字节，默认5MB）
  final int maxFileSize;

  /// 是否启用文件日志（默认true）
  final bool fileLogging;

  /// 是否在控制台输出颜色（默认调试模式开启）
  final bool colors;

  /// 最低记录级别（默认all）
  final Level level;

  const LogConfig({
    this.retentionDays = 3,
    this.maxFileSize = 5 * 1024 * 1024,
    this.fileLogging = true,
    this.colors = kDebugMode,
    this.level = Level.all,
  });
}

/// 高性能日志系统
class Log {
  static late final Logger _logger;
  static late final LogConfig _config;
  static late final Directory _logDir;
  static SendPort? _isolatePort;
  static final _isolateReady = Completer<void>();

  /// 初始化日志系统
  static Future<void> init(LogConfig config) async {
    _config = config;
    _logDir = await _initLogDirectory();

    _logger = Logger(
      filter: _LogFilter(),
      printer: HybridPrinter(
        PrettyPrinter(
            colors: _config.colors,
            printEmojis: false,
            lineLength: 120,
            methodCount: 0),
        debug: PrettyPrinter(methodCount: 3),
      ),
      output: MultiOutput([
        ConsoleOutput(),
        if (_config.fileLogging) _IsolateLogOutput(),
      ]),
    );

    if (_config.fileLogging) {
      await _IsolateLogOutput.initialize(_logDir.path);
    }
  }

  /// 初始化日志目录
  static Future<Directory> _initLogDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    final logDir = Directory('${dir.path}/logs');
    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }
    return logDir;
  }

  /// 统一清理入口
  static Future<void> _cleanOldLogs(String logDirPath) async {
    try {
      final now = DateTime.now();
      final threshold = now.subtract(Duration(days: _config.retentionDays));
      final logDir = Directory(logDirPath);

      await for (final entity in logDir.list()) {
        if (entity is File && _isValidLogFile(entity.path)) {
          final date = _parseDateFromFilename(entity.path);
          if (date != null && date.isBefore(threshold)) {
            await _safeDelete(entity);
          }
        }
      }
    } catch (e, stack) {
      _logger.e('Logs cleanup failed', error: e, stackTrace: stack);
    }
  }

  static Future<void> _safeDelete(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        _logger.d('Deleted log file: ${file.path}');
      }
    } catch (e, stack) {
      _logger.w('Failed to delete ${file.path}', error: e, stackTrace: stack);
    }
  }

  /// 外部日志接口
  static void externalLog(LogEvent event) {
    if (_isolatePort != null) {
      _isolatePort!.send(_formatLogEntry(
        level: event.level,
        message: event.message,
        error: event.error,
        stackTrace: event.stackTrace,
        time: event.time,
      ));
    }
  }

  // 日志方法 --------------------------------------------------------------
  static void d(dynamic message) => _log(Level.debug, message);
  static void i(dynamic message) => _log(Level.info, message);
  static void w(dynamic message) => _log(Level.warning, message);
  static void e(dynamic message, [dynamic error, StackTrace? stack]) =>
      _log(Level.error, message, error, stack);

  static void _log(Level level, dynamic message,
      [dynamic error, StackTrace? stack]) {
    _logger.log(level, message, error: error, stackTrace: stack);
  }

  // 辅助方法 ------------------------------------------------------------
  static bool _isValidLogFile(String path) {
    return RegExp(r'\d{4}-\d{2}-\d{2}\.log$').hasMatch(path);
  }

  static DateTime? _parseDateFromFilename(String path) {
    try {
      final match = RegExp(r'(\d{4}-\d{2}-\d{2})\.log$').firstMatch(path);
      return DateTime.parse(match!.group(1)!);
    } catch (_) {
      return null;
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}'
        '-${date.day.toString().padLeft(2, '0')}';
  }

  static List<dynamic> _formatLogEntry({
    required Level level,
    required dynamic message,
    dynamic error,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    final timestamp = time ?? DateTime.now();
    final buffer = StringBuffer()
      ..writeln('[$timestamp][${level.name}] $message')
      ..writeln('Thread: ${Isolate.current.debugName}');

    if (error != null) {
      buffer.writeln('Error: $error');
    }

    if (stackTrace != null) {
      buffer.writeln('Stack: $stackTrace');
    }

    buffer.writeln('-' * 80);
    return [buffer.toString(), '${_formatDate(timestamp)}.log'];
  }
}

/// 自定义日志过滤器
class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.level.index >= Log._config.level.index;
  }
}

/// Isolate日志处理器
class _IsolateLogOutput extends LogOutput {
  static final _receivePort = ReceivePort();
  static DateTime? _lastCleanup;

  static Future<void> initialize(String logDirPath) async {
    final completer = Completer<SendPort>();
    await Isolate.spawn(
      _isolateMain,
      _receivePort.sendPort,
      debugName: 'LogIsolate',
    );

    _receivePort.listen((message) {
      if (message is SendPort) {
        Log._isolatePort = message;
        // 发送初始化参数
        Log._isolatePort!.send({
          'type': 'init',
          'logDirPath': logDirPath,
        });
        completer.complete(message);
      }
    });

    await completer.future;
    Log._isolateReady.complete();
  }

  static void _isolateMain(SendPort mainSendPort) {
    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);

    String? logDirPath;

    receivePort.listen((dynamic message) async {
      if (message is Map && message['type'] == 'init') {
        // 初始化日志目录路径
        logDirPath = message['logDirPath'] as String;
      } else if (message is List) {
        if (logDirPath == null) return;
        final content = message[0] as String;
        final fileName = message[1] as String;
        await _handleLogEntry(content, fileName, logDirPath!);
      }
    });
  }

  static Future<void> _handleLogEntry(
    String content,
    String fileName,
    String logDirPath,
  ) async {
    try {
      final file = File('$logDirPath/$fileName');

      // 清理检查（每天执行一次）
      if (_shouldCleanup()) {
        await Log._cleanOldLogs(logDirPath);
        _lastCleanup = DateTime.now();
      }

      // 写入日志
      await file.writeAsString(content, mode: FileMode.append, flush: true);

      // 文件大小检查
      if (await file.length() > Log._config.maxFileSize) {
        await file.writeAsString('[LOG ROTATED]\n$content',
            mode: FileMode.write);
      }
    } catch (e, stack) {
      debugPrint('Log write failed: $e\n$stack');
    }
  }

  static bool _shouldCleanup() {
    return _lastCleanup == null ||
        DateTime.now().difference(_lastCleanup!) > const Duration(hours: 24);
  }

  @override
  void output(OutputEvent event) {
    if (!Log._isolateReady.isCompleted) return;

    final entries = Log._formatLogEntry(
      level: event.level,
      message: event.lines.join(' '),
      time: DateTime.now(),
    );

    Log._isolatePort?.send(entries);
  }
}
