import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/extension/extension.dart';
import 'package:get/get.dart';

class ComAvatar extends StatelessWidget {
  final String src;
  final double size;
  final double? radius;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? builder;

  const ComAvatar(
    this.src, {
    super.key,
    this.size = 50,
    this.radius,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
          radius ?? context.comTheme.shapes.circularRadius),
      child: CachedNetworkImage(
        imageUrl: src,
        placeholder: (context, url) =>
            placeholder ?? _buildDefaultPlaceholder(context),
        errorWidget: (context, url, error) =>
            placeholder ?? _buildDefaultPlaceholder(context),
        fadeOutDuration: const Duration(milliseconds: 300),
        fadeInDuration: const Duration(milliseconds: 500),
        fit: fit,
        width: size,
        height: size,
      ),
    );
  }

  Widget _buildDefaultPlaceholder(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      color: context.comTheme.theme.shade200,
      child: builder ??
          Icon(
            Icons.person,
            color: context.comTheme.theme.shade400,
            size: size * 0.8,
          ),
    );
  }
}

class ComAvatarGroup extends StatelessWidget {
  final List<String> data;
  final double size;
  final double? spacing;
  final int? maxCount;
  final Widget? builder;

  const ComAvatarGroup(
    this.data, {
    super.key,
    this.size = 30.0,
    this.spacing,
    this.maxCount,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: buildAvatarList(context),
    );
  }

  List<Widget> buildAvatarList(BuildContext context) {
    final widgets = <Widget>[];
    final displayCount = maxCount ?? data.length;

    for (var i = 0; i < data.length; ++i) {
      if (i < displayCount) {
        widgets.add(Positioned(
          top: 0,
          left: i * (spacing ?? (size * 0.5)),
          child: ComAvatar(
            data[i],
            size: size,
          ),
        ));
      } else {
        break;
      }
    }

    if (data.length > displayCount) {
      widgets.add(Positioned(
        top: 0,
        left: (displayCount - 1) * (spacing ?? (size * 0.5)),
        child: ComAvatar(
          '',
          size: size,
          placeholder: _buildDefaultOverflowWidget(data.length, context),
        ),
      ));
    }

    return widgets;
  }

  Widget _buildDefaultOverflowWidget(int count, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.comTheme.theme.shade200,
        borderRadius:
            BorderRadius.circular(context.comTheme.shapes.circularRadius),
      ),
      child: builder ??
          Text(
            '$count+',
            style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                  fontSize: size * 0.3,
                ),
          ),
    );
  }
}
