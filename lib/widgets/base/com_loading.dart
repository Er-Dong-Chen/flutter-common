import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComLoading extends StatelessWidget {
  final double size;
  final Color? color;
  const ComLoading({super.key, this.size = 16, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        radius: size,
        color: color ?? (!Get.isDarkMode ? Colors.white : Colors.black54),
      ),
    );
  }
}
