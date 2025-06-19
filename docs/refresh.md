

# 智能刷新列表

## 🌟 特性

- 🚀 支持下拉刷新和上拉加载
- 🎨 内置多种布局策略（列表、网格、瀑布流）
- 🌈 支持自定义布局策略
- ⚡ 自动处理加载状态（加载中、空数据、错误）
- 🎯 支持回顶功能
- 📱 支持自定义刷新和加载动画
- 🔧 完全可配置
- 🛡️ 支持分页加载

## 📱 效果预览

![ComRefresh 效果预览](https://er-dong-chen.github.io/images/demo/refresh.gif)

## 🚀 快速开始

### 基础使用

```dart
class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late final PagingController pagingController = PagingController.withLoader(
    dataLoader: _loadData,
    pageSize: 20,
  );

  Future<PagingResponse> _loadData(int pageNum, int pageSize) async {
    final result = {
      "pages": 3,
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
        title: const Text("智能刷新列表"),
      ),
      body: SmartRefresh(
        controller: pagingController,
        itemBuilder: (_, item, index) => _buildItem(index),
      ),
      floatingActionButton: BackTopWidget(pagingController.scrollController),
    );
  }

  Widget _buildItem(index) {
    return ListTile(
      title: Text('Item $index'),
    );
  }
}

// 外部切换数据调用接口刷新：pagingController.refreshController.requestRefresh();
```

## 🎨 自定义布局

### 网格布局

```dart
SmartRefresh(
  controller: pagingController,
  strategy: const GridRefreshStrategy(
    crossAxisCount: 2,
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
  ),
  itemBuilder: (_, item, index) => _buildGridItem(index),
)
```

### 瀑布流布局

```dart
SmartRefresh(
  controller: pagingController,
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
)
```

## ⚡ 自定义控制器

### 继承 PagingController

```dart
class ListPagingController extends PagingController<dynamic> {
  @override
  Future<PagingResponse> loadData() async {
    final result = {
      "pages": 3,
      "records": List.generate(20, (i) => i + (state.pageNum - 1) * 20)
    };
    await Future.delayed(1.seconds);
    return PagingResponse.fromMapJson(result);
  }

  @override
  int get pageSize => 20;

  @override
  bool get shouldInitialRefresh => true;
}
```

### 工厂方法

```dart
final pagingController = PagingController.withLoader(
  dataLoader: _loadData,
  pageSize: 20,
);
```

## 🔧 自定义布局策略

```dart
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
```

📚 API 参考

### PagingController

| 属性              | 类型              | 描述         |
| ----------------- | ----------------- | ------------ |
| state             | RefreshState      | 刷新相关数据 |
| refreshController | RefreshController | 刷新控制器   |
| scrollController  | ScrollController  | 滑动控制器   |

| 方法 | 描述 |
|------|------|
| loadData() | 加载数据 |
| refresh() | 刷新数据 |
| loadMore() | 加载更多 |
| dispose() | 释放资源 |

### PagingResponse

| 参数 | 类型 | 描述 |
|------|------|------|
| pages | int | 总页数 |
| total | int | 总条数 |
| records | List | 数据列表 |

### SmartRefresh

| 参数 | 类型 | 描述 |
|------|------|------|
| controller | PagingController | 控制器 |
| strategy | IRefreshStrategy | 布局策略 |
| itemBuilder | WidgetBuilder | 项目构建器 |
| childBuilder | WidgetBuilder | 自定义布局构建器 | 

[其他使用以及配置参考pull_to_refresh](https://pub.dev/packages/pull_to_refresh )