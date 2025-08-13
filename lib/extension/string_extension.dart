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
    return double.tryParse(this)?.toStringAsFixed(digits) ?? def;
  }

  /// 首字母大写
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// 驼峰命名转换
  String get toCamelCase {
    return split(' ')
        .asMap()
        .map((i, word) =>
            MapEntry(i, i == 0 ? word.toLowerCase() : word.capitalize))
        .values
        .join();
  }

  /// 检查是否包含表情符号
  bool get containsEmoji {
    return RegExp(
            r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')
        .hasMatch(this);
  }

  /// 移除所有空白字符
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// 安全的子字符串提取
  String safeSubstring(int start, [int? end]) {
    if (isEmpty || start >= length) return '';
    final safeStart = start.clamp(0, length);
    final safeEnd = end?.clamp(safeStart, length) ?? length;
    return substring(safeStart, safeEnd);
  }

  /// 反转字符串
  String get reversed {
    return split('').reversed.join();
  }

  /// 检查是否为回文
  bool get isPalindrome {
    final cleaned = toLowerCase().removeWhitespace;
    return cleaned == cleaned.reversed;
  }
}
