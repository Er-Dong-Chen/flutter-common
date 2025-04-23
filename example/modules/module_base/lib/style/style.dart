import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:get/get.dart';

class AppStyle {
  static double buttonHeight = 46;

  // 间距
  static ComSpacing get spacing => Get.context!.comTheme.spacing;
  // 圆角
  static ComShapes get shapes => Get.context!.comTheme.shapes;

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

class AppColors {
  static MaterialColor get theme => Get.context!.comTheme.theme;

  // 主题色系
  static MaterialColor lightTheme = const MaterialColor(
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

  // 暗黑主题色系
  static const MaterialColor darkTheme = MaterialColor(
    0xFF3783FD,
    <int, Color>{
      50: Color(0xff141218), // surface 背景色
      100: Color(0xff1d1b20), // surfaceContainerLow 背景1
      200: Color(0xff211f24), // surfaceContainer 背景2
      300: Color(0xff2b292f), // surfaceContainerHigh 背景3
      400: Color(0xff36343a), // surfaceContainerHighest 背景4
      500: Color(0xFF3783FD), // primary 主题色
      600: Color(0xffe6e0e9), // onSurface 主要内容色
      700: Color(0xff8E887C), // onSurfaceVariant 次要内容色
      800: Color(0xff0f0d13), // surfaceContainerLowest 相同色
      900: Color(0xffe6e0e9), // inverseSurface 相反色
    },
  );
}
