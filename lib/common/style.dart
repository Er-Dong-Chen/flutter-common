import 'package:flutter/material.dart';

class CommonStyle {
  // 圆角
  static double rounded = 999.0;
  static double roundedSm = 8.0;
  static double roundedMd = 16.0;

  // 间距
  static double spaceXs = 6.0;
  static double spaceSm = 12.0;
  static double spaceMd = 16.0;
  static double spaceLg = 24.0;
  static double spaceXl = 36.0;

  // 字体
  static double fontXs = 10.0;
  static double fontSm = 12.0;
  static double fontMd = 14.0;
  static double fontLg = 16.0;
  static double fontXl = 18.0;
  static double fontXXl = 20.0;

  // 图片尺寸
  static double imageXs = 32.0;
  static double imageSm = 48.0;
  static double imageMd = 64.0;
  static double imageLg = 96.0;
  static double imageXl = 120.0;
}

class CommonColors {
  // 主题色系
  static MaterialColor theme = const MaterialColor(
    0xFF3783FD,
    <int, Color>{
      50: Color(0xfff8f6f9), // surface 背景色
      100: Color(0xfff8f2fa), // surfaceContainerLow 浅色背景色
      200: Color(0xfff2ecf4), // surfaceContainer 标准背景色
      300: Color(0xffece6ee), // surfaceContainerHigh 较深背景色
      400: Color(0xffe6e0e9), // surfaceContainerHighest 深色背景色
      500: Color(0xFF3783FD), // primary 主题色
      600: Color(0xff1d1b20), // onSurface 主要内容色
      700: Color(0xFF909399), // onSurfaceVariant 次要内容色
      800: Color(0xffffffff), // surfaceContainerLowest 相同色
      900: Color(0xff322f35), // inverseSurface 相反色
    },
  );

  // 主题渐变色
  static Gradient primaryGradient =
      LinearGradient(colors: [theme.shade500, theme.shade500]);
}
