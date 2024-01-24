import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:flutter_chen_common/common/utils/function_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool? plain;
  final bool disable;
  final Gradient? gradient;
  final double radius;
  final Color? color;
  final EdgeInsets? padding;

  const ComButton({
    super.key,
    required this.child,
    this.gradient,
    this.onPressed,
    this.style,
    this.plain = false,
    this.disable = false,
    this.radius = 30.0,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (gradient != null) {
      return Container(
        height: 42.h,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: FilledButton(
          style: FilledButton.styleFrom(
            padding: padding,
            backgroundColor: Colors.transparent,
          ),
          onPressed: disable
              ? null
              : () {
                  onPressed?.call();
                }.throttle(),
          child: child,
        ),
      );
    }
    return buildButton();
  }

  Widget buildButton() {
    if (plain!) {
      return OutlinedButton(
        style: style ??
            OutlinedButton.styleFrom(
              padding: padding,
              foregroundColor: color,
              side: BorderSide(
                color: color ?? CommonColors.theme,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
        onPressed: disable
            ? null
            : () {
                onPressed?.call();
              }.throttle(),
        child: child,
      );
    }
    return FilledButton(
      style: style ??
          FilledButton.styleFrom(
            padding: padding,
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
      onPressed: disable
          ? null
          : () {
              onPressed?.call();
            }.throttle(),
      child: child,
    );
  }
}
