import 'package:flutter/material.dart';

enum ComToastType {
  normal,
  success,
  error,
  warning,
  info,
  custom,
  loading,
}

class ComToastConfig {
  /// Toast 类型
  final ComToastType type;

  /// Toast 显示位置
  final ComToastPosition position;

  /// Toast 显示时长（毫秒）
  final int duration;

  /// Toast 背景颜色（null表示使用主题适配）
  final Color? backgroundColor;

  /// Toast 文字颜色（null表示使用主题适配）
  final Color? textColor;

  /// Toast 文字大小
  final double fontSize;

  /// Toast 内边距
  final EdgeInsets padding;

  /// Toast 圆角
  final double borderRadius;

  /// Toast 最大宽度
  final double maxWidth;

  /// Toast 动画时长（毫秒）
  final int animationDuration;

  /// Toast 是否可点击穿透
  final bool clickThrough;

  /// Toast 是否显示阴影
  final bool showShadow;

  /// Toast 阴影颜色
  final Color shadowColor;

  /// Toast 阴影偏移
  final Offset shadowOffset;

  /// Toast 阴影模糊半径
  final double shadowBlurRadius;

  /// Toast 图标
  final IconData? icon;

  /// Toast 图标大小
  final double iconSize;

  /// Toast 图标颜色
  final Color? iconColor;

  /// Toast 图标与文字间距
  final double iconSpacing;

  /// Toast 自定义内容构建器
  final Widget Function(BuildContext context)? builder;

  const ComToastConfig({
    this.type = ComToastType.normal,
    this.position = ComToastPosition.center,
    this.duration = 2000,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 14.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    this.borderRadius = 12.0,
    this.maxWidth = 0.85,
    this.animationDuration = 300,
    this.clickThrough = true,
    this.showShadow = true,
    this.shadowColor = const Color(0x1A000000),
    this.shadowOffset = const Offset(0, 4),
    this.shadowBlurRadius = 8.0,
    this.icon,
    this.iconSize = 20.0,
    this.iconColor,
    this.iconSpacing = 8.0,
    this.builder,
  });

  ComToastConfig copyWith({
    ComToastType? type,
    ComToastPosition? position,
    int? duration,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
    EdgeInsets? padding,
    double? borderRadius,
    double? maxWidth,
    int? animationDuration,
    bool? clickThrough,
    bool? showShadow,
    Color? shadowColor,
    Offset? shadowOffset,
    double? shadowBlurRadius,
    IconData? icon,
    double? iconSize,
    Color? iconColor,
    double? iconSpacing,
    Widget Function(BuildContext context)? builder,
  }) {
    return ComToastConfig(
      type: type ?? this.type,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      maxWidth: maxWidth ?? this.maxWidth,
      animationDuration: animationDuration ?? this.animationDuration,
      clickThrough: clickThrough ?? this.clickThrough,
      showShadow: showShadow ?? this.showShadow,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      icon: icon ?? this.icon,
      iconSize: iconSize ?? this.iconSize,
      iconColor: iconColor ?? this.iconColor,
      iconSpacing: iconSpacing ?? this.iconSpacing,
      builder: builder ?? this.builder,
    );
  }

  /// 获取默认配置
  static ComToastConfig getDefaultConfig(ComToastType type) {
    switch (type) {
      case ComToastType.success:
        return const ComToastConfig(
          type: ComToastType.success,
          icon: Icons.check_circle,
          iconColor: Color(0xFF10B981),
        );
      case ComToastType.error:
        return const ComToastConfig(
          type: ComToastType.error,
          icon: Icons.error,
          iconColor: Color(0xFFEF4444),
        );
      case ComToastType.warning:
        return const ComToastConfig(
          type: ComToastType.warning,
          icon: Icons.warning,
          iconColor: Color(0xFFF59E0B),
        );
      case ComToastType.info:
        return const ComToastConfig(
          type: ComToastType.info,
          icon: Icons.info,
          iconColor: Color(0xFF3B82F6),
        );
      case ComToastType.loading:
        return const ComToastConfig(
          type: ComToastType.loading,
          duration: -1,
          clickThrough: false,
        );
      default:
        return const ComToastConfig();
    }
  }
}

enum ComToastPosition {
  top,
  center,
  bottom,
}
