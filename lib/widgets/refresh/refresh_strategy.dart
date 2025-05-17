import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class GridLayoutStrategy {
  const GridLayoutStrategy();

  Widget buildSliverLayout({
    required BuildContext context,
    required int crossAxisCount,
    required double spacing,
    required List<dynamic> items,
    required Widget Function(BuildContext, int) itemBuilder,
  });
}

class StandardGridStrategy extends GridLayoutStrategy {
  const StandardGridStrategy();

  @override
  Widget buildSliverLayout({
    required BuildContext context,
    required int crossAxisCount,
    required double spacing,
    required List<dynamic> items,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => itemBuilder(context, index),
        childCount: items.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
      ),
    );
  }
}
