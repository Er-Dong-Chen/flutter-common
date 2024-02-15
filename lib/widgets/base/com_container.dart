import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:get/get.dart';

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
  final Color? shadowColor;
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
    this.shadowColor,
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
            color: color ??
                (Get.isDarkMode
                    ? Colors.grey.shade900
                    : Theme.of(context).colorScheme.inversePrimary),
            image: image,
            borderRadius:
                BorderRadius.circular(radius ?? CommonStyle.roundedMd),
            boxShadow: [
              if (elevation > 0) ...[
                BoxShadow(
                  color: shadowColor ?? Theme.of(context).colorScheme.shadow,
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
