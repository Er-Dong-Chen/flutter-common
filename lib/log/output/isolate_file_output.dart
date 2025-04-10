import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class IsolateFileOutput extends LogOutput {
  final LogConfig config;
  late SendPort _sendPort;
  Isolate? _isolate;
  final Completer<void> _initCompleter = Completer();
  final _receivePort = ReceivePort();

  IsolateFileOutput(this.config) {
    _initIsolate();
  }

  Future<void> _initIsolate() async {
    final rootIsolateToken = RootIsolateToken.instance!;
    _isolate = await Isolate.spawn(
      _isolateMain,
      _IsolateInitData(
        _receivePort.sendPort,
        config,
        rootIsolateToken,
      ),
      onError: _receivePort.sendPort,
      onExit: _receivePort.sendPort,
    );

    _receivePort.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
        _initCompleter.complete();
      } else if (message == 'isolate_exit') {
        _cleanUp();
      }
    });
  }

  @override
  Future<void> init() async {
    await _initCompleter.future;
  }

  @override
  Future<void> destroy() async {
    _sendPort.send('stop');
    _receivePort.close();
    _isolate?.kill(priority: Isolate.immediate);
  }

  void _cleanUp() {
    _receivePort.close();
    _isolate = null;
  }

  @override
  void output(OutputEvent event) {
    if (_initCompleter.isCompleted &&
        event.level.index >= config.recordLevel.index) {
      _sendPort.send(event);
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
        Timer.periodic(const Duration(seconds: 3), (_) => worker.flush());
  }
}

class _IsolateWorker {
  final LogConfig _config;
  final List<OutputEvent> _buffer = [];
  File? _currentFile;
  DateTime? _currentDate;

  _IsolateWorker(this._config);

  void addEvent(OutputEvent event) {
    _buffer.add(event);
    if (_buffer.length >= _config.bufferSize) flush();
  }

  Future<void> flush() async {
    if (_buffer.isEmpty) return;
    final events = _buffer.toList();
    _buffer.clear();

    final file = await _getCurrentFile();
    final lines = events.expand((e) => e.lines).join('\n');
    await file.writeAsString('$lines\n', mode: FileMode.append);
    await _cleanOldLogs();
  }

  Future<File> _getCurrentFile() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_currentDate == null || _currentDate != today) {
      final dir = await getApplicationDocumentsDirectory();
      final logDir = Directory('${dir.path}/logs');
      if (!await logDir.exists()) await logDir.create(recursive: true);

      final dateStr =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      _currentFile = File('${logDir.path}/log_$dateStr.log');
      _currentDate = today;
    }

    return _currentFile!;
  }

  Future<void> _cleanOldLogs() async {
    final cutoffDate =
        DateTime.now().subtract(Duration(days: _config.retentionDays));
    final dir =
        Directory('${(await getApplicationDocumentsDirectory()).path}/logs');

    await for (final file in dir.list()) {
      if (file is File && file.path.endsWith('.log')) {
        final modified = await file.lastModified();
        if (modified.isBefore(cutoffDate)) await file.delete();
      }
    }
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
