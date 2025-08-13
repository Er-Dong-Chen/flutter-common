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
    try {
      return DateTimeFormatter.formatDate(
        DateTime.fromMillisecondsSinceEpoch(this),
        pattern: pattern,
      );
    } catch (e) {
      return 'Invalid timestamp';
    }
  }

  /// 检查是否为偶数
  bool get isEven => this % 2 == 0;

  /// 检查是否为奇数
  bool get isOdd => this % 2 != 0;

  /// 检查是否为质数
  bool get isPrime {
    if (this < 2) return false;
    if (this == 2) return true;
    if (isEven) return false;

    for (int i = 3; i * i <= this; i += 2) {
      if (this % i == 0) return false;
    }
    return true;
  }

  /// 限制在指定范围内
  int clampInt(int min, int max) => clamp(min, max) as int;

  /// 转换为罗马数字
  String get toRoman {
    if (this <= 0 || this > 3999) return toString();

    const values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
    const symbols = [
      'M',
      'CM',
      'D',
      'CD',
      'C',
      'XC',
      'L',
      'XL',
      'X',
      'IX',
      'V',
      'IV',
      'I'
    ];

    String result = '';
    int remaining = this;

    for (int i = 0; i < values.length; i++) {
      while (remaining >= values[i]) {
        result += symbols[i];
        remaining -= values[i];
      }
    }

    return result;
  }
}
