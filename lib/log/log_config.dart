import 'package:logger/logger.dart';

/// 日志配置类
class LogConfig {
  final int retentionDays; // 日志保留天数
  final bool enableFileLog; // 是否启用文件日志
  final Level logLevel; // 日志过滤级别
  final Level recordLevel; // 日志记录级别（Network日志级别分别是Info、Error）
  final int bufferSize; // 缓冲区大小
  final List<LogOutput>? output; // LogOutput

  const LogConfig({
    this.retentionDays = 3,
    this.enableFileLog = true,
    this.logLevel = Level.all,
    this.recordLevel = Level.info,
    this.bufferSize = 10,
    this.output,
  });
}
