import 'package:flutter/material.dart';
import 'package:flutter_chen_common/theme/com_theme.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  ComTheme get comTheme =>
      Theme.of(this).extension<ComTheme>() ?? ComTheme.light();

  bool get isDarkMode => (theme.brightness == Brightness.dark);
}
