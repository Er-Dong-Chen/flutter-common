import 'package:logger/logger.dart';

/// [Level]s to control logging output. Logging can be enabled to include all
/// levels above certain [Level].
enum LogLevel {
  all(0),
  trace(1000),
  debug(2000),
  info(3000),
  warning(4000),
  error(5000),
  fatal(6000),
  off(10000),
  ;

  final int value;

  const LogLevel(this.value);
}

class LevelAdapter {
  static Level toLevel(LogLevel level) {
    return switch (level) {
      LogLevel.all => Level.all,
      LogLevel.trace => Level.trace,
      LogLevel.debug => Level.debug,
      LogLevel.info => Level.info,
      LogLevel.warning => Level.warning,
      LogLevel.error => Level.error,
      LogLevel.fatal => Level.fatal,
      LogLevel.off => Level.off,
    };
  }
}
