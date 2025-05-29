import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/widgets/refresh/refresh_interface.dart';

import '../base/base_widget.dart';

/// 列表布局策略
class ListRefreshStrategy<T> implements IRefreshStrategy<T> {
  @override
  Widget buildLayout({
    required BuildContext context,
    required IRefreshState<T> state,
    required Widget Function(BuildContext, T, int) itemBuilder,
  }) {
    if (state.initialRefresh) {
      return BaseWidget.loadingWidget(context);
    } else if (state.dataList.isEmpty) {
      return BaseWidget.emptyWidget(context);
    }

    return ListView.builder(
      itemCount: state.dataList.length,
      itemBuilder: (context, index) =>
          itemBuilder(context, state.dataList[index], index),
    );
  }
}

/// 网格布局策略
class GridRefreshStrategy<T> implements IRefreshStrategy<T> {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  const GridRefreshStrategy({
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 12,
  });

  @override
  Widget buildLayout({
    required BuildContext context,
    required IRefreshState<T> state,
    required Widget Function(BuildContext, T, int) itemBuilder,
  }) {
    if (state.initialRefresh) {
      return BaseWidget.loadingWidget(context);
    } else if (state.dataList.isEmpty) {
      return BaseWidget.emptyWidget(context);
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemCount: state.dataList.length,
      itemBuilder: (context, index) =>
          itemBuilder(context, state.dataList[index], index),
    );
  }
}
