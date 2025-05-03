import 'package:flutter/material.dart';

import 'com_shape.dart';
import 'com_spacing.dart';

@immutable
class ComTheme extends ThemeExtension<ComTheme> {
  final ComShapes shapes;
  final ComSpacing spacing;
  final Color? success;
  final Color? error;
  final Color? warning;
  final Color? link;

  const ComTheme({
    required this.shapes,
    required this.spacing,
    required this.success,
    required this.error,
    required this.warning,
    required this.link,
  });

  // 工厂方法提供默认值
  factory ComTheme.light() => ComTheme(
        shapes: ComShapes.standard,
        spacing: ComSpacing.standard,
        success: Colors.green.shade600,
        error: Colors.red.shade600,
        warning: Colors.orange.shade600,
        link: Colors.blue.shade600,
      );

  factory ComTheme.dark() => ComTheme(
        shapes: ComShapes.standard,
        spacing: ComSpacing.standard,
        success: Colors.green.shade500,
        error: Colors.red.shade400,
        warning: Colors.orange.shade400,
        link: Colors.blue.shade300,
      );

  @override
  ComTheme copyWith({
    MaterialColor? theme,
    Gradient? primaryGradient,
    ComShapes? shapes,
    ComSpacing? spacing,
    Color? success,
    Color? error,
    Color? warning,
    Color? link,
  }) {
    return ComTheme(
      shapes: shapes ?? this.shapes,
      spacing: spacing ?? this.spacing,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      link: link ?? this.link,
    );
  }

  @override
  ComTheme lerp(ThemeExtension<ComTheme>? other, double t) {
    if (other is! ComTheme) return this;

    return ComTheme(
      shapes: ComShapes.lerp(shapes, other.shapes, t),
      spacing: ComSpacing.lerp(spacing, other.spacing, t),
      success: Color.lerp(success, other.success, t) ?? success,
      error: Color.lerp(error, other.error, t) ?? error,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      link: Color.lerp(link, other.link, t) ?? link,
    );
  }
}
