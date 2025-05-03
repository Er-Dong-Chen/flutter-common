import 'package:flutter/material.dart';
import 'package:flutter_chen_common/theme/com_theme.dart';

extension ContextExtension on BuildContext {
  ComTheme get comTheme =>
      Theme.of(this).extension<ComTheme>() ?? ComTheme.light();
}
