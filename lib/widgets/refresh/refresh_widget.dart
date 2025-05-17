import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../base/base_widget.dart';
import 'back_top_widget.dart';
import 'refresh_controller.dart';
import 'refresh_strategy.dart';

class RefreshWidget extends StatelessWidget {
  final PagingController controller;
  final bool enablePullUp;
  final bool enablePullDown;
  final List<Widget> slivers;

  const RefreshWidget({
    super.key,
    required this.controller,
    this.enablePullUp = true,
    this.enablePullDown = true,
    required this.slivers,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SmartRefresher(
          enablePullDown: enablePullDown,
          enablePullUp: enablePullUp && controller.pagingState.hasMore,
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          onLoading: controller.onLoadMore,
          scrollController: controller.scrollController,
          child: CustomScrollView(
            slivers: slivers,
          ),
        ),
        BackTopWidget(controller.scrollController)
      ],
    );
  }
}

class RefreshListWidget<T> extends StatelessWidget {
  final PagingController controller;
  final Widget Function(T item, int index) itemBuilder;
  final Function(T item, int index)? onItemClick;
  final GridLayoutStrategy layoutStrategy;
  final bool useGridLayout;
  final Widget? empty;
  final double? emptyTop;
  final int crossAxisCount;
  final double spacing;

  const RefreshListWidget({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.onItemClick,
    this.layoutStrategy = const StandardGridStrategy(),
    this.useGridLayout = false,
    this.empty,
    this.crossAxisCount = 2,
    this.spacing = 12,
    this.emptyTop,
  });

  @override
  Widget build(BuildContext context) {
    var data = controller.pagingState.dataList;
    if (controller.isLoading && !controller.initialRefresh) {
      return SliverToBoxAdapter(child: Container());
    } else if (controller.isLoading) {
      return SliverToBoxAdapter(
        child: Padding(
          padding:
              EdgeInsets.only(top: emptyTop != null ? (emptyTop! + 60) : 260),
          child: BaseWidget.loadingWidget(context),
        ),
      );
    } else if (data.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: emptyTop != null ? emptyTop! : 200),
          child: empty ?? BaseWidget.emptyWidget(context),
        ),
      );
    } else if (useGridLayout) {
      return layoutStrategy.buildSliverLayout(
        context: context,
        crossAxisCount: crossAxisCount,
        spacing: spacing,
        items: data,
        itemBuilder: (context, index) => _buildListItem(context, index, data),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: data.length,
          (context, index) => _buildListItem(context, index, data),
        ),
      );
    }
  }

  Widget _buildListItem(BuildContext context, int index, List dataList) {
    final item = dataList[index];
    return GestureDetector(
      onTap: () => onItemClick?.call(item, index),
      child: itemBuilder(item, index),
    );
  }
}
