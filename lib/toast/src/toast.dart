import 'package:flutter/material.dart';

import 'loading_manager.dart';
import 'toast_config.dart';
import 'toast_manager.dart';

/// ComToast 全局实例
final ComToastManager _toastManager = ComToastManager();
final ComLoadingManager _loadingManager = ComLoadingManager();

// ignore: non_constant_identifier_names
TransitionBuilder ComToastBuilder() {
  return (context, child) {
    return _ComToastHolder(
      child: child!,
    );
  };
}

/// Simple StatelessWidget which holds the child
/// and creates an [Overlay] to display the toast
class _ComToastHolder extends StatelessWidget {
  const _ComToastHolder({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext ctx) {
            return child;
          },
        ),
      ],
    );
  }
}

class ComToast {
  /// 显示普通 Toast
  static void show(String message,
      {ComToastConfig? config, bool skipDuplicateFilter = false}) {
    _toastManager.show(message,
        config: config, skipDuplicateFilter: skipDuplicateFilter);
  }

  /// 显示自定义 Toast
  static void custom({
    required Widget Function(BuildContext) builder,
    ComToastConfig? config,
    bool skipDuplicateFilter = false,
  }) {
    final customConfig = (config ?? const ComToastConfig()).copyWith(
      type: ComToastType.custom,
      builder: builder,
    );
    _toastManager.show('',
        config: customConfig, skipDuplicateFilter: skipDuplicateFilter);
  }

  /// 关闭当前显示的 Toast
  static void dismiss() {
    _toastManager.dismiss();
  }

  /// 初始化全局配置
  static void init({ComToastConfig? config}) {
    _toastManager.init(config: config);
  }

  /// 设置重复消息过滤时间（毫秒）
  static void setDuplicateFilterDuration(int milliseconds) {
    _toastManager.setDuplicateFilterDuration(milliseconds);
  }

  /// 清除消息过滤缓存（用于测试或特殊情况）
  static void clearMessageFilter() {
    _toastManager.clearMessageFilter();
  }

  /// 统一的内置类型Toast处理方法
  static void _showBuiltInToast(
    String message,
    ComToastType type,
    ComToastConfig? config,
    bool skipDuplicateFilter,
  ) {
    final defaultConfig = ComToastConfig.getDefaultConfig(type);
    final finalConfig = config != null
        ? _mergeBuiltInConfig(defaultConfig, config, type)
        : defaultConfig;

    _toastManager.show(message,
        config: finalConfig, skipDuplicateFilter: skipDuplicateFilter);
  }

  /// 合并内置类型配置，减少重复代码
  static ComToastConfig _mergeBuiltInConfig(
    ComToastConfig defaultConfig,
    ComToastConfig userConfig,
    ComToastType type,
  ) {
    return defaultConfig.copyWith(
      type: type,
      position: userConfig.position,
      duration: userConfig.duration,
      backgroundColor: userConfig.backgroundColor,
      textColor: userConfig.textColor,
      fontSize: userConfig.fontSize,
      padding: userConfig.padding,
      borderRadius: userConfig.borderRadius,
      maxWidth: userConfig.maxWidth,
      animationDuration: userConfig.animationDuration,
      clickThrough: userConfig.clickThrough,
      showShadow: userConfig.showShadow,
      shadowColor: userConfig.shadowColor,
      shadowOffset: userConfig.shadowOffset,
      shadowBlurRadius: userConfig.shadowBlurRadius,
      icon: userConfig.icon ?? defaultConfig.icon,
      iconSize: userConfig.iconSize,
      iconColor: userConfig.iconColor ?? defaultConfig.iconColor,
      iconSpacing: userConfig.iconSpacing,
      builder: userConfig.builder,
    );
  }

  /// 显示成功 Toast
  static void success(String message,
      {ComToastConfig? config, bool skipDuplicateFilter = false}) {
    _showBuiltInToast(
        message, ComToastType.success, config, skipDuplicateFilter);
  }

  /// 显示错误 Toast
  static void error(String message,
      {ComToastConfig? config, bool skipDuplicateFilter = false}) {
    _showBuiltInToast(message, ComToastType.error, config, skipDuplicateFilter);
  }

  /// 显示警告 Toast
  static void warning(String message,
      {ComToastConfig? config, bool skipDuplicateFilter = false}) {
    _showBuiltInToast(
        message, ComToastType.warning, config, skipDuplicateFilter);
  }

  /// 显示信息 Toast
  static void info(String message,
      {ComToastConfig? config, bool skipDuplicateFilter = false}) {
    _showBuiltInToast(message, ComToastType.info, config, skipDuplicateFilter);
  }

  /// 显示Loading
  static void loading({
    String? message,
    bool barrierDismissible = false,
  }) {
    _loadingManager.showLoading(
      message: message,
      barrierDismissible: barrierDismissible,
    );
  }

  /// 显示自定义Loading
  static void customLoading({
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = false,
    ComToastConfig? config,
  }) {
    _loadingManager.showCustomLoading(
      builder: builder,
      barrierDismissible: barrierDismissible,
      config: config,
    );
  }

  /// 隐藏Loading
  static void hideLoading() {
    _loadingManager.hideLoading();
  }

  /// 获取Loading状态
  static bool get isLoadingShowing => _loadingManager.isLoadingShowing;

  /// Loading包装器方法，自动显示和隐藏loading
  /// [future] 要执行的异步操作
  /// [message] loading显示的文字
  ///
  /// 使用示例:
  /// ```dart
  /// final result = await ComToast.autoLoading(
  ///   () => api.getData(),
  ///   message: '加载数据中...',
  /// );
  /// ```
  static Future<T> autoLoading<T>(
    Future<T> Function() future, {
    String? message,
  }) async {
    try {
      loading(message: message);
      final result = await future();
      return result;
    } finally {
      hideLoading();
    }
  }
}
