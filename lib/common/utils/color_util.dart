import 'dart:math';

import 'package:flutter/material.dart';

/// 颜色相关操作工具类
class ColorUtils {
  /// 将十六进制颜色字符串转换为Color对象
  ///
  /// 参数 [hex] 表示十六进制颜色字符串，例如：'#RRGGBB' 或者 '#AARRGGBB'
  /// 如果字符串格式不正确，则返回null
  static Color? hexToColor(String hex) {
    try {
      return Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
    } catch (e) {
      return null;
    }
  }

  /// 将Color对象转换为十六进制颜色字符串
  ///
  /// 参数 [color] 表示要转换的Color对象
  /// 如果Color对象为null，则返回空字符串
  static String colorToHex(Color? color) {
    return color != null
        ? '#${color.value.toRadixString(16).substring(2)}'
        : '';
  }

  /// 生成随机颜色
  ///
  /// 返回一个随机生成的Color对象
  static Color randomColor() {
    Random random = Random();
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  /// 判断颜色是否为亮色
  ///
  /// 参数 [color] 表示要判断的颜色
  /// 返回值：true表示颜色为亮色，false表示颜色为暗色
  bool isLightColor(Color color) {
    // 将颜色转换为HSL颜色空间
    HSLColor hslColor = HSLColor.fromColor(color);
    // 获取颜色的亮度值
    double lightness = hslColor.lightness;
    // 如果亮度值大于0.5，则认为是亮色
    return lightness > 0.5;
  }
}
