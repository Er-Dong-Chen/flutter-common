import 'package:flutter/material.dart';

import 'loading_manager.dart';

/// Toast系统路由观察者
/// 用于监听路由变化，统一管理Toast和Loading的自动关闭行为
class ComToastNavigatorObserver extends NavigatorObserver {
  static final ComToastNavigatorObserver _instance =
      ComToastNavigatorObserver._internal();
  factory ComToastNavigatorObserver() => _instance;
  ComToastNavigatorObserver._internal();

  final ComLoadingManager _loadingManager = ComLoadingManager();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _handleRouteChange();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _handleRouteChange();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _handleRouteChange();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _handleRouteChange();
  }

  /// 统一处理路由变化
  void _handleRouteChange() {
    // 页面变化时立即关闭Loading（不使用动画，因为用户已经离开页面）
    if (_loadingManager.isLoadingShowing) {
      _loadingManager.hideLoadingImmediately();
    }

    // 可选：页面变化时也可以关闭Toast（根据需求配置）
    // if (_toastManager.isShowing) {
    //   _toastManager.dismiss();
    // }
  }
}
