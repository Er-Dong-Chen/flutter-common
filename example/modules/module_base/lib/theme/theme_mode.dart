import 'package:flutter/material.dart';
import 'package:flutter_chen_common/utils/sp_util.dart';
import 'package:get/get.dart';
import 'package:module_base/module_base.dart';

class AppThemeMode {
  static ThemeData currentTheme = AppTheme.lightTheme;

  static void changeTheme(theme) {
    SpUtil.putString("theme", theme.toString());
    ThemeMode mode = getLocalThemeModel();
    ThemeData themeData = currentTheme;

    Get.changeThemeMode(mode);
    Get.changeTheme(themeData);
    Get.forceAppUpdate();
  }

  static ThemeMode getLocalThemeModel() {
    String theme = SpUtil.getString("theme", defValue: Constant.theme);
    ThemeMode themeMode = ThemeMode.light;
    if (theme == "light") {
      themeMode = ThemeMode.light;
      currentTheme = AppTheme.lightTheme;
    } else if (theme == "dark") {
      themeMode = ThemeMode.dark;
      currentTheme = AppTheme.darkTheme;
    } else {
      if (Get.context != null &&
          MediaQuery.of(Get.context!).platformBrightness == Brightness.dark) {
        currentTheme = AppTheme.darkTheme;
      } else {
        currentTheme = AppTheme.lightTheme;
      }
      themeMode = ThemeMode.system;
    }
    return themeMode;
  }
}
