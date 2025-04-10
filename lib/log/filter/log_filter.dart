import 'package:logger/logger.dart';

class ComLogFilter extends LogFilter {
  @override
  final Level level;

  ComLogFilter(this.level);

  @override
  bool shouldLog(LogEvent event) => event.level.index >= level.index;
}
