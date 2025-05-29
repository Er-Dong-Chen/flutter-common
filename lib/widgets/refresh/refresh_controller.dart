import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class PagingController<T> extends ChangeNotifier
    implements IRefreshController<T> {
  final RefreshState<T> _state = RefreshState<T>();
  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController = RefreshController();

  @override
  IRefreshState<T> get state => _state;

  PagingController() {
    if (shouldInitialRefresh) {
      refresh();
    } else {
      _state.updateState(initialRefresh: shouldInitialRefresh);
      notifyListeners();
    }
  }

  bool get shouldInitialRefresh => true;

  @override
  Future<void> refresh() async {
    _state.updateState(isRefreshing: true);
    notifyListeners();
    try {
      final response = await loadData();
      _state.clear();
      _state.addData(response.data);
      _state.updateState(
        hasMore: _state.dataList.length >= _state.pageSize,
        initialRefresh: false,
        isRefreshing: false,
      );
      refreshController.refreshCompleted();
    } catch (e) {
      _state.updateState(
        hasMore: false,
        isRefreshing: false,
      );
      refreshController.refreshFailed();
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> loadMore() async {
    if (!_state.hasMore) return;

    _state.updateState(isLoadingMore: true);
    notifyListeners();
    try {
      final response = await loadData();
      _state.addData(response.data);
      _state.updateState(
        pageNum: _state.pageNum + 1,
        hasMore: _state.pageNum + 1 < response.total,
        isLoadingMore: false,
      );
      refreshController.loadComplete();
    } catch (e) {
      _state.updateState(isLoadingMore: false);
      refreshController.loadFailed();
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  Future<PagingResponse<T>> loadData();

  factory PagingController.withLoader({
    required Future<PagingResponse<T>> Function(int page, int size) dataLoader,
    bool shouldInitialRefresh = true,
  }) {
    return _PagingControllerWithLoader<T>(
      dataLoader: dataLoader,
      shouldInitialRefresh: shouldInitialRefresh,
    );
  }
}

class _PagingControllerWithLoader<T> extends PagingController<T> {
  final Future<PagingResponse<T>> Function(int page, int size) dataLoader;
  final bool _shouldInitialRefresh;

  _PagingControllerWithLoader({
    required this.dataLoader,
    bool shouldInitialRefresh = true,
  }) : _shouldInitialRefresh = shouldInitialRefresh;

  @override
  Future<PagingResponse<T>> loadData() async {
    return dataLoader(state.pageNum, state.pageSize);
  }

  @override
  bool get shouldInitialRefresh => _shouldInitialRefresh;
}
