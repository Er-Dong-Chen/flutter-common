import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';

class ComTabBar extends StatelessWidget {
  final int length;
  final List<Widget> tabs;
  final int initialIndex;
  final ValueChanged<int>? onTap;
  final TabAlignment? tabAlignment;
  final BoxDecoration? indicator;
  final double indicatorBottom;
  final double indicatorWidth;
  final Color? labelColor;
  final EdgeInsets? labelPadding;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final bool? isScrollable;

  const ComTabBar({
    super.key,
    required this.length,
    required this.tabs,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.indicator,
    this.tabAlignment,
    this.labelPadding,
    this.isScrollable,
    this.onTap,
    this.initialIndex = 0,
    this.indicatorBottom = 8,
    this.indicatorWidth = 12,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: length,
      child: TabBar(
        tabAlignment: tabAlignment ?? TabAlignment.start,
        labelPadding:
            labelPadding ?? EdgeInsets.only(right: CommonStyle.spaceMd),
        isScrollable: isScrollable ?? true,
        indicator: indicator ??
            CustomUnderlineTabIndicator(
                indicatorBottom: indicatorBottom,
                indicatorWidth: indicatorWidth,
                borderSide: BorderSide(
                  width: 3,
                  color: labelColor ?? CommonColors.theme,
                )),
        labelColor: labelColor ?? CommonColors.theme,
        labelStyle: labelStyle ?? CommonStyle.titleStyle,
        unselectedLabelColor:
            unselectedLabelColor ?? CommonColors.theme.shade400,
        overlayColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return Colors.transparent;
        }),
        onTap: (index) => onTap?.call(index),
        tabs: tabs,
      ),
    );
  }
}

class CustomUnderlineTabIndicator extends Decoration {
  const CustomUnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.indicatorBottom = 0.0,
    this.indicatorWidth = 28,
    this.isRound = true,
  });
  final BorderSide borderSide;
  final EdgeInsetsGeometry insets;
  final double indicatorBottom; // 自定义指示条距离底部距离
  final double indicatorWidth; // 自定义指示条宽度
  final bool? isRound; // 自定义指示条是否是圆角

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is CustomUnderlineTabIndicator) {
      return CustomUnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is CustomUnderlineTabIndicator) {
      return CustomUnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, onChanged, isRound ?? false);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);

    //    return Rect.fromLTWH(
    //      indicator.left,
    //      indicator.bottom - borderSide.width,
    //      indicator.width,
    //      borderSide.width,
    //    );

    //取中间坐标
    double cw = (indicator.left + indicator.right) / 2;
    // ***************************这里可以自定义指示条的宽度和底部间距***************************
    Rect indicatorRect = Rect.fromLTWH(
        cw - indicatorWidth / 2,
        indicator.bottom - borderSide.width - indicatorBottom,
        indicatorWidth,
        borderSide.width);
    return indicatorRect;
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback? onChanged, this.isRound)
      : super(onChanged);

  final CustomUnderlineTabIndicator decoration;
  bool isRound = false;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = decoration
        ._indicatorRectFor(rect, textDirection)
        .deflate(decoration.borderSide.width / 2.0);
    //***************************这里可以自定义指示条是否是圆角***************************
    final Paint paint = decoration.borderSide.toPaint()
      ..strokeCap = isRound ? StrokeCap.round : StrokeCap.square;
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
