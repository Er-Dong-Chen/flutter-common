extension StringExtension on String {
  /// 判断字符串是否为空
  bool get isEmptyOrNull => isEmpty;

  /// 判断字符串是否不为空
  bool get isNotEmptyOrNull => isNotEmpty;

  /// 将字符串转换为int
  int? toInt() {
    return int.tryParse(this);
  }

  /// 将字符串转换为double
  double? toDouble() {
    return double.tryParse(this);
  }

  /// 将字符串转换为bool
  bool toBool() {
    return toLowerCase() == 'true';
  }

  /// 判断字符串是否为手机号
  bool get isPhoneNumber {
    return RegExp(r'^1[3-9]\d{9}$').hasMatch(this);
  }

  /// 判断字符串是否为邮箱
  bool get isEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// 判断字符串是否为URL
  bool get isUrl {
    return RegExp(
            r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$')
        .hasMatch(this);
  }

  /// 隐藏手机号中间四位
  String get hidePhoneNumber {
    if (length != 11) return this;
    return replaceRange(3, 7, '****');
  }

  /// 隐藏邮箱
  String get hideEmail {
    if (!contains('@')) return this;
    final parts = split('@');
    if (parts.length != 2) return this;
    final username = parts[0];
    final domain = parts[1];
    if (username.length <= 2) return this;
    return '${username.substring(0, 2)}***@$domain';
  }

  /// 小数位格式化
  String toFixed({int digits = 2, String def = "0.0"}) {
    if (isEmpty) return def;
    return double.parse(this).toStringAsFixed(digits);
  }
}
