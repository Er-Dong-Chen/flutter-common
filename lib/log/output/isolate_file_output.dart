import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

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

    flushTimer = Timer.periodic(
        initData.config.periodicFlushInterval, (_) => worker.flush());
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
  String? _sessionId;
  int? _currentStartMillis;
  Timer? _flushTimer;
  Directory? _logDir;
  late String _id;

  _IsolateWorker(this._config) {
    _id = _config.id ?? '0';
  }

  void addEvent(OutputEvent event) {
    _buffer.add(event);
    if (_buffer.length >= _config.bufferMaxEvents) {
      _scheduleFlush();
    }
  }

  void _scheduleFlush() {
    if (_flushTimer?.isActive ?? false) return;
    _flushTimer = Timer(_config.bufferFlushDelay, () => flush());
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
      await _maybeRotate(file);
      await _cleanOldLogs();
    } catch (e, s) {
      debugPrint('Log write failed: $e\n$s');
    }
  }

  Future<File> _getCurrentFile() async {
    if (_config.logDirectory == null) {
      throw Exception('日志目录未配置');
    }
    _logDir ??= _config.logDirectory!;
    if (!await _logDir!.exists()) {
      try {
        await _logDir!.create(recursive: true);
      } catch (e) {
        debugPrint('创建日志目录失败: $e');
        throw Exception('无法创建日志目录');
      }
    }

    if (_currentFile == null) {
      final latest = File('${_logDir!.path}/${_config.latestFileName}');
      if (await latest.exists()) {
        try {
          final lines = await latest.readAsLines();
          final meta =
              lines.isNotEmpty ? _parseMetaLine(lines.first) : (null, null);
          final prevStart =
              meta.$2 ?? (await latest.lastModified()).millisecondsSinceEpoch;
          final end = DateTime.now().millisecondsSinceEpoch;
          final rotated = File('${_logDir!.path}/${_id}_${prevStart}_$end.log');
          try {
            await latest.rename(rotated.path);
          } catch (e) {
            debugPrint('日志文件重命名失败: $e');
          }
        } catch (e) {
          // 读取失败也尽量保留原文件，不进行覆盖
        }
      }
      _sessionId = _config.id ?? _generateSessionId();
      _currentStartMillis = DateTime.now().millisecondsSinceEpoch;
      await latest.create(recursive: true);
      await latest.writeAsString(
          'session=$_sessionId;start=$_currentStartMillis\n',
          mode: FileMode.write);
      _currentFile = latest;
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

  Future<void> _maybeRotate(File latest) async {
    try {
      final stat = await latest.stat();
      if (stat.size >= _config.rotateSizeBytes) {
        final end = DateTime.now().millisecondsSinceEpoch;
        final start = _currentStartMillis ?? end;
        final rotated = File('${_logDir!.path}/${_id}_${start}_$end.log');
        try {
          await latest.rename(rotated.path);
        } catch (e) {
          debugPrint('日志轮转重命名失败: $e');
        }
        _currentStartMillis = end;
        await latest.create(recursive: true);
        final sid = _config.id ?? _sessionId ?? _generateSessionId();
        await latest.writeAsString('session=$sid;start=$_currentStartMillis\n',
            mode: FileMode.write);
        _currentFile = latest;
        _sessionId = sid;
      }
    } catch (_) {}
  }

  // 过滤方法
  String _removeAnsiCodes(String input) {
    return input.replaceAll(
      RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'),
      '',
    );
  }

  (String?, int?) _parseMetaLine(String line) {
    try {
      final parts =
          line.split(RegExp(r'[;\s,]')).where((e) => e.isNotEmpty).toList();
      String? sid;
      int? start;
      for (final p in parts) {
        final kv = p.split('=');
        if (kv.length == 2) {
          if (kv[0] == 'session') sid = kv[1];
          if (kv[0] == 'start') start = int.tryParse(kv[1]);
        } else if (kv.length == 1) {
          final v = int.tryParse(kv[0]);
          if (v != null) start = v;
        }
      }
      return (sid, start);
    } catch (_) {
      return (null, null);
    }
  }

  String _generateSessionId() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rnd = Random.secure();
    final codeUnits = List<int>.generate(
        8, (_) => chars.codeUnitAt(rnd.nextInt(chars.length)));
    return String.fromCharCodes(codeUnits);
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
