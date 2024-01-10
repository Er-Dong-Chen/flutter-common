import 'package:flutter/material.dart';

class ComRadio extends StatelessWidget {
  final bool value;
  final double size;
  final double radius;
  final Color? activeColor;

  const ComRadio({
    super.key,
    required this.value,
    this.size = 24,
    this.radius = 999,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return !value
        ? Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(radius)),
                border: Border.all(color: const Color(0xFFc5c6c5), width: 1)),
          )
        : Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(radius)),
                color: activeColor ?? Theme.of(context).primaryColor),
            child: Icon(
              Icons.check,
              size: size - 4,
              color: Colors.white,
            ),
          );
  }
}
