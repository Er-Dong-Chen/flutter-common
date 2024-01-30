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
          color: CommonColors.theme.shade100,
          child: Icon(
            Icons.terrain,
            color: CommonColors.theme.shade200,
          ),
        ),
        errorWidget: (context, url, error) => Container(
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
