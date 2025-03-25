import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_chen_common/extension/extension.dart';
import 'package:get/get.dart';

class ComLoading extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;
  const ComLoading({super.key, this.size = 50.0, this.color, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SpinKitPouringHourGlassRefined(
            color: color ?? context.comTheme.theme.shade400,
            size: size,
          ),
          SizedBox(height: context.comTheme.spacing.medium),
          Text(
            message ?? "加载中...".tr,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: color ?? context.comTheme.theme.shade400),
          ),
        ],
      ),
    );
  }
}

class SpinKitPouringHourGlassRefined extends StatefulWidget {
  const SpinKitPouringHourGlassRefined({
    super.key,
    required this.color,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 2400),
    this.strokeWidth = 2.0,
    this.controller,
  });

  final double size;
  final Color color;
  final Duration duration;
  final double strokeWidth;
  final AnimationController? controller;

  @override
  State<SpinKitPouringHourGlassRefined> createState() =>
      _SpinKitPouringHourGlassRefinedState();
}

class _SpinKitPouringHourGlassRefinedState
    extends State<SpinKitPouringHourGlassRefined>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pouringAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..repeat();
    _pouringAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.9),
    )..addListener(() => setState(() {}));
    _rotationAnimation = Tween(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.9, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _rotationAnimation,
        child: SizedBox.fromSize(
          size: Size.square(widget.size * math.sqrt1_2),
          child: CustomPaint(
            painter: _HourGlassPaint(
              poured: _pouringAnimation.value,
              color: widget.color,
              strokeWidth: widget.strokeWidth,
            ),
          ),
        ),
      ),
    );
  }
}

class _HourGlassPaint extends CustomPainter {
  _HourGlassPaint({this.strokeWidth, this.poured, required Color color})
      : _paint = Paint()
          ..style = PaintingStyle.stroke
          ..color = color,
        _powderPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = color;

  final double? strokeWidth;
  final double? poured;
  final Paint _paint;
  final Paint _powderPaint;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final halfHeight = size.height / 2;
    final hourglassWidth = math.min(centerX * 0.8, halfHeight);
    final gapWidth = math.max(3.0, hourglassWidth * 0.05);
    final yPadding = gapWidth / 2;
    final top = yPadding;
    final bottom = size.height - yPadding;
    _paint.strokeWidth = strokeWidth ?? gapWidth;

    final hourglassPath = Path()
      ..moveTo(centerX - hourglassWidth + 2, top)
      ..lineTo(centerX + hourglassWidth, top)
      ..arcToPoint(
        Offset(centerX + hourglassWidth, top + 7),
        radius: const Radius.circular(4),
        clockwise: true,
      )
      ..lineTo(centerX + hourglassWidth - 2, top + 8)
      ..quadraticBezierTo(
        centerX + hourglassWidth - 2,
        (top + halfHeight) / 2 + 2,
        centerX + gapWidth,
        halfHeight,
      )
      ..quadraticBezierTo(
        centerX + hourglassWidth - 2,
        (bottom + halfHeight) / 2,
        centerX + hourglassWidth - 2,
        bottom - 7,
      )
      ..arcToPoint(
        Offset(centerX + hourglassWidth, bottom),
        radius: const Radius.circular(4),
        clockwise: true,
      )
      ..lineTo(centerX - hourglassWidth, bottom)
      ..arcToPoint(
        Offset(centerX - hourglassWidth, bottom - 7),
        radius: const Radius.circular(4),
        clockwise: true,
      )
      ..lineTo(centerX - hourglassWidth + 2, bottom - 7)
      ..quadraticBezierTo(
        centerX - hourglassWidth + 2,
        (bottom + halfHeight) / 2,
        centerX - gapWidth,
        halfHeight,
      )
      ..quadraticBezierTo(
        centerX - hourglassWidth + 2,
        (top + halfHeight) / 2 + 2,
        centerX - hourglassWidth + 2,
        top + 7,
      )
      ..arcToPoint(
        Offset(centerX - hourglassWidth, top),
        radius: const Radius.circular(4),
        clockwise: true,
      )
      ..close();
    canvas.drawPath(hourglassPath, _paint);

    final upperPart = Path()
      ..moveTo(0.0, top)
      ..addRect(
        Rect.fromLTRB(0.0, halfHeight * poured!, size.width, halfHeight),
      );
    canvas.drawPath(
      Path.combine(PathOperation.intersect, hourglassPath, upperPart),
      _powderPaint,
    );

    final lowerPartPath = Path()
      ..moveTo(centerX, bottom)
      ..relativeLineTo(hourglassWidth * poured!, 0.0)
      ..lineTo(centerX, bottom - poured! * halfHeight - gapWidth)
      ..lineTo(centerX - hourglassWidth * poured!, bottom)
      ..close();
    final lowerPart = Path.combine(
      PathOperation.intersect,
      lowerPartPath,
      Path()..addRect(Rect.fromLTRB(0.0, halfHeight, size.width, size.height)),
    );
    canvas.drawPath(lowerPart, _powderPaint);

    canvas.drawLine(
      Offset(centerX, halfHeight),
      Offset(centerX, bottom),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class SpinKitThreeBounce extends StatefulWidget {
  const SpinKitThreeBounce({
    super.key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1400),
    this.controller,
  }) : assert(
          !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
              !(itemBuilder == null && color == null),
          'You should specify either a itemBuilder or a color',
        );

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<SpinKitThreeBounce> createState() => _SpinKitThreeBounceState();
}

class _SpinKitThreeBounceState extends State<SpinKitThreeBounce>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 2, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (i) {
            return ScaleTransition(
              scale: DelayTween(
                begin: 0.0,
                end: 1.0,
                delay: i * .2,
              ).animate(_controller),
              child: SizedBox.fromSize(
                size: Size.square(widget.size * 0.5),
                child: _itemBuilder(i),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        );
}

class DelayTween extends Tween<double> {
  DelayTween({
    super.begin,
    super.end,
    required this.delay,
  });

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
