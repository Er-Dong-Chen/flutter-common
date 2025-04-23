import 'package:example/common/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:get/get.dart';

class AppTheme {
  static ThemeData currentTheme = AppThemeData.lightTheme;
  static ThemeData lightTheme = AppThemeData.lightTheme;
  static ThemeData darkTheme = AppThemeData.darkTheme;
  static ComTheme comTheme = Get.context!.comTheme;

  static void changeTheme(theme) {
    SpUtil.putString("theme", theme.toString());
    ThemeMode mode = getLocalThemeModel();
    ThemeData themeData = currentTheme;

    Get.changeThemeMode(mode);
    Get.changeTheme(themeData);
    Get.forceAppUpdate();
  }

  static ThemeMode getLocalThemeModel() {
    String theme = SpUtil.getString("theme");
    ThemeMode themeMode = ThemeMode.light;
    if (theme == "light") {
      themeMode = ThemeMode.light;
      currentTheme = AppThemeData.lightTheme;
    } else if (theme == "dark") {
      themeMode = ThemeMode.dark;
      currentTheme = AppThemeData.darkTheme;
    } else {
      if (Get.context != null &&
          MediaQuery.of(Get.context!).platformBrightness == Brightness.dark) {
        currentTheme = AppThemeData.darkTheme;
      } else {
        currentTheme = AppThemeData.lightTheme;
      }
      themeMode = ThemeMode.system;
    }
    return themeMode;
  }
}
