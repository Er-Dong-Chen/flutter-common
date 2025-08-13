import '../extension/string_extension.dart';

/// 验证工具类
class ValidationUtil {
  ValidationUtil._();

  /// 验证手机号
  static bool isPhoneNumber(String? phone) {
    if (phone?.isEmpty ?? true) return false;
    return phone!.isPhoneNumber;
  }

  /// 验证邮箱
  static bool isEmail(String? email) {
    if (email?.isEmpty ?? true) return false;
    return email!.isEmail;
  }

  /// 验证URL
  static bool isUrl(String? url) {
    if (url?.isEmpty ?? true) return false;
    return url!.isUrl;
  }

  /// 验证密码强度（至少8位，包含数字和字母）
  static bool isStrongPassword(String? password) {
    if (password?.isEmpty ?? true) return false;
    final passwordRegex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$');
    return passwordRegex.hasMatch(password!);
  }

  /// 验证身份证号码
  static bool isChineseIDCard(String? idCard) {
    if (idCard?.isEmpty ?? true) return false;

    // 18位身份证正则
    final regex = RegExp(r'^\d{17}[\dXx]$');
    if (!regex.hasMatch(idCard!)) return false;

    // 校验码验证
    const weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
    const checkCodes = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'];

    int sum = 0;
    for (int i = 0; i < 17; i++) {
      sum += int.parse(idCard[i]) * weights[i];
    }

    final expectedCheckCode = checkCodes[sum % 11];
    return idCard[17].toUpperCase() == expectedCheckCode;
  }

  /// 验证银行卡号（Luhn算法）
  static bool isBankCard(String? cardNumber) {
    if (cardNumber?.isEmpty ?? true) return false;

    final digits =
        cardNumber!.replaceAll(' ', '').split('').map(int.tryParse).toList();
    if (digits.any((d) => d == null) ||
        digits.length < 13 ||
        digits.length > 19) {
      return false;
    }

    int sum = 0;
    bool alternate = false;

    for (int i = digits.length - 1; i >= 0; i--) {
      int digit = digits[i]!;

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  /// 验证车牌号
  static bool isChineseLicensePlate(String? plate) {
    if (plate?.isEmpty ?? true) return false;

    // 普通车牌和新能源车牌
    final regex = RegExp(
        r'^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领][A-Z][A-Z0-9]{4}[A-Z0-9挂学警港澳]$|^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领][A-Z][0-9]{5}[DF]$');
    return regex.hasMatch(plate!);
  }

  /// 验证IP地址
  static bool isIPAddress(String? ip) {
    if (ip?.isEmpty ?? true) return false;

    final parts = ip!.split('.');
    if (parts.length != 4) return false;

    return parts.every((part) {
      final num = int.tryParse(part);
      return num != null && num >= 0 && num <= 255;
    });
  }

  /// 验证端口号
  static bool isPort(String? port) {
    if (port?.isEmpty ?? true) return false;
    final num = int.tryParse(port!);
    return num != null && num >= 1 && num <= 65535;
  }

  /// 验证MAC地址
  static bool isMacAddress(String? mac) {
    if (mac?.isEmpty ?? true) return false;
    final regex = RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
    return regex.hasMatch(mac!);
  }

  /// 验证颜色值（十六进制）
  static bool isHexColor(String? color) {
    if (color?.isEmpty ?? true) return false;
    final regex = RegExp(r'^#?([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$');
    return regex.hasMatch(color!);
  }

  /// 验证数字范围
  static bool isNumberInRange(String? number, double min, double max) {
    if (number?.isEmpty ?? true) return false;
    final num = double.tryParse(number!);
    return num != null && num >= min && num <= max;
  }

  /// 验证字符串长度范围
  static bool isLengthInRange(String? text, int minLength, int maxLength) {
    if (text == null) return false;
    return text.length >= minLength && text.length <= maxLength;
  }

  /// 验证是否只包含中文
  static bool isChineseOnly(String? text) {
    if (text?.isEmpty ?? true) return false;
    final regex = RegExp(r'^[\u4e00-\u9fa5]+$');
    return regex.hasMatch(text!);
  }

  /// 验证是否只包含英文字母
  static bool isAlphaOnly(String? text) {
    if (text?.isEmpty ?? true) return false;
    final regex = RegExp(r'^[A-Za-z]+$');
    return regex.hasMatch(text!);
  }

  /// 验证是否只包含数字
  static bool isNumericOnly(String? text) {
    if (text?.isEmpty ?? true) return false;
    final regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(text!);
  }

  /// 验证是否只包含字母和数字
  static bool isAlphaNumericOnly(String? text) {
    if (text?.isEmpty ?? true) return false;
    final regex = RegExp(r'^[A-Za-z0-9]+$');
    return regex.hasMatch(text!);
  }

  /// 自定义正则验证
  static bool customRegexValidation(String? text, String pattern) {
    if (text?.isEmpty ?? true) return false;
    try {
      final regex = RegExp(pattern);
      return regex.hasMatch(text!);
    } catch (e) {
      return false;
    }
  }
}
