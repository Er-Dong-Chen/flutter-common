import 'package:flutter/material.dart';
import 'package:flutter_chen_common/widgets/refresh/refresh_state.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class PagingController<M> extends GetxController {
  /// PagingState
  PagingState<M> pagingState = PagingState();

  /// 控件的 Controller
  ScrollController scrollController = ScrollController();
  RefreshController refreshController = RefreshController();

  /// 是否加载
  bool isLoading = true;

  /// 是否首次加载
  bool initialRefresh = true;

  @override
  void onReady() {
    super.onReady();

    /// 进入页面刷新数据
    if (initialRefresh) {
      onRefresh();
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    refreshController.dispose();
  }

  /// 刷新数据
  void onRefresh() async {
    initPaging();
    await _loadData();
    isLoading = false;
    onRefreshData();

    /// 刷新完成
    refreshController.refreshCompleted();
  }

  /// 刷新其他数据
  void onRefreshData() async {}

  /// 初始化分页数据
  void initPaging() {
    pagingState.pageNum = 1;
    pagingState.hasMore = true;
    pagingState.dataList.clear();
  }

  /// 数据加载
  Future _loadData() async {
    PagingResponse<M>? pagingData = await loadData();
    List<M> list = pagingData.data;

    /// 数据不为空，则将数据添加到 data 中
    /// 并且分页页数 pageNum + 1
    if (list.isNotEmpty) {
      pagingState.dataList.addAll(list);
      pagingState.pageNum += 1;
    }

    /// 判断是否有更多数据
    if (pagingState.dataList.length < pagingState.pageSize) {
      pagingState.hasMore = false;
    } else {
      if (pagingData.total > 0) {
        pagingState.hasMore = pagingState.pageNum - 1 < pagingData.total;
      }
    }

    /// 更新界面
    update([pagingState.refreshId]);
  }

  /// 加载更多
  void onLoadMore() async {
    await _loadData();

    /// 加载完成
    refreshController.loadComplete();
  }

  /// 最终加载数据的方法
  Future<PagingResponse<M>> loadData();
}
