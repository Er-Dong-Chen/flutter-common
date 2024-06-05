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
  final Widget? placeholder;
  final Widget? errorBuilder;

  const ComImage(
    this.src, {
    super.key,
    this.width,
    this.height,
    this.radius,
    this.fit = BoxFit.cover,
    this.minWidth,
    this.minHeight,
    this.placeholder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? CommonStyle.roundedMd),
      child: CachedNetworkImage(
        imageUrl: src,
        placeholder: (context, url) =>
            placeholder ?? _buildDefaultPlaceholder(),
        errorWidget: (context, url, error) =>
            errorBuilder ?? _buildDefaultPlaceholder(),
        fadeOutDuration: const Duration(milliseconds: 300),
        fadeInDuration: const Duration(milliseconds: 500),
        fit: fit,
        width: src.isNotEmpty ? width : minWidth,
        height: src.isNotEmpty ? height : minHeight,
      ),
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      color: CommonColors.theme.shade200,
      child: Icon(
        Icons.terrain,
        color: CommonColors.theme.shade400,
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
    this.child = const SizedBox.shrink(),
    this.alignment,
    this.borderRadius,
    this.colorFilter = const ColorFilter.mode(Colors.black54, BlendMode.darken),
    this.boxFit = BoxFit.cover,
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
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      height: height,
      width: width ?? double.infinity,
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
}
