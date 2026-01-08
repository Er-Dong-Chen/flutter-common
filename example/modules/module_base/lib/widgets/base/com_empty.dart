import 'package:flutter/material.dart';
import 'package:flutter_chen_common/extension/extension.dart';

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
          message ?? _getDefaultMessage(context),
        ],
      ),
    );
  }

  Widget _getDefaultImage() {
    return Image.asset(
      "assets/images/empty.png",
      width: imageSize,
      height: imageSize,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.inbox_outlined,
          size: imageSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
      },
    );
  }

  Widget _getDefaultMessage(BuildContext context) {
    return Text(
      '暂无数据',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
