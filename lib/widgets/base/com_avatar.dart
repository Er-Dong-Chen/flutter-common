import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';

class ComAvatar extends StatelessWidget {
  final String src;
  final double size;
  final double? radius;
  final BoxFit fit;
  final Widget? builder;

  const ComAvatar(
    this.src, {
    super.key,
    this.size = 50,
    this.radius,
    this.fit = BoxFit.cover,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? CommonStyle.rounded),
      child: CachedNetworkImage(
        imageUrl: src,
        placeholder: (context, url) => Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          color: CommonColors.theme.shade100,
          child: builder ??
              Icon(
                Icons.person,
                color: CommonColors.theme.shade200,
                size: size * 0.8,
              ),
        ),
        errorWidget: (context, url, error) => Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          color: CommonColors.theme.shade100,
          child: builder ??
              Icon(
                Icons.person,
                color: CommonColors.theme.shade200,
                size: size * 0.8,
              ),
        ),
        fadeOutDuration: const Duration(milliseconds: 300),
        fadeInDuration: const Duration(milliseconds: 500),
        fit: fit,
        width: size,
        height: size,
      ),
    );
  }
}

class ComAvatarGroup extends StatelessWidget {
  final List<String> data;
  final double size;
  final double? spacing;
  final num count;
  final Widget? builder;

  const ComAvatarGroup(
    this.data, {
    super.key,
    this.size = 30.0,
    this.spacing,
    this.count = 10,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: buildAvatarList(),
    );
  }

  List<Widget> buildAvatarList() {
    List<Widget> widgets = [];
    for (var i = 0; i < data.length; ++i) {
      var o = data[i];
      widgets.add(Positioned(
        top: 0,
        left: i * (spacing ?? (size * 0.5)),
        child: ComAvatar(o, size: size),
      ));
      if (i == count) {
        widgets.add(Positioned(
          top: 0,
          left: i * (spacing ?? (size * 0.5)),
          child: ComAvatar(
            "",
            size: size,
            builder: builder ??
                Text(
                  '${data.length >= 100 ? "99+" : data.length}',
                  style: CommonStyle.secondaryStyle,
                ),
          ),
        ));
        break;
      }
    }
    return widgets;
  }
}
