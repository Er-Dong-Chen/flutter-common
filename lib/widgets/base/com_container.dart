import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';

class ComContainer extends StatelessWidget {
  final Widget? child;
  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? radius;
  final double elevation;
  final DecorationImage? image;
  final BoxDecoration? decoration;

  const ComContainer({
    super.key,
    this.child,
    this.alignment,
    this.width,
    this.height,
    this.padding,
    this.color,
    this.radius,
    this.margin,
    this.elevation = 0,
    this.image,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      width: width,
      height: height,
      margin: margin,
      padding: padding ??
          EdgeInsets.symmetric(
              horizontal: CommonStyle.spaceMd, vertical: CommonStyle.spaceMd),
      decoration: decoration ??
          BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.inversePrimary,
            image: image,
            borderRadius:
                BorderRadius.circular(radius ?? CommonStyle.roundedMd),
            boxShadow: [
              if (elevation > 0) ...[
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: elevation,
                  // spreadRadius: 1,
                  // offset: Offset(0, 0),
                )
              ],
            ],
          ),
      child: child,
    );
  }
}
