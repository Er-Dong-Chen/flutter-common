import 'package:flutter/material.dart';
import 'package:flutter_chen_common/theme/com_theme.dart';

extension ThemeContextExtension on BuildContext {
  ComTheme get comTheme =>
      Theme.of(this).extension<ComTheme>() ?? ComTheme.light();
}
