import 'dart:convert';

import 'refresh_interface.dart';

class RefreshState<T> implements IRefreshState<T> {
  int _pageNum = 1;
  int _pageSize = 20;
  bool _hasMore = true;
  List<T> _dataList = <T>[];
  bool _initialRefresh = true;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  String? _error;

  @override
  bool get hasMore => _hasMore;

  @override
  List<T> get dataList => _dataList;

  @override
  int get pageNum => _pageNum;

  @override
  int get pageSize => _pageSize;

  @override
  bool get initialRefresh => _initialRefresh;

  @override
  bool get isRefreshing => _isRefreshing;

  @override
  bool get isLoadingMore => _isLoadingMore;

  @override
  String? get error => _error;

  @override
  bool get hasError => _error != null;

  void updateState({
    int? pageNum,
    int? pageSize,
    bool? hasMore,
    List<T>? dataList,
    bool? initialRefresh,
    bool? isRefreshing,
    bool? isLoadingMore,
    String? error,
  }) {
    if (pageNum != null) _pageNum = pageNum;
    if (pageSize != null) _pageSize = pageSize;
    if (hasMore != null) _hasMore = hasMore;
    if (dataList != null) _dataList = dataList;
    if (initialRefresh != null) _initialRefresh = initialRefresh;
    if (isRefreshing != null) _isRefreshing = isRefreshing;
    if (isLoadingMore != null) _isLoadingMore = isLoadingMore;
    if (error != null) _error = error;
  }

  void clearError() {
    _error = null;
  }

  void addData(List<T> newData) {
    _dataList.addAll(newData);
  }

  void clear() {
    _dataList.clear();
    _hasMore = true;
    _error = null;
  }
}

class PagingResponse<T> {
  final int total;
  final int pages;
  final List<T> data;

  PagingResponse({
    this.total = 0,
    this.pages = 0,
    required this.data,
  });

  factory PagingResponse.fromMapJson(Map<String, dynamic> json) {
    return PagingResponse(
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 0,
      data: json['records'] ?? [],
    );
  }

  @override
  String toString() => jsonEncode(this);
}
