import 'package:flutter/material.dart';
import 'package:flutter_chen_common/widgets/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'logic.dart';

class ListPage extends StatelessWidget {
  ListPage({super.key});

  final logic = Get.put(ListLogic());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListLogic>(
      builder: (controller) {
        return Scaffold(
            appBar: AppBar(
              leading: const ComBack(),
              title: const Text("Refresh List"),
            ),
            body: RefreshWidget(
              controller: logic,
              slivers: [
                RefreshListWidget(
                  itemBuilder: (item, index) => _buildItem(index),
                  controller: logic,
                  useGridLayout: true,
                  layoutStrategy: const WaterfallFlowStrategy(),
                ),
              ],
            ));
      },
      id: logic.pagingState.refreshId,
    );
  }

  Widget _buildItem(index) {
    if (index % 3 == 0) {
      return Container(
        color: Colors.deepOrange,
        width: double.infinity,
        height: 300,
      );
    }
    return Container(
      color: Colors.green,
      width: double.infinity,
      height: 200,
    );
  }
}

class WaterfallFlowStrategy extends GridLayoutStrategy {
  const WaterfallFlowStrategy();

  @override
  Widget buildSliverLayout({
    required BuildContext context,
    required int crossAxisCount,
    required double spacing,
    required List<dynamic> items,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return SliverMasonryGrid.count(
      crossAxisCount: crossAxisCount,
      childCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, index),
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
    );
  }
}
