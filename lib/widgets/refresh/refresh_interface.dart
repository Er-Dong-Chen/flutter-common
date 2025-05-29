import 'package:flutter/material.dart';

/// 刷新状态接口
abstract class IRefreshState<T> {
  bool get hasMore;
  List<T> get dataList;
  int get pageNum;
  int get pageSize;
  bool get initialRefresh;
  bool get isRefreshing;
  bool get isLoadingMore;
}

/// 刷新控制器接口
abstract class IRefreshController<T> extends ChangeNotifier {
  IRefreshState<T> get state;
  Future<void> refresh();
  Future<void> loadMore();
}

/// 刷新策略接口
abstract class IRefreshStrategy<T> {
  Widget buildLayout({
    required BuildContext context,
    required IRefreshState<T> state,
    required Widget Function(BuildContext, T, int) itemBuilder,
  });
}
