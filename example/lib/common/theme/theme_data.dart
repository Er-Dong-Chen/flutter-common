import 'package:flutter/material.dart';
import 'package:flutter_chen_common/theme/com_theme.dart';

import '../style/style.dart';

class AppThemeData {
  static ThemeData currentTheme = lightTheme;

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.lightTheme).copyWith(
      primary: AppColors.lightTheme,
      surface: AppColors.lightTheme.shade50,
      shadow: Colors.black.withOpacity(0.1),
    ),
    extensions: [
      ComTheme.light().copyWith(
        theme: AppColors.lightTheme,
      )
    ],
    scaffoldBackgroundColor: AppColors.lightTheme.shade50,
    dialogBackgroundColor: Colors.white,
    dividerTheme: const DividerThemeData().copyWith(space: 0, thickness: 0.25),
    textTheme: const TextTheme().copyWith(
      bodySmall: TextStyle(
          fontSize: AppStyle.fontSm, color: AppColors.lightTheme.shade700),
      titleLarge: TextStyle(fontSize: AppStyle.fontXXl),
    ),
    inputDecorationTheme: const InputDecorationTheme().copyWith(
      border: InputBorder.none,
      hintStyle: TextStyle(
          fontSize: AppStyle.fontMd, color: AppColors.lightTheme.shade700),
      contentPadding: EdgeInsets.symmetric(
          vertical: ComTheme.light().spacing.small,
          horizontal: ComTheme.light().spacing.medium),
    ),
    appBarTheme: const AppBarTheme().copyWith(
      centerTitle: true,
      scrolledUnderElevation: 0.0,
    ),
    listTileTheme: const ListTileThemeData().copyWith(
      contentPadding:
          EdgeInsets.symmetric(horizontal: ComTheme.light().spacing.medium),
    ),
    checkboxTheme: const CheckboxThemeData().copyWith(
        side: BorderSide(
      color: AppColors.lightTheme.shade700,
      width: 2,
    )),
    tabBarTheme: const TabBarTheme().copyWith(
      dividerColor: Colors.transparent,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkTheme,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.darkTheme,
      // background: AppColors.darkTheme.shade50,
    ),
    extensions: [
      ComTheme.dark().copyWith(
        theme: AppColors.darkTheme,
      )
    ],
    dividerTheme: const DividerThemeData().copyWith(space: 0, thickness: 0.25),
    textTheme: const TextTheme().copyWith(
      bodySmall: TextStyle(
          fontSize: AppStyle.fontSm, color: AppColors.darkTheme.shade700),
      titleLarge: TextStyle(fontSize: AppStyle.fontXXl),
    ),
    inputDecorationTheme: const InputDecorationTheme().copyWith(
      border: InputBorder.none,
      hintStyle: TextStyle(
          fontSize: AppStyle.fontMd, color: AppColors.darkTheme.shade700),
      contentPadding: EdgeInsets.symmetric(
          vertical: ComTheme.light().spacing.small,
          horizontal: ComTheme.light().spacing.medium),
    ),
    appBarTheme: const AppBarTheme().copyWith(
      centerTitle: true,
      scrolledUnderElevation: 0.0,
    ),
    listTileTheme: const ListTileThemeData().copyWith(
      contentPadding:
          EdgeInsets.symmetric(horizontal: ComTheme.light().spacing.medium),
    ),
    checkboxTheme: const CheckboxThemeData().copyWith(
        side: BorderSide(
      color: AppColors.darkTheme.shade700,
      width: 2,
    )),
    tabBarTheme: const TabBarTheme().copyWith(
      dividerColor: Colors.transparent,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey.shade900,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey.shade300,
    ),
  );
}
