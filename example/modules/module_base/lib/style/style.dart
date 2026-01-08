import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyle {
  // 字体
  static double get fontXs => 10.sp;
  static double get fontSm => 12.sp;
  static double get fontMd => 14.sp;
  static double get fontLg => 16.sp;
  static double get fontXl => 18.sp;
  static double get fontXXl => 20.sp;

  // 图片尺寸
  static double imageXs = 32.0.w;
  static double imageSm = 48.0.w;
  static double imageMd = 64.0.w;
  static double imageLg = 96.0.w;
  static double imageXl = 120.0.w;
}

class AppColors {
  // 主题色系
  static const MaterialColor lightColor = MaterialColor(
    0xFF333FFF,
    <int, Color>{
      50: Color(0xFFFFFFFF), // surface 背景色
      100: Color(0xfff8f2fa), // surfaceContainerLow 浅色背景色
      200: Color(0xffEFF0F1), // surfaceContainer 标准背景色
      300: Color(0xffEEEEEE), // surfaceContainerHigh 较深背景色
      400: Color(0xffe6e0e9), // surfaceContainerHighest 深色背景色
      500: Color(0xFF333FFF), // primary 主题色
      600: Color(0xFFE3EAFF), // secondary 次要主题色
      700: Color(0xFF949494), // onSurfaceVariant 次要内容色
      800: Color(0xffffffff), // surfaceContainerLowest 相同色
      900: Color(0xff322f35), // inverseSurface 相反色
    },
  );

  // 暗黑主题色系
  static const MaterialColor darkColor = MaterialColor(
    0xFF333FFF,
    <int, Color>{
      50: Color(0xff141218), // surface 背景色
      100: Color(0xff1d1b20), // surfaceContainerLow 浅色背景色
      200: Color(0xff211f24), // surfaceContainer 标准背景色
      300: Color(0xff2b292f), // surfaceContainerHigh 较深背景色
      400: Color(0xff36343a), // surfaceContainerHighest 深色背景色
      500: Color(0xFF333FFF), // primary 主题色
      600: Color(0xFFE3EAFF), // secondary 次要主题色
      700: Color(0xff8E887C), // onSurfaceVariant 次要内容色
      800: Color(0xff0f0d13), // surfaceContainerLowest 相同色
      900: Color(0xffe6e0e9), // inverseSurface 相反色
    },
  );
}
