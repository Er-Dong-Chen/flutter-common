import 'package:flutter/material.dart';

@immutable
class ComSpacing {
  /// 基础间距体系
  final double extraSmall;
  final double small;
  final double medium;
  final double large;
  final double extraLarge;

  /// 组件间距
  final EdgeInsets? cardPadding;

  const ComSpacing({
    /// 基础间距（必须参数）
    required this.extraSmall,
    required this.small,
    required this.medium,
    required this.large,
    required this.extraLarge,

    /// 组件级覆盖
    this.cardPadding,
  }) : assert(
            extraSmall < small &&
                small < medium &&
                medium < large &&
                large < extraLarge,
            '间距值必须按递增顺序排列');

  /// 默认配置
  static const standard = ComSpacing(
    extraSmall: 4.0,
    small: 12.0,
    medium: 16.0,
    large: 24.0,
    extraLarge: 32.0,
  );

  /// 紧凑配置
  static const compact = ComSpacing(
    extraSmall: 2.0,
    small: 4.0,
    medium: 8.0,
    large: 16.0,
    extraLarge: 24.0,
  );

  /// 宽松配置
  static const relaxed = ComSpacing(
    extraSmall: 8.0,
    small: 12.0,
    medium: 24.0,
    large: 32.0,
    extraLarge: 48.0,
  );

  /// 获取组件最终值（优先使用组件级配置）
  EdgeInsets get resolvedCardPadding =>
      cardPadding ??
      EdgeInsets.symmetric(
        horizontal: medium,
        vertical: small,
      );

  /// 拷贝方法
  ComSpacing copyWith({
    double? extraSmall,
    double? small,
    double? medium,
    double? large,
    double? extraLarge,
    EdgeInsets? cardPadding,
  }) {
    return ComSpacing(
      extraSmall: extraSmall ?? this.extraSmall,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      extraLarge: extraLarge ?? this.extraLarge,
      cardPadding: cardPadding ?? this.cardPadding,
    );
  }

  /// 插值计算
  static ComSpacing lerp(ComSpacing a, ComSpacing b, double t) {
    return ComSpacing(
      extraSmall: _lerpDouble(a.extraSmall, b.extraSmall, t),
      small: _lerpDouble(a.small, b.small, t),
      medium: _lerpDouble(a.medium, b.medium, t),
      large: _lerpDouble(a.large, b.large, t),
      extraLarge: _lerpDouble(a.extraLarge, b.extraLarge, t),
      cardPadding: EdgeInsets.lerp(a.cardPadding, b.cardPadding, t),
    );
  }

  static double _lerpDouble(double a, double? b, double t) {
    return b == null ? a : a + (b - a) * t;
  }
}
