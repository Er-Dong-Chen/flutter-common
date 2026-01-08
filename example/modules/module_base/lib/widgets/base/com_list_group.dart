import 'package:flutter/material.dart';

class ComListGroup extends StatelessWidget {
  final List<Widget> children;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final double? separatorThickness;
  final Color? separatorColor;
  final double? separatorIndent;
  final double? separatorEndIndent;

  const ComListGroup({
    super.key,
    required this.children,
    this.separatorBuilder,
    this.separatorThickness,
    this.separatorColor,
    this.separatorIndent,
    this.separatorEndIndent,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
      separatorBuilder: (context, index) {
        return separatorBuilder != null
            ? separatorBuilder!(context, index)
            : Divider(
                thickness: separatorThickness,
                color: separatorColor,
                indent: separatorIndent,
                endIndent: separatorEndIndent,
              );
      },
    );
  }
}
