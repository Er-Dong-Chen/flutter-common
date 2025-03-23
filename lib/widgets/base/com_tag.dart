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
    this.radius = 6.0,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: child,
        ),
      ),
    );
  }
}
