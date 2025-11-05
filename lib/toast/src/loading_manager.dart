import 'dart:async';

import 'package:flutter/material.dart';

import 'loading_widget.dart';
import 'overlay_manager.dart';
import 'toast_config.dart';

/// Loading管理器
class ComLoadingManager {
  static final ComLoadingManager _instance = ComLoadingManager._internal();
  factory ComLoadingManager() => _instance;
  ComLoadingManager._internal();

  // 使用共用的Overlay管理器
  final ComOverlayManager _overlayManager = ComOverlayManager();
  GlobalKey<ComLoadingWidgetState>? _currentLoadingKey;

  /// 显示普通loading
  void showLoading({
    String? message,
    bool barrierDismissible = false,
  }) {
    if (_overlayManager.isLoadingShowing) return;

    final loadingConfig =
        ComToastConfig.getDefaultConfig(ComToastType.loading).copyWith(
      clickThrough: !barrierDismissible, // 如果可以外部点击关闭，则不穿透
    );

    _currentLoadingKey = GlobalKey<ComLoadingWidgetState>();

    final entry = OverlayEntry(
      builder: (context) => ComLoadingWidget(
        key: _currentLoadingKey!,
        message: message,
        config: loadingConfig,
        barrierDismissible: barrierDismissible,
        onDismiss: barrierDismissible ? () => hideLoading() : null,
      ),
    );

    _overlayManager.showLoadingEntry(entry);
  }

  /// 显示自定义loading
  void showCustomLoading({
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = false,
    ComToastConfig? config,
  }) {
    if (_overlayManager.isLoadingShowing) return;

    final loadingConfig =
        (config ?? ComToastConfig.getDefaultConfig(ComToastType.loading))
            .copyWith(
      type: ComToastType.custom,
      builder: builder,
      clickThrough: !barrierDismissible,
    );

    _currentLoadingKey = GlobalKey<ComLoadingWidgetState>();

    final entry = OverlayEntry(
      builder: (context) => ComLoadingWidget(
        key: _currentLoadingKey!,
        message: '', // 自定义loading不使用message
        config: loadingConfig,
        barrierDismissible: barrierDismissible,
        onDismiss: barrierDismissible ? () => hideLoading() : null,
        isCustom: true, // 标记为自定义类型
      ),
    );

    _overlayManager.showLoadingEntry(entry);
  }

  /// 隐藏loading（带动画）
  void hideLoading() async {
    if (!_overlayManager.isLoadingShowing) return;

    try {
      // 触发淡出动画
      await _currentLoadingKey?.currentState?.dismissWithAnimation();
      // 等待动画完成
      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      // 如果动画失败，直接关闭
    }

    _overlayManager.hideLoadingEntry();
    _currentLoadingKey = null;
  }

  /// 立即隐藏loading（无动画）
  void hideLoadingImmediately() {
    _overlayManager.hideLoadingEntry();
    _currentLoadingKey = null;
  }

  /// 获取loading状态
  bool get isLoadingShowing => _overlayManager.isLoadingShowing;
}
