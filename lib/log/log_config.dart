import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:logger/logger.dart';

import 'log_level.dart';

/// 日志配置类
class LogConfig {
  final int retentionDays; // 日志保留天数
  final bool enableFileLog; // 是否启用文件日志
  final LogLevel logLevel; // 日志过滤级别
  final LogLevel recordLevel; // 日志记录级别（Network日志级别分别是Info、Error）
  final Directory? logDirectory; // 日志文件目录
  final LogPrinter? printer; // LogPrinter
  final List<LogOutput>? output; // LogOutput
  final LogFilter? filter; // LogFilter
  final List<LogOutput> Function(List<LogOutput>)? composeOutputs; // 自定义输出组合
  final int rotateSizeBytes; // 轮转阈值字节数
  final int bufferMaxEvents; // 缓冲最大事件数
  final Duration bufferFlushDelay; // 缓冲最大发刷延时
  final Duration periodicFlushInterval; // 周期刷盘间隔
  final String latestFileName; // 最新日志文件名
  final String? id; // 统一ID（用于文件命名与会话）

  const LogConfig({
    this.retentionDays = 3,
    this.enableFileLog = true,
    this.logLevel = LogLevel.all,
    this.recordLevel = LogLevel.info,
    this.logDirectory,
    this.output,
    this.printer,
    this.filter,
    this.composeOutputs,
    this.rotateSizeBytes = 5 * 1024 * 1024,
    this.bufferMaxEvents = 256,
    this.bufferFlushDelay = const Duration(milliseconds: 300),
    this.periodicFlushInterval = const Duration(seconds: 2),
    this.latestFileName = 'latest.log',
    this.id,
  });

  /// 检查是否支持文件日志
  bool get canWriteToFile {
    if (!enableFileLog) return false;
    if (logDirectory == null) return false;
    return !kIsWeb; // 只在非 Web 环境下支持文件日志
  }
}
