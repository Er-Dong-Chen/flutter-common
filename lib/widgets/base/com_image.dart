import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';

class ComImage extends StatelessWidget {
  final String src;
  final double? width;
  final double? height;
  final double? minWidth;
  final double? minHeight;
  final double? radius;
  final BoxFit fit;

  const ComImage(
    this.src, {
    super.key,
    this.width,
    this.height,
    this.radius,
    this.fit = BoxFit.cover,
    this.minWidth,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? CommonStyle.roundedMd),
      child: CachedNetworkImage(
        imageUrl: src,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          color: CommonColors.theme.shade100,
          child: Icon(
            Icons.terrain,
            color: CommonColors.theme.shade200,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          color: CommonColors.theme.shade100,
          child: Icon(
            Icons.terrain,
            color: CommonColors.theme.shade200,
          ),
        ),
        fadeOutDuration: const Duration(milliseconds: 300),
        fadeInDuration: const Duration(milliseconds: 500),
        fit: fit,
        width: src.isNotEmpty ? width : minWidth,
        height: src.isNotEmpty ? height : minHeight,
      ),
    );
  }
}

class ComImageOverlay extends StatelessWidget {
  const ComImageOverlay({
    Key? key,
    this.height,
    this.width,
    this.color,
    this.padding,
    this.margin,
    required this.image,
    this.child = const Text(''),
    this.alignment,
    this.borderRadius,
    this.colorFilter =
        const ColorFilter.mode(Colors.black26, BlendMode.colorBurn),
    this.boxFit = BoxFit.fill,
    this.border,
    this.shape = BoxShape.rectangle,
  }) : super(key: key);

  final double? height;
  final double? width;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final ImageProvider image;
  final Widget child;
  final AlignmentGeometry? alignment;
  final BoxFit? boxFit;
  final ColorFilter? colorFilter;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) => Container(
        alignment: alignment,
        height: height,
        width: width ?? MediaQuery.of(context).size.width,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: borderRadius,
          border: border,
          color: color,
          image: DecorationImage(
            fit: boxFit,
            colorFilter: colorFilter,
            image: image,
          ),
        ),
        child: child,
      );
}
