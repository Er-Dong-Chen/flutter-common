import 'package:logger/logger.dart';

import 'log_level.dart';

/// 日志配置类
class LogConfig {
  final int retentionDays; // 日志保留天数
  final bool enableFileLog; // 是否启用文件日志
  final LogLevel logLevel; // 日志过滤级别
  final LogLevel recordLevel; // 日志记录级别（Network日志级别分别是Info、Error）
  final List<LogOutput>? output; // LogOutput

  const LogConfig({
    this.retentionDays = 3,
    this.enableFileLog = true,
    this.logLevel = LogLevel.all,
    this.recordLevel = LogLevel.info,
    this.output,
  });
}
