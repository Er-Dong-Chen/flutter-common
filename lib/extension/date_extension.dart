import '../date/datetime_formatter.dart';

extension DateExtension on DateTime {
  /// 获取星期几的中文名称
  String get weekdayName {
    const weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    return weekdays[weekday - 1];
  }

  /// 获取月份的中文名称
  String get monthName {
    const months = [
      '一月',
      '二月',
      '三月',
      '四月',
      '五月',
      '六月',
      '七月',
      '八月',
      '九月',
      '十月',
      '十一月',
      '十二月'
    ];
    return months[month - 1];
  }

  /// 格式化日期
  String format({String? pattern}) {
    return DateTimeFormatter.formatDate(this, pattern: pattern);
  }

  /// 判断是否是今天
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// 判断是否是昨天
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// 判断是否是明天
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// 判断是否是本周
  bool get isThisWeek {
    final now = DateTime.now();
    final difference = this.difference(now).inDays;
    return difference >= -weekday && difference <= (7 - weekday);
  }

  /// 判断是否是本月
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// 判断是否是今年
  bool get isThisYear {
    return year == DateTime.now().year;
  }
}
