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
    if (pageSize != 20) {
      _state.updateState(pageSize: pageSize);
    }
    if (shouldInitialRefresh) {
      refresh();
    } else {
      _state.updateState(initialRefresh: shouldInitialRefresh);
      notifyListeners();
    }
  }

  bool get shouldInitialRefresh => true;

  int get pageSize => 20;

  @override
  Future<void> refresh() async {
    _state.updateState(isRefreshing: true, pageNum: 1);
    notifyListeners();
    try {
      final response = await loadData();
      _state.clear();
      _state.addData(response.data);
      _state.updateState(
        pageNum: _state.pageNum + 1,
        hasMore: _hasMoreData(response),
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
        hasMore: _hasMoreData(response),
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
    int pageSize = 20,
  }) {
    return _PagingControllerWithLoader<T>(
      dataLoader: dataLoader,
      pageSize: pageSize,
      shouldInitialRefresh: shouldInitialRefresh,
    );
  }

  /// 判断是否还有更多数据
  bool _hasMoreData(PagingResponse<T> response) {
    // 如果总页数大于0，优先使用总页数判断
    if (response.pages > 0) {
      return _state.pageNum < response.pages;
    }

    // 如果总条数大于0，使用总条数判断
    if (response.total > 0) {
      return (_state.pageNum - 1) * _state.pageSize + _state.dataList.length <
          response.total;
    }

    // 如果总页数和总条数都为0，且是数据不为空，则根据当前页数据量判断
    if (response.data.isNotEmpty) {
      return response.data.length >= _state.pageSize;
    }

    return false;
  }
}

class _PagingControllerWithLoader<T> extends PagingController<T> {
  final Future<PagingResponse<T>> Function(int page, int size) dataLoader;
  final bool _shouldInitialRefresh;
  final int _pageSize;

  _PagingControllerWithLoader({
    required this.dataLoader,
    bool shouldInitialRefresh = true,
    int pageSize = 20,
  })  : _shouldInitialRefresh = shouldInitialRefresh,
        _pageSize = pageSize;

  @override
  Future<PagingResponse<T>> loadData() async {
    return dataLoader(state.pageNum, state.pageSize);
  }

  @override
  bool get shouldInitialRefresh => _shouldInitialRefresh;

  @override
  int get pageSize => _pageSize;
}
