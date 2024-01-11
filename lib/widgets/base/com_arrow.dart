import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';

class ComArrow extends StatelessWidget {
  final double? size;
  final Color? color;
  final bool isBack;

  const ComArrow({super.key, this.size, this.isBack = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(
      isBack ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
      size: size ?? CommonStyle.fontMd,
      color: color ?? CommonColors.theme.shade300,
    );
  }
}
