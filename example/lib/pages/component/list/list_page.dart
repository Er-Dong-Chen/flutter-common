import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:module_base/widgets/base/com_arrow.dart';
import 'package:module_base/widgets/base/com_container.dart';
import 'package:module_base/widgets/base/com_tag.dart';

class ListPagingController extends PagingController<dynamic> {
  @override
  Future<PagingResponse> loadData() async {
    final result = {
      "pages": 3,
      "records": List.generate(20, (i) => i + (state.pageNum - 1) * 20)
    };
    await Future.delayed(const Duration(seconds: 1));
    return PagingResponse.fromMapJson(result);
  }

  @override
  int get pageSize => 20;

  @override
  bool get shouldInitialRefresh => true;
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  // 不同演示的控制器
  late final PagingController _listController;
  late final PagingController _gridController;
  late final PagingController _masonryController;
  late final PagingController _customController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _listController = PagingController.withLoader(
      dataLoader: _loadData,
      pageSize: 20,
    );
    _gridController = PagingController.withLoader(
      dataLoader: _loadData,
      pageSize: 16,
    );
    _masonryController = PagingController.withLoader(
      dataLoader: _loadData,
      pageSize: 12,
    );
    _customController = PagingController.withLoader(
      dataLoader: _loadData,
      pageSize: 15,
    );
  }

  Future<PagingResponse> _loadData(int pageNum, int pageSize) async {
    final result = {
      "pages": 5,
      "total": 100,
      "records": List.generate(
          pageSize,
          (i) => {
                'id': i + (pageNum - 1) * pageSize,
                'title': '列表项 ${i + (pageNum - 1) * pageSize + 1}',
                'subtitle': '这是第 ${i + (pageNum - 1) * pageSize + 1} 个项目',
                'time': DateTime.now()
                    .subtract(Duration(days: i))
                    .toString()
                    .substring(0, 19),
              })
    };
    await Future.delayed(const Duration(seconds: 2));
    return PagingResponse.fromMapJson(result);
  }

  bool _hasSimulatedError = false;

  Future<PagingResponse> _loadErrorData(int pageNum, int pageSize) async {
    await Future.delayed(const Duration(seconds: 1));
    if (pageNum == 1 && !_hasSimulatedError) {
      _hasSimulatedError = true;
      throw Exception('网络连接失败，请检查网络设置');
    }
    return _loadData(pageNum, pageSize);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _listController.dispose();
    _gridController.dispose();
    _masonryController.dispose();
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ComBack(),
        title: const Text("Refresh List"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '列表'),
            Tab(text: '网格'),
            Tab(text: '瀑布流'),
            Tab(text: '自定义策略'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            key: const PageStorageKey<String>('list'),
            child: _buildListView(),
          ),
          Container(
            key: const PageStorageKey<String>('grid'),
            child: _buildGridView(),
          ),
          Container(
            key: const PageStorageKey<String>('masonry'),
            child: _buildMasonryView(),
          ),
          Container(
            key: const PageStorageKey<String>('custom'),
            child: _buildCustomView(),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    final controllers = [
      _listController,
      _gridController,
      _masonryController,
      _customController,
    ];

    return BackTopWidget(
      controllers[_tabController.index].scrollController,
      key: ValueKey(_tabController.index),
    );
  }

  // 列表视图
  Widget _buildListView() {
    return SmartRefresh(
      controller: _listController,
      strategy: ListRefreshStrategy(),
      itemBuilder: (context, item, index) {
        final data = item as Map<String, dynamic>;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text('${data['id'] + 1}'),
          ),
          title: Text(data['title']),
          subtitle: Text(data['subtitle']),
          trailing: const ComArrow(),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('点击了 ${data['title']}')),
            );
          },
        );
      },
    );
  }

  // 网格视图
  Widget _buildGridView() {
    return SmartRefresh(
      controller: _gridController,
      strategy: const GridRefreshStrategy(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, item, index) {
        final data = item as Map<String, dynamic>;
        return ComContainer(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.apps,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                data['title'],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                data['subtitle'],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  // 瀑布流视图
  Widget _buildMasonryView() {
    return SmartRefresh(
      controller: _masonryController,
      childBuilder: (context, state) {
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
                itemBuilder: (context, index) =>
                    _buildMasonryItem(state.dataList[index], index),
              ),
            ),
          ],
        );
      },
    );
  }

  // 自定义策略视图
  Widget _buildCustomView() {
    return SmartRefresh(
      controller: _customController,
      strategy: CustomRefreshStrategy(),
      itemBuilder: (context, item, index) {
        final data = item as Map<String, dynamic>;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.ac_unit,
                    color: Colors.blue.shade700,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'],
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['subtitle'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data['time'].toString().substring(0, 16),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const ComTag(
                  color: Colors.orange,
                  child: Text('自定义'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMasonryItem(dynamic item, int index) {
    final data = item as Map<String, dynamic>;
    final height = 150.0 + (index % 5) * 50.0;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.primaries[index % Colors.primaries.length],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['title'],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data['subtitle'],
            style: const TextStyle(color: Colors.white70),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white70, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  data['time'].toString().length > 16
                      ? data['time'].toString().substring(0, 16)
                      : data['time'].toString(),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 自定义布局策略
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
