import 'package:flutter/material.dart';

class AppStyle {
  static const double buttonHeight = 48;

  // 字体
  static const double fontXs = 10.0;
  static const double fontSm = 12.0;
  static const double fontMd = 14.0;
  static const double fontLg = 16.0;
  static const double fontXl = 18.0;
  static const double fontXXl = 20.0;

  // 图片尺寸
  static const double imageXs = 32.0;
  static const double imageSm = 48.0;
  static const double imageMd = 64.0;
  static const double imageLg = 96.0;
  static const double imageXl = 120.0;
}

class AppColors {
  // 主题色系
  static const MaterialColor lightColor = MaterialColor(
    0xFF3783FD,
    <int, Color>{
      50: Color(0xffF8F8F8), // surface 背景色
      100: Color(0xfff8f2fa), // surfaceContainerLow 浅色背景色
      200: Color(0xffEFF0F1), // surfaceContainer 标准背景色
      300: Color(0xffEEEEEE), // surfaceContainerHigh 较深背景色
      400: Color(0xffe6e0e9), // surfaceContainerHighest 深色背景色
      500: Color(0xFF3783FD), // primary 主题色
      600: Color(0xFFE3EAFF), // secondary 次要主题色
      700: Color(0xFF909399), // onSurfaceVariant 次要内容色
      800: Color(0xffffffff), // surfaceContainerLowest 相同色
      900: Color(0xff322f35), // inverseSurface 相反色
    },
  );

  // 暗黑主题色系
  static const MaterialColor darkColor = MaterialColor(
    0xFF3783FD,
    <int, Color>{
      50: Color(0xff141218), // surface 背景色
      100: Color(0xff1d1b20), // surfaceContainerLow 浅色背景色
      200: Color(0xff211f24), // surfaceContainer 标准背景色
      300: Color(0xff2b292f), // surfaceContainerHigh 较深背景色
      400: Color(0xff36343a), // surfaceContainerHighest 深色背景色
      500: Color(0xFF3783FD), // primary 主题色
      600: Color(0xFFE3EAFF), // secondary 次要主题色
      700: Color(0xff8E887C), // onSurfaceVariant 次要内容色
      800: Color(0xff0f0d13), // surfaceContainerLowest 相同色
      900: Color(0xffe6e0e9), // inverseSurface 相反色
    },
  );
}
