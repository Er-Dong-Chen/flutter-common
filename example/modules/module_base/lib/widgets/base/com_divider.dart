import 'package:flutter/material.dart';

class ComDivider extends StatelessWidget {
  final Color? color;
  final double thickness;
  final double indent;
  final double endIndent;

  const ComDivider({
    super.key,
    this.color,
    this.thickness = 0.5,
    this.indent = 0.0,
    this.endIndent = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, thickness),
      painter: _DividerPainter(
        color: color ?? Theme.of(context).colorScheme.outline,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
      ),
    );
  }
}

class _DividerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double indent;
  final double endIndent;

  const _DividerPainter({
    required this.color,
    required this.thickness,
    required this.indent,
    required this.endIndent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness;

    // 计算起点和终点（支持负数缩进）
    final startX = indent;
    final endX = size.width - endIndent;

    canvas.drawLine(
      Offset(startX, size.height / 2),
      Offset(endX, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(_DividerPainter oldDelegate) {
    return color != oldDelegate.color ||
        thickness != oldDelegate.thickness ||
        indent != oldDelegate.indent ||
        endIndent != oldDelegate.endIndent;
  }
}
