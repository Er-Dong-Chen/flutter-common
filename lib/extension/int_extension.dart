import '../date/datetime_formatter.dart';

extension IntExtension on int {
  Duration get seconds => Duration(seconds: this);

  Duration get days => Duration(days: this);

  Duration get hours => Duration(hours: this);

  Duration get minutes => Duration(minutes: this);

  Duration get milliseconds => Duration(milliseconds: this);

  Duration get microseconds => Duration(microseconds: this);

  Duration get ms => milliseconds;

  /// 转换为时间格式（毫秒）
  String toDateStr({String? pattern}) {
    return DateTimeFormatter.formatDate(
      DateTime.fromMillisecondsSinceEpoch(this),
      pattern: pattern,
    );
  }
}
