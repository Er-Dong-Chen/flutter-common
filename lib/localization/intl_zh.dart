import 'com_intl.dart';

class ZhCnIntl extends ComIntl {
  @override
  String get cancel => "取消";
  @override
  String get confirm => "确认";
  @override
  String get loading => "加载中...";
  @override
  String get noData => "没有数据";
  @override
  String get loadingFailed => "加载失败";
  @override
  String get networkError => "网络错误，请检查后重试";
  @override
  String get networkRetry => "点击重试";
}
