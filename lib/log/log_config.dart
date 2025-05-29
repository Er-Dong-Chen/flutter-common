import 'package:logger/logger.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'log_level.dart';

/// 日志配置类
class LogConfig {
  final int retentionDays; // 日志保留天数
  final bool enableFileLog; // 是否启用文件日志
  final LogLevel logLevel; // 日志过滤级别
  final LogLevel recordLevel; // 日志记录级别（Network日志级别分别是Info、Error）
  final List<LogOutput>? output; // LogOutput
  final Directory? logDirectory; // 日志文件目录

  const LogConfig({
    this.retentionDays = 3,
    this.enableFileLog = true,
    this.logLevel = LogLevel.all,
    this.recordLevel = LogLevel.info,
    this.output,
    this.logDirectory,
  });

  /// 检查是否支持文件日志
  bool get canWriteToFile {
    if (!enableFileLog) return false;
    if (logDirectory == null) return false;
    return !kIsWeb; // 只在非 Web 环境下支持文件日志
  }
}
