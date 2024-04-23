import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';

import 'com_image.dart';

enum SwipeStyle {
  dots,
  rect,
  fraction,
}

class ComSwiper extends StatelessWidget {
  final List<dynamic>? images;
  final List<Widget>? children;
  final ValueChanged<int>? onTap;
  final double? height;
  final EdgeInsets? margin;
  final double? radius;
  final SwipeStyle style;
  final String? name;
  final SwiperPlugin? swiperPlugin;
  final SwiperController? swiperController;
  final bool? autoplay;

  const ComSwiper({
    super.key,
    this.images,
    this.children,
    this.height,
    this.radius,
    this.style = SwipeStyle.dots,
    this.onTap,
    this.name,
    this.margin,
    this.swiperPlugin,
    this.autoplay,
    this.swiperController,
  });

  @override
  Widget build(BuildContext context) {
    if (children != null) {
      return Swiper(
        onTap: onTap,
        itemBuilder: (context, index) => children![index],
        autoplay: autoplay ?? false,
        itemCount: children!.length,
        controller: swiperController ?? SwiperController(),
        pagination: swiperPlugin ?? _buildPagination(children!.length),
      );
    } else if (images != null) {
      return Container(
        height: height,
        margin: margin,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(radius ?? CommonStyle.roundedSm))),
        child: Swiper(
          onTap: onTap,
          itemBuilder: (context, index) => name != null
              ? ComImage(images![index][name])
              : ComImage(images![index]),
          autoplay: autoplay ?? true,
          itemCount: images!.length,
          controller: swiperController ?? SwiperController(),
          pagination: swiperPlugin ?? _buildPagination(images!.length),
        ),
      );
    } else {
      return Container();
    }
  }

  SwiperPagination _buildPagination(int itemCount) {
    switch (style) {
      case SwipeStyle.dots:
        return const SwiperPagination();
      case SwipeStyle.rect:
        return SwiperPagination(
          builder: SwiperCustomPagination(builder: (context, config) {
            List<Widget> widgets = [];
            for (var i = 0; i < itemCount; ++i) {
              widgets.add(Container(
                decoration: BoxDecoration(
                  color: config.activeIndex == i
                      ? CommonColors.theme
                      : Colors.black45,
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),
                width: config.activeIndex == i ? 24 : 8,
                height: 8,
              ));
              widgets.add(const SizedBox(width: 8));
            }
            return Container(
              margin: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: widgets,
              ),
            );
          }),
        );
      case SwipeStyle.fraction:
        return SwiperPagination(
          builder: SwiperCustomPagination(builder: (context, config) {
            return Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    alignment: Alignment.center,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Text(
                      "${config.activeIndex + 1}/${config.itemCount}",
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
    }
  }
}
