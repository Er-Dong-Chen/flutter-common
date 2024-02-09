import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:flutter_chen_common/common/utils/function_util.dart';

class ComButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool? plain;
  final bool disable;
  final Gradient? gradient;
  final double radius;
  final double elevation;
  final Color? shadowColor;
  final Color? color;
  final EdgeInsets? padding;
  final bool loading;

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
    this.loading = false,
    this.shadowColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (gradient != null || elevation > 0) {
      return Container(
        height: 40,
        decoration: BoxDecoration(
          gradient: gradient,
          color: (color ?? Theme.of(context).colorScheme.primary)
              .withOpacity(loading && elevation == 0 ? 0.5 : 1),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            if (elevation > 0) ...[
              BoxShadow(
                color: shadowColor ?? Colors.black.withOpacity(0.3),
                blurRadius: elevation,
              )
            ],
          ],
        ),
        child: FilledButton(
          style: FilledButton.styleFrom(
            padding: padding,
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: Colors.white.withOpacity(0.5),
          ),
          onPressed: disable
              ? null
              : () {
                  if (!loading) {
                    onPressed?.call();
                  }
                }.throttle(),
          child: child,
        ),
      );
    }
    return buildButton(context);
  }

  Widget buildButton(BuildContext context) {
    if (plain!) {
      return OutlinedButton(
        style: style ??
            OutlinedButton.styleFrom(
              padding: padding,
              foregroundColor:
                  (color ?? CommonColors.theme).withOpacity(loading ? 0.5 : 1),
              disabledForegroundColor:
                  (color ?? CommonColors.theme).withOpacity(0.5),
              side: BorderSide(
                color: (color ?? CommonColors.theme)
                    .withOpacity(loading || disable ? 0.5 : 1),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
        onPressed: disable
            ? null
            : () {
                if (!loading) {
                  onPressed?.call();
                }
              }.throttle(),
        child: child,
      );
    }
    return FilledButton(
      style: style ??
          FilledButton.styleFrom(
            padding: padding,
            backgroundColor: (color ?? Theme.of(context).colorScheme.primary)
                .withOpacity(loading ? 0.5 : 1),
            disabledBackgroundColor:
                (color ?? Theme.of(context).colorScheme.primary)
                    .withOpacity(0.5),
            disabledForegroundColor: Colors.white.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
      onPressed: disable
          ? null
          : () {
              if (!loading) {
                onPressed?.call();
              }
            }.throttle(),
      child: child,
    );
  }
}
