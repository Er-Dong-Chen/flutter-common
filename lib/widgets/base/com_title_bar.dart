import 'package:flutter/material.dart';
import 'package:flutter_chen_common/extension/extension.dart';
import 'package:get/get.dart';

/// 主要为底部弹窗标题栏
class ComTitleBar extends StatelessWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final double? toolbarHeight;
  final Color? backgroundColor;

  const ComTitleBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.toolbarHeight,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      automaticallyImplyLeading: false,
      centerTitle: true,
      toolbarHeight: toolbarHeight ?? 48,
      titleTextStyle: Theme.of(context).textTheme.titleSmall,
      title: title,
      actions: actions ??
          [
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.close,
                color: context.comTheme.theme.shade700,
                size: 20,
              ),
            ).paddingOnly(right: context.comTheme.spacing.medium),
          ],
    );
  }
}
