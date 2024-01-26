import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComRadio extends StatelessWidget {
  final bool value;
  final double size;
  final Color? activeColor;
  final Color? color;
  final Widget? selectIcon;
  final Widget? unselectIcon;

  const ComRadio({
    super.key,
    required this.value,
    this.size = 24,
    this.activeColor,
    this.color,
    this.selectIcon,
    this.unselectIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: !value
          ? unselectIcon ??
              Icon(
                CupertinoIcons.circle,
                size: size,
                color: color ?? Colors.grey.shade400,
              )
          : selectIcon ??
              Icon(CupertinoIcons.check_mark_circled_solid,
                  size: size,
                  color: activeColor ?? Theme.of(context).primaryColor),
    );
  }
}
