import 'package:flutter/material.dart';
import 'package:flutter_chen_common/utils/sp_util.dart';
import 'package:get/get.dart';
import 'package:module_base/module_base.dart';

class AppThemeMode {
  static ThemeData currentTheme = AppTheme.lightTheme;

  // 初始化方法，应在应用启动时调用
  static void initialize() {
    // 设置系统主题变化监听
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
      final theme = SpUtil.getString("theme", defValue: Constant.theme);
      if (theme != "light" && theme != "dark") {
        _updateCurrentThemeForSystem();
        Get.forceAppUpdate();
      }
    };
  }

  static void changeTheme(theme) {
    SpUtil.putString("theme", theme.toString());
    ThemeMode mode = getLocalThemeModel();

    Get.changeThemeMode(mode);
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
      // 跟随系统主题
      themeMode = ThemeMode.system;
      _updateCurrentThemeForSystem();
    }
    return themeMode;
  }

  static void _updateCurrentThemeForSystem() {
    final isSystemDark = _getSystemBrightness() == Brightness.dark;
    currentTheme = isSystemDark ? AppTheme.darkTheme : AppTheme.lightTheme;
  }

  static Brightness _getSystemBrightness() {
    try {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness;
    } catch (e) {
      // 如果获取失败，默认返回亮色主题
      return Brightness.light;
    }
  }
}
