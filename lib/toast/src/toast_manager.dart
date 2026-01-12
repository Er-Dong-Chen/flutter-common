import 'dart:async';

import 'package:flutter/material.dart';

import 'overlay_manager.dart';
import 'toast_config.dart';
import 'toast_widget.dart';

class ComToastManager {
  static final ComToastManager _instance = ComToastManager._internal();
  factory ComToastManager() => _instance;
  ComToastManager._internal();

  // 使用共用的Overlay管理器
  final ComOverlayManager _overlayManager = ComOverlayManager();

  Timer? _timer;
  ComToastConfig? _globalConfig;
  GlobalKey<ComToastWidgetState>? _currentToastKey;
  ComToastWidgetBuilder? _builder;

  // 消息过滤相关
  String? _lastMessage;
  DateTime? _lastShowTime;
  int _duplicateFilterDuration = 1000; // 默认1秒内相同消息过滤（可配置）

  void init({ComToastConfig? config}) {
    _globalConfig = config;
  }

  void initBuilder({ComToastWidgetBuilder? builder}) {
    _builder = builder;
  }

  ComToastConfig getDefaultForType(ComToastType type) {
    if (_builder != null) {
      return _builder!.getFor(type);
    }
    return ComToastConfig.getDefaultConfig(type);
  }

  /// 设置重复消息过滤时间（毫秒）
  void setDuplicateFilterDuration(int milliseconds) {
    _duplicateFilterDuration = milliseconds;
  }

  /// 清除消息过滤缓存（用于特殊情况）
  void clearMessageFilter() {
    _lastMessage = null;
    _lastShowTime = null;
  }

  /// 获取Toast显示状态
  bool get isShowing => _overlayManager.isToastShowing;

  void show(
    String message, {
    ComToastConfig? config,
    bool skipDuplicateFilter = false, // 可选：跳过重复过滤
  }) {
    // 合并配置以获取最终类型
    final finalConfig = _mergeConfigs(config);

    // 自动过滤空消息（但custom类型例外，因为它们使用builder构建内容）
    if (message.trim().isEmpty && finalConfig.type != ComToastType.custom) {
      return;
    }

    // 1秒内相同消息自动过滤（可跳过）
    if (!skipDuplicateFilter) {
      final now = DateTime.now();
      if (_lastMessage == message &&
          _lastShowTime != null &&
          now.difference(_lastShowTime!).inMilliseconds <
              _duplicateFilterDuration) {
        return;
      }

      // 记录当前消息和时间
      _lastMessage = message;
      _lastShowTime = now;
    }

    // 如果有正在显示的Toast，立即替换
    if (_overlayManager.isToastShowing) {
      _dismissCurrent();
    }

    _showToast(message, finalConfig);
  }

  /// 合并配置，按优先级：局部配置 -> 全局配置 -> 默认配置
  ComToastConfig _mergeConfigs(ComToastConfig? localConfig) {
    // 从默认配置开始
    const defaultConfig = ComToastConfig();

    // 应用全局配置（如果有）
    final baseConfig = _globalConfig != null
        ? _mergeConfig(defaultConfig, _globalConfig!)
        : defaultConfig;

    // 应用局部配置（如果有）
    return localConfig != null
        ? _mergeConfig(baseConfig, localConfig)
        : baseConfig;
  }

  /// 合并两个配置，后者覆盖前者的非空值
  ComToastConfig _mergeConfig(ComToastConfig base, ComToastConfig override) {
    return ComToastConfig(
      type: override.type,
      position: override.position,
      duration: override.duration,
      backgroundColor: override.backgroundColor ?? base.backgroundColor,
      textColor: override.textColor ?? base.textColor,
      fontSize: override.fontSize,
      padding: override.padding,
      borderRadius: override.borderRadius,
      maxWidth: override.maxWidth,
      animationDuration: override.animationDuration,
      clickThrough: override.clickThrough,
      showShadow: override.showShadow,
      shadowColor: override.shadowColor,
      shadowOffset: override.shadowOffset,
      shadowBlurRadius: override.shadowBlurRadius,
      icon: override.icon ?? base.icon,
      iconWidget: override.iconWidget ?? base.iconWidget,
      iconSize: override.iconSize,
      iconColor: override.iconColor ?? base.iconColor,
      iconSpacing: override.iconSpacing,
      builder: override.builder ?? base.builder,
      topMargin: override.topMargin,
      bottomMargin: override.bottomMargin,
    );
  }

  void _showToast(String message, ComToastConfig config) {
    _currentToastKey = GlobalKey<ComToastWidgetState>();

    final entry = OverlayEntry(
      builder: (context) => ComToastWidget(
        key: _currentToastKey!,
        message: message,
        config: config,
        onDismiss: () {
          _dismiss();
        },
      ),
    );

    _overlayManager.showToastEntry(entry);
    _timer?.cancel();
    if (config.duration > Duration.zero) {
      _timer = Timer(config.duration, () {
        _dismissWithAnimation();
      });
    }
  }

  void _dismissWithAnimation() async {
    try {
      // 触发淡出动画
      await _currentToastKey?.currentState?.dismissWithAnimation();
    } catch (e) {
      // 如果动画失败，直接关闭
    }
    _dismiss();
  }

  void _dismissCurrent() {
    try {
      _timer?.cancel();
      _overlayManager.hideToastEntry();
    } catch (e) {
      // 忽略移除失败的错误
    }
    _currentToastKey = null;
  }

  void _dismiss() {
    try {
      _overlayManager.hideToastEntry();
    } catch (e) {
      // 忽略移除失败的错误
    }
    _currentToastKey = null;
  }

  void dismiss() {
    _dismissCurrent();
  }
}
