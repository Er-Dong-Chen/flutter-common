import 'dart:convert';

class PagingState<T> {
  /// 分页的页数
  int pageNum = 1;
  int pageSize = 10;

  ///是否还有更多数据
  bool hasMore = true;

  /// 用于列表刷新的id
  String refreshId = DateTime.timestamp().millisecondsSinceEpoch.toString();

  /// 列表数据
  List<T> dataList = <T>[];
}

class PagingResponse<T> {
  int total;
  List<T> data = <T>[];

  PagingResponse({
    this.total = 0,
    required this.data,
  });

  factory PagingResponse.fromMapJson(Map<String, dynamic> json) {
    return PagingResponse(
      total: json['total'] == null ? 0 : json['total'] as int,
      data: json['records'] == null ? [] : json['records'] as List<T>,
    );
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
