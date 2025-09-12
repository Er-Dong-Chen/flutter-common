import 'package:flutter/material.dart';

class ComTag extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double radius;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;

  const ComTag({
    super.key,
    required this.child,
    this.color,
    this.radius = 6,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = color ?? Theme.of(context).colorScheme.primary;
    final foregroundColor = _getForegroundColor(backgroundColor);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: foregroundColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          child: child,
        ),
      ),
    );
  }

  Color _getForegroundColor(Color backgroundColor) {
    // 根据背景色亮度自动选择前景色
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}
