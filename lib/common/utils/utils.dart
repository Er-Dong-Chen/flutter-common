import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'cache_util.dart';
export 'date_util.dart';
export 'encrypt_util.dart';
export 'function_util.dart';
export 'json_util.dart';
export 'log_util.dart';
export 'sp_util.dart';
export 'utils.dart';

class CommonUtils {
  /// 拷贝内容到剪切板
  static setClipboardData(String text) async {
    ClipboardData data = ClipboardData(text: text);
    Clipboard.setData(data);
  }

  /// 获取剪切板内容
  static getClipboardData() async {
    var clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null) {
      return clipboardData;
    }
  }

  /// 隐藏软键盘
  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// 展示软键盘
  static void showKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  /// 清除数据
  static void clearClientKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.clearClient');
  }

  /// 将颜色字符串转化为color
  static Color parseColor(String color,
      {Color defaultColor = Colors.transparent}) {
    if (color.isEmpty) {
      return defaultColor;
    }
    if (!color.contains("#")) {
      return defaultColor;
    }
    var hexColor = color.replaceAll("#", "");
    //如果是6位，前加0xff
    if (hexColor.length == 6) {
      hexColor = "0xff$hexColor";
      var color = Color(int.parse(hexColor));
      return color;
    }
    //如果是8位，前加0x
    if (hexColor.length == 8) {
      var color = Color(int.parse("0x$hexColor"));
      return color;
    }
    return defaultColor;
  }

  /// 判断是否为亮色
  static bool isColorLight(Color color) {
    num r = color.red / 255.0;
    num g = color.green / 255.0;
    num b = color.blue / 255.0;

    if (r <= 0.03928) {
      r /= 12.92;
    } else {
      r = pow((r + 0.055) / 1.055, 2.4);
    }

    if (g <= 0.03928) {
      g /= 12.92;
    } else {
      g = pow((g + 0.055) / 1.055, 2.4);
    }

    if (b <= 0.03928) {
      b /= 12.92;
    } else {
      b = pow((b + 0.055) / 1.055, 2.4);
    }

    final luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b;
    return luminance >
        0.179; // 根据WCAG 2.0 Level AA标准，对比度阈值大约为4.5:1，对应的亮度阈值约为0.179
  }

  /// Generates a random integer that represents a Hex color.
  /// 生成一个表示十六进制颜色的随机整数
  static int randomColor() {
    var hex = "0xFF";
    Random random = Random();
    for (int i = 0; i < 3; i++) {
      hex += random.nextInt(255).toRadixString(16).padLeft(2, '0');
    }
    return int.parse(hex);
  }

  static int randomNumber({int max = 999}) {
    return Random.secure().nextInt(max);
  }
}
