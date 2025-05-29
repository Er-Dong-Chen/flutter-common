import 'package:flutter/material.dart';
import 'package:flutter_chen_common/widgets/refresh/refresh_strategy.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'refresh_controller.dart';
import 'refresh_interface.dart';

class SmartRefresh<T> extends StatelessWidget {
  final PagingController<T> controller;
  final IRefreshStrategy<T>? strategy;
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;
  final Widget Function(BuildContext context, IRefreshState<T> state)?
      childBuilder;
  final bool enablePullUp;
  final bool enablePullDown;
  final bool? reverse;
  final ScrollPhysics? physics;
  final Axis? scrollDirection;

  const SmartRefresh({
    super.key,
    required this.controller,
    this.strategy,
    this.itemBuilder,
    this.childBuilder,
    this.enablePullUp = true,
    this.enablePullDown = true,
    this.reverse,
    this.physics,
    this.scrollDirection,
  }) : assert(itemBuilder != null || childBuilder != null);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final content = childBuilder != null
            ? childBuilder!(context, controller.state)
            : (strategy ?? ListRefreshStrategy()).buildLayout(
                context: context,
                state: controller.state,
                itemBuilder: itemBuilder!,
              );

        return SmartRefresher(
          enablePullDown: enablePullDown,
          enablePullUp: enablePullUp &&
              controller.state.hasMore &&
              !controller.state.isRefreshing,
          controller: controller.refreshController,
          onRefresh: controller.refresh,
          onLoading: controller.loadMore,
          scrollController: controller.scrollController,
          reverse: reverse,
          physics: physics,
          scrollDirection: scrollDirection,
          child: content,
        );
      },
    );
  }
}
