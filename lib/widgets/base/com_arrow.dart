import 'package:flutter/material.dart';
import 'package:flutter_chen_common/extension/extension.dart';
import 'package:get/get.dart';

enum ArrowDirection { left, right, up, down }

class ComArrow extends StatelessWidget {
  final double? size;
  final Color? color;
  final ArrowDirection direction;

  const ComArrow({
    super.key,
    this.size,
    this.color,
    this.direction = ArrowDirection.right,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIconData(direction),
      size: size ?? Theme.of(context).textTheme.bodyMedium?.fontSize,
      color: color ?? context.comTheme.theme.shade700,
    );
  }

  IconData _getIconData(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.left:
        return Icons.arrow_back_ios;
      case ArrowDirection.right:
        return Icons.arrow_forward_ios;
      case ArrowDirection.up:
        return Icons.keyboard_arrow_up;
      case ArrowDirection.down:
        return Icons.keyboard_arrow_down;
    }
  }
}

class ComBack extends StatelessWidget {
  final Color? color;
  final VoidCallback? onTap;

  const ComBack({
    super.key,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!Navigator.of(context).canPop() && onTap == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap ?? () => Get.back(),
      child: Icon(
        Icons.arrow_back_ios,
        color: color,
      ),
    );
  }
}
