import 'package:flutter/material.dart';

/// 设计系统形状配置类
/// 提供圆角体系配置与解析能力，支持全局/组件级自定义
@immutable
class ComShapes {
  //-------------------
  // 基础圆角体系
  //-------------------

  /// 基础圆角（用于常规组件）
  final double baseRadius;

  /// 小圆角（用于紧凑型组件）
  final double smallRadius;

  /// 大圆角（用于强调型组件）
  final double largeRadius;

  /// 特殊圆角：强制圆形（通常用于头像等）
  final double circularRadius;

  //-------------------
  // 组件级圆角（可选覆盖）
  //-------------------

  final double? buttonRadius;
  final double? cardRadius;
  final double? dialogRadius;

  const ComShapes({
    // 基础圆角体系（必须参数）
    required this.baseRadius,
    required this.smallRadius,
    required this.largeRadius,

    /// 强制圆形配置（默认999实现完美圆形）
    this.circularRadius = 999.0,

    // 组件级圆角（可选覆盖）
    this.buttonRadius,
    this.cardRadius,
    this.dialogRadius,
  })  : assert(baseRadius >= 0 && baseRadius <= 32),
        assert(smallRadius <= baseRadius),
        assert(largeRadius >= baseRadius);

  //-------------------
  // 预设配置方案
  //-------------------

  /// 默认配置（Material Design 标准）
  static const standard = ComShapes(
    baseRadius: 8.0,
    smallRadius: 4.0,
    largeRadius: 16.0,
  );

  /// 紧凑型配置
  static const compact = ComShapes(
    baseRadius: 4.0,
    smallRadius: 2.0,
    largeRadius: 8.0,
  );

  /// 圆角配置
  static const rounded = ComShapes(
    baseRadius: 16.0,
    smallRadius: 8.0,
    largeRadius: 32.0,
  );

  //-------------------
  // 解析方法
  //-------------------

  /// 解析按钮圆角（优先使用组件级配置）
  double get resolvedButtonRadius => buttonRadius ?? baseRadius;

  /// 解析卡片圆角（优先使用组件级配置）
  double get resolvedCardRadius => cardRadius ?? baseRadius;

  /// 解析对话框圆角（默认使用大圆角）
  double get resolvedDialogRadius => dialogRadius ?? largeRadius;

  //-------------------
  // 工具方法
  //-------------------

  /// 拷贝并覆盖配置
  ComShapes copyWith({
    double? baseRadius,
    double? smallRadius,
    double? largeRadius,
    double? buttonRadius,
    double? cardRadius,
    double? dialogRadius,
  }) {
    return ComShapes(
      baseRadius: baseRadius ?? this.baseRadius,
      smallRadius: smallRadius ?? this.smallRadius,
      largeRadius: largeRadius ?? this.largeRadius,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      cardRadius: cardRadius ?? this.cardRadius,
      dialogRadius: dialogRadius ?? this.dialogRadius,
    );
  }

  /// 线性插值（用于主题切换动画）
  static ComShapes lerp(ComShapes a, ComShapes b, double t) {
    return ComShapes(
      baseRadius: _lerpDouble(a.baseRadius, b.baseRadius, t),
      smallRadius: _lerpDouble(a.smallRadius, b.smallRadius, t),
      largeRadius: _lerpDouble(a.largeRadius, b.largeRadius, t),
      buttonRadius: _lerpDouble(a.buttonRadius, b.buttonRadius, t),
      cardRadius: _lerpDouble(a.cardRadius, b.cardRadius, t),
      dialogRadius: _lerpDouble(a.dialogRadius, b.dialogRadius, t),
    );
  }

  static double _lerpDouble(double? a, double? b, double t) {
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }
}
