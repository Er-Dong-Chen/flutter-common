import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ListPagingController extends PagingController<dynamic> {
  @override
  Future<PagingResponse> loadData() async {
    final result = {
      "total": 2,
      "records": List.generate(20, (i) => i + (state.pageNum - 1) * 20)
    };
    await Future.delayed(1.seconds);
    return PagingResponse.fromMapJson(result);
  }
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  // 一：继承PagingController
  // final pagingController = ListPagingController();
  // 二：工厂方法
  late final PagingController pagingController = PagingController.withLoader(
    dataLoader: _loadData,
  );

  Future<PagingResponse> _loadData(int pageNum, int pageSize) async {
    final result = {
      "total": 2,
      "records": List.generate(20, (i) => i + (pageNum - 1) * 20)
    };
    await Future.delayed(1.seconds);
    return PagingResponse.fromMapJson(result);
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ComBack(),
        title: const Text("Refresh List"),
      ),
      body: SmartRefresh(
        controller: pagingController,
        // 一：策略形式，默认列表策略
        // strategy: const ListRefreshStrategy(),
        // itemBuilder: (_, item, index) => _buildItem(index),
        // 二：childBuilder自定义
        childBuilder: (_, state) {
          if (state.initialRefresh) {
            return BaseWidget.loadingWidget(context);
          } else if (state.dataList.isEmpty) {
            return BaseWidget.emptyWidget(context);
          }
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childCount: state.dataList.length,
                  itemBuilder: (context, index) => _buildItem(index),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: BackTopWidget(pagingController.scrollController),
    );
  }

  Widget _buildItem(index) {
    final height = 150.0 + (index % 5) * 50.0;
    return Container(
      color: Colors.primaries[index % Colors.primaries.length],
      height: height,
      child: Center(
        child: Text('Item $index', style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

/// 三：自定义实现布局策略，全局复用
class CustomRefreshStrategy<T> implements IRefreshStrategy<T> {
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
