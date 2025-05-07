import 'package:flutter/material.dart';
import 'package:flutter_chen_common/theme/com_theme.dart';
import 'package:module_base/module_base.dart';

class AppTheme {
  // ThemeData
  static ThemeData get theme => AppThemeMode.currentTheme;
  // ComTheme
  static ComTheme get comTheme =>
      AppThemeMode.currentTheme.extension<ComTheme>() ?? ComTheme.light();
  // ColorScheme
  static ColorScheme get colorScheme => AppThemeMode.currentTheme.colorScheme;

  // 明亮主题
  static final ThemeData lightTheme =
      _themeData(_lightColorScheme, _comThemeLight, Brightness.light);
  // 暗黑主题
  static final ThemeData darkTheme =
      _themeData(_darkColorScheme, _comThemeDark, Brightness.dark);

  // 扩展主题实例
  static final ComTheme _comThemeLight = ComTheme.light().copyWith(
    theme: AppColors.lightColor,
  );
  static final ComTheme _comThemeDark = ComTheme.dark().copyWith(
    theme: AppColors.darkColor,
  );

  // ColorScheme
  static final ColorScheme _lightColorScheme =
      ColorScheme.fromSeed(seedColor: AppColors.lightColor).copyWith(
    primary: AppColors.lightColor,
  );
  static final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.darkColor,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppColors.darkColor,
  );

  static ThemeData _themeData(
      ColorScheme colorScheme, ComTheme comTheme, Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      extensions: [comTheme],
      scaffoldBackgroundColor: colorScheme.surface,
      dialogBackgroundColor: colorScheme.surfaceContainerLowest,
      dividerTheme:
          const DividerThemeData().copyWith(space: 0, thickness: 0.25),
      textTheme: const TextTheme().copyWith(
        bodySmall: TextStyle(
            fontSize: AppStyle.fontSm, color: colorScheme.onSurfaceVariant),
      ),
      appBarTheme: const AppBarTheme().copyWith(
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: colorScheme.surface,
      ),
      listTileTheme: const ListTileThemeData().copyWith(
          contentPadding:
              EdgeInsets.symmetric(horizontal: comTheme.spacing.medium),
          leadingAndTrailingTextStyle: TextStyle(
              fontSize: AppStyle.fontMd, color: colorScheme.onSurface)),
      checkboxTheme: const CheckboxThemeData().copyWith(
        side: BorderSide(
          color: colorScheme.outline,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      tabBarTheme: const TabBarTheme().copyWith(
        dividerColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      inputDecorationTheme: const InputDecorationTheme().copyWith(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(comTheme.shapes.circularRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(comTheme.shapes.circularRadius),
          borderSide: BorderSide(
            color: colorScheme.primary,
          ),
        ),
        hintStyle: TextStyle(
            fontSize: AppStyle.fontMd, color: colorScheme.onSurfaceVariant),
        contentPadding: EdgeInsets.symmetric(
          vertical: comTheme.spacing.small,
          horizontal: comTheme.spacing.medium,
        ),
      ),
    );
  }
}
