import 'package:flutter/material.dart';
import 'package:flutter_chen_common/extension/extension.dart';
import 'package:get/get.dart';

class ComEmpty extends StatelessWidget {
  final Widget? image;
  final Widget? message;
  final double? imageSize;

  const ComEmpty({
    super.key,
    this.message,
    this.image,
    this.imageSize = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          image ?? _getDefaultImage(),
          SizedBox(height: context.comTheme.spacing.small),
          message ?? _getDefaultMessage(),
        ],
      ),
    );
  }

  Widget _getDefaultImage() {
    return Image.asset(
      "assets/images/empty.png",
      width: imageSize,
      height: imageSize,
    );
  }

  Widget _getDefaultMessage() {
    return Text(
      "暂无数据".tr,
      style: Theme.of(Get.context!).textTheme.bodySmall,
    );
  }
}
