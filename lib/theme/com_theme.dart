import 'package:flutter/material.dart';

import 'com_color.dart';
import 'com_shape.dart';
import 'com_spacing.dart';

@immutable
class ComTheme extends ThemeExtension<ComTheme> {
  final MaterialColor theme;
  final Gradient primaryGradient;
  final ComShapes shapes;
  final ComSpacing spacing;

  const ComTheme({
    required this.theme,
    required this.primaryGradient,
    required this.shapes,
    required this.spacing,
  });

  // 工厂方法提供默认值
  factory ComTheme.light() => ComTheme(
        theme: ComColors.lightTheme,
        primaryGradient: LinearGradient(
          colors: [
            ComColors.lightTheme.shade500,
            ComColors.lightTheme.shade500
          ],
        ),
        shapes: ComShapes.standard,
        spacing: ComSpacing.standard,
      );

  factory ComTheme.dark() => ComTheme(
        theme: ComColors.darkTheme,
        primaryGradient: LinearGradient(
          colors: [ComColors.darkTheme.shade500, ComColors.darkTheme.shade500],
        ),
        shapes: ComShapes.standard,
        spacing: ComSpacing.standard,
      );

  @override
  ComTheme copyWith({
    MaterialColor? theme,
    Gradient? primaryGradient,
    ComShapes? shapes,
    ComSpacing? spacing,
  }) {
    return ComTheme(
      theme: theme ?? this.theme,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      shapes: shapes ?? this.shapes,
      spacing: spacing ?? this.spacing,
    );
  }

  @override
  ComTheme lerp(ThemeExtension<ComTheme>? other, double t) {
    if (other is! ComTheme) return this;

    return ComTheme(
      theme: theme,
      primaryGradient:
          Gradient.lerp(primaryGradient, other.primaryGradient, t)!,
      shapes: ComShapes.lerp(shapes, other.shapes, t),
      spacing: ComSpacing.lerp(spacing, other.spacing, t),
    );
  }
}
