import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';

enum SwipeStyle {
  dots,
  rect,
  fraction,
}

class ComSwiper extends StatelessWidget {
  final List<Widget>? children;
  final Function(int index)? onTap;
  final Function(int index)? onIndexChanged;
  final double? height;
  final double? width;
  final Axis scrollDirection;
  final bool autoplay;
  final bool loop;

  final double? radius;
  final SwipeStyle style;
  final EdgeInsets swiperMargin;
  final Alignment? swipeAlignment;
  final SwiperPlugin? swiperPlugin;
  final SwiperController? swiperController;

  const ComSwiper({
    super.key,
    this.children,
    this.height,
    this.width,
    this.scrollDirection = Axis.horizontal,
    this.onTap,
    this.onIndexChanged,
    this.autoplay = false,
    this.loop = true,
    this.radius,
    this.style = SwipeStyle.dots,
    this.swiperMargin = const EdgeInsets.all(12.0),
    this.swiperPlugin,
    this.swiperController,
    this.swipeAlignment,
  });

  static const SwiperPlugin rect = RectSwiperPaginationBuilder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(radius ?? CommonStyle.roundedSm))),
      child: Swiper(
        onTap: onTap,
        onIndexChanged: onIndexChanged,
        itemBuilder: (context, index) => children![index],
        itemCount: children!.length,
        autoplay: autoplay,
        loop: autoplay,
        scrollDirection: scrollDirection,
        controller: swiperController ?? SwiperController(),
        pagination: swiperPlugin ?? buildPagination(),
      ),
    );
  }

  SwiperPagination buildPagination() {
    switch (style) {
      case SwipeStyle.dots:
        return SwiperPagination(
          alignment: swipeAlignment,
          margin: swiperMargin,
        );
      case SwipeStyle.rect:
        return SwiperPagination(
          alignment: swipeAlignment,
          margin: swiperMargin,
          builder: SwiperCustomPagination(builder: (context, config) {
            List<Widget> widgets = [];
            for (var i = 0; i < config.itemCount; ++i) {
              widgets.add(Container(
                decoration: BoxDecoration(
                  color: config.activeIndex == i
                      ? CommonColors.theme
                      : Colors.black26,
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
          alignment: swipeAlignment,
          margin: swiperMargin,
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

class RectSwiperPagination extends SwiperPlugin {
  const RectSwiperPagination({
    this.activeColor,
    this.color,
    this.key,
    this.size = const Size(8.0, 8.0),
    this.activeSize = const Size(24.0, 8.0),
    this.space = 3.0,
    this.radius = 4.0,
  });

  ///color when current index,if set null , will be Theme.of(context).primaryColor
  final Color? activeColor;

  ///,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color? color;

  ///Size of the rect when activate
  final Size activeSize;

  ///Size of the rect
  final Size size;

  /// Space between rect
  final double space;

  /// Radius of the rect
  final double radius;

  final Key? key;

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    final themeData = Theme.of(context);
    final activeColor = this.activeColor ?? themeData.primaryColor;
    final color = this.color ?? themeData.scaffoldBackgroundColor;

    final list = <Widget>[];

    final itemCount = config.itemCount;
    final activeIndex = config.activeIndex;
    if (itemCount > 20) {
      debugPrint(
        'The itemCount is too big, we suggest use FractionPaginationBuilder '
        'instead of DotSwiperPaginationBuilder in this situation',
      );
    }

    for (var i = 0; i < itemCount; ++i) {
      final active = i == activeIndex;
      final size = active ? activeSize : this.size;
      list.add(Container(
        decoration: BoxDecoration(
          color: config.activeIndex == i ? activeColor : color,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        width: size.width,
        height: size.height,
        margin: EdgeInsets.all(space),
      ));
      if (config.scrollDirection == Axis.vertical) {
        list.add(const SizedBox(width: 8));
      } else {
        list.add(const SizedBox(width: 8));
      }
    }

    if (config.scrollDirection == Axis.vertical) {
      return Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    } else {
      return Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    }
  }
}
