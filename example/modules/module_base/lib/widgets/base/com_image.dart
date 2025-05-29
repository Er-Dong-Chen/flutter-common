import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/extension/extension.dart';

class ComImage extends StatelessWidget {
  final String src;
  final double? width;
  final double? height;
  final double minWidth;
  final double minHeight;
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
    this.minWidth = 50,
    this.minHeight = 50,
    this.placeholder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(radius ?? context.comTheme.shapes.mediumRadius),
      child: Container(
        constraints: BoxConstraints(
          minWidth: width ?? minWidth,
          minHeight: height ?? minHeight,
        ),
        child: src.isEmpty
            ? _buildDefaultPlaceholder(context)
            : isNetworkImage(src)
                ? CachedNetworkImage(
                    imageUrl: src,
                    placeholder: (context, url) =>
                        placeholder ?? _buildDefaultPlaceholder(context),
                    errorWidget: (context, url, error) =>
                        errorBuilder ?? _buildDefaultPlaceholder(context),
                    fadeOutDuration: const Duration(milliseconds: 300),
                    fadeInDuration: const Duration(milliseconds: 500),
                    fit: fit,
                    width: width,
                    height: height,
                  )
                : Image.asset(
                    src,
                    fit: fit,
                    width: width,
                    height: height,
                    errorBuilder: (context, url, error) =>
                        errorBuilder ?? _buildDefaultPlaceholder(context),
                  ),
      ),
    );
  }

  bool isNetworkImage(String src) {
    final uri = Uri.tryParse(src);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Widget _buildDefaultPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Icon(
        Icons.terrain,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}

class ComImageOverlay extends StatelessWidget {
  const ComImageOverlay({
    super.key,
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
  });

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
