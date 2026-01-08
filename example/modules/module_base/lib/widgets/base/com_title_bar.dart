import 'package:flutter/material.dart';
import 'package:flutter_chen_common/extension/context_extension.dart';

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
      toolbarHeight: toolbarHeight,
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
      title: title,
      actions: actions ??
          [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding:
                    EdgeInsets.only(right: context.comTheme.spacing.medium),
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ],
    );
  }
}
