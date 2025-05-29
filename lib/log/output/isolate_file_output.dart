import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:logger/logger.dart';

class IsolateFileOutput extends LogOutput {
  final LogConfig config;
  late SendPort _sendPort;
  Isolate? _isolate;
  final Completer<void> _initCompleter = Completer();
  final ReceivePort _receivePort = ReceivePort();
  final Completer<void> _exitCompleter = Completer<void>();
  bool _isPortClosed = false;

  IsolateFileOutput(this.config) {
    _initIsolate().catchError((e) => _initCompleter.completeError(e));
  }

  Future<void> _initIsolate() async {
    try {
      final rootIsolateToken = RootIsolateToken.instance!;
      _isolate = await Isolate.spawn(
        _isolateMain,
        _IsolateInitData(
          _receivePort.sendPort,
          config,
          rootIsolateToken,
        ),
        debugName: 'LoggerIsolate',
        onError: _receivePort.sendPort,
        onExit: _receivePort.sendPort,
      );

      _receivePort.listen((message) {
        if (message is SendPort) {
          _sendPort = message;
          _initCompleter.complete();
        } else if (message == 'isolate_exit') {
          _cleanUp();
          _exitCompleter.complete();
        } else if (message is List && message[0] == 'error') {
          _initCompleter.completeError(
              message[1], StackTrace.fromString(message[2]));
        }
      });
    } catch (e, s) {
      _initCompleter.completeError(e, s);
    }
  }

  static void _isolateMain(_IsolateInitData initData) {
    BackgroundIsolateBinaryMessenger.ensureInitialized(
        initData.rootIsolateToken);
    final receivePort = ReceivePort();
    initData.mainSendPort.send(receivePort.sendPort);

    final worker = _IsolateWorker(initData.config);
    Timer? flushTimer;

    receivePort.listen((dynamic message) async {
      if (message == 'stop') {
        await worker.flush();
        flushTimer?.cancel();
        Isolate.exit();
      } else if (message is OutputEvent) {
        worker.addEvent(message);
      }
    });

    flushTimer =
        Timer.periodic(const Duration(seconds: 5), (_) => worker.flush());
  }

  @override
  Future<void> init() async {
    await _initCompleter.future;
  }

  @override
  Future<void> destroy() async {
    try {
      _sendPort.send('stop');
      await _exitCompleter.future.timeout(const Duration(seconds: 5));
    } on TimeoutException {
      _isolate?.kill(priority: Isolate.immediate);
    } finally {
      _cleanUp();
    }
  }

  void _cleanUp() {
    if (!_isPortClosed) {
      _receivePort.close();
      _isPortClosed = true;
    }
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }

  @override
  void output(OutputEvent event) {
    if (_initCompleter.isCompleted &&
        !_exitCompleter.isCompleted &&
        event.level.value >= config.recordLevel.value) {
      _sendPort.send(event);
    }
  }
}

class _IsolateWorker {
  final LogConfig _config;
  final List<OutputEvent> _buffer = [];
  File? _currentFile;
  DateTime? _currentDate;
  Timer? _flushTimer;

  _IsolateWorker(this._config);

  void addEvent(OutputEvent event) {
    _buffer.add(event);
    if (_buffer.length >= 50) {
      _scheduleFlush();
    }
  }

  void _scheduleFlush() {
    if (_flushTimer?.isActive ?? false) return;
    _flushTimer = Timer(const Duration(milliseconds: 100), () => flush());
  }

  Future<void> flush() async {
    if (_buffer.isEmpty) return;
    final events = _buffer.toList();
    _buffer.clear();

    try {
      final file = await _getCurrentFile();
      final lines =
          events.expand((e) => e.lines.map(_removeAnsiCodes)).join('\n');
      await file.writeAsString('$lines\n', mode: FileMode.append);
      await _cleanOldLogs();
    } catch (e, s) {
      debugPrint('Log write failed: $e\n$s');
    }
  }

  Future<File> _getCurrentFile() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_currentDate != today) {
      if (_config.logDirectory == null) {
        throw Exception('日志目录未配置');
      }

      final logDir = _config.logDirectory!;
      if (!await logDir.exists()) {
        try {
          await logDir.create(recursive: true);
        } catch (e) {
          debugPrint('创建日志目录失败: $e');
          throw Exception('无法创建日志目录');
        }
      }

      final dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}"
          "-${now.day.toString().padLeft(2, '0')}";
      _currentFile = File('${logDir.path}/log_$dateStr.log');
      _currentDate = today;
    }

    return _currentFile!;
  }

  Future<void> _cleanOldLogs() async {
    try {
      if (_config.logDirectory == null) return;

      final cutoffDate =
          DateTime.now().subtract(Duration(days: _config.retentionDays));
      final dir = _config.logDirectory!;

      if (!await dir.exists()) return;

      await for (final file in dir.list()) {
        if (file is File && file.path.endsWith('.log')) {
          final modified = await file.lastModified();
          if (modified.isBefore(cutoffDate)) await file.delete();
        }
      }
    } catch (e, s) {
      debugPrint('Log cleanup failed: $e\n$s');
    }
  }

  // 过滤方法
  String _removeAnsiCodes(String input) {
    return input.replaceAll(
      RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'),
      '',
    );
  }
}

class _IsolateInitData {
  final SendPort mainSendPort;
  final LogConfig config;
  final RootIsolateToken rootIsolateToken;

  _IsolateInitData(
    this.mainSendPort,
    this.config,
    this.rootIsolateToken,
  );
}
