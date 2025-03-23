import 'package:flutter/material.dart';

class ComColors {
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
