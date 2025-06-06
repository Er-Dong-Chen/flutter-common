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

  // 消息过滤相关
  String? _lastMessage;
  DateTime? _lastShowTime;
  int _duplicateFilterDuration = 1000; // 默认1秒内相同消息过滤（可配置）

  void init({ComToastConfig? config}) {
    _globalConfig = config;
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
      iconSize: override.iconSize,
      iconColor: override.iconColor ?? base.iconColor,
      iconSpacing: override.iconSpacing,
      builder: override.builder ?? base.builder,
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
    _timer = Timer(Duration(milliseconds: config.duration), () {
      _dismissWithAnimation();
    });
  }

  void _dismissWithAnimation() async {
    try {
      // 触发淡出动画
      await _currentToastKey?.currentState?.dismissWithAnimation();
      // 等待动画完成
      await Future.delayed(const Duration(milliseconds: 200));
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

class _ComToastWidget extends StatefulWidget {
  final String message;
  final ComToastConfig config;
  final VoidCallback onDismiss;

  const _ComToastWidget({
    required this.message,
    required this.config,
    required this.onDismiss,
  });

  @override
  State<_ComToastWidget> createState() => _ComToastWidgetState();
}

class _ComToastWidgetState extends State<_ComToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.config.animationDuration),
      vsync: this,
    );

    // 淡入淡出动画
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // 启动动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildContent() {
    final hasIcon = widget.config.icon != null;
    final children = <Widget>[];

    if (hasIcon) {
      children.add(
        Icon(
          widget.config.icon,
          size: widget.config.iconSize,
          color: widget.config.iconColor ?? _getTextColor(),
        ),
      );
      children.add(SizedBox(width: widget.config.iconSpacing));
    }

    children.add(
      Flexible(
        child: Text(
          widget.message,
          style: TextStyle(
            color: _getTextColor(),
            fontSize: widget.config.fontSize,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  double _getTopPosition() {
    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    switch (widget.config.position) {
      case ComToastPosition.top:
        return statusBarHeight + 50;
      case ComToastPosition.center:
        return screenHeight * 0.45;
      case ComToastPosition.bottom:
        return screenHeight * 0.8;
    }
  }

  /// 获取背景颜色（与主题形成反差对比）
  Color _getBackgroundColor() {
    // 如果用户明确配置了背景色，优先使用用户配置
    if (widget.config.backgroundColor != null) {
      return widget.config.backgroundColor!;
    }

    return Theme.of(context).colorScheme.inverseSurface;
  }

  /// 获取文本颜色（与背景形成对比）
  Color _getTextColor() {
    // 如果用户明确配置了文本色，优先使用用户配置
    if (widget.config.textColor != null) {
      return widget.config.textColor!;
    }

    return Theme.of(context).colorScheme.onInverseSurface;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.config.clickThrough,
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: _getTopPosition(),
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: widget.config.type == ComToastType.custom
                        ? widget.config.builder!(context)
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            padding: widget.config.padding,
                            decoration: BoxDecoration(
                              color: _getBackgroundColor(), // 使用单色背景
                              borderRadius: BorderRadius.circular(
                                  widget.config.borderRadius),
                              boxShadow: widget.config.showShadow
                                  ? [
                                      BoxShadow(
                                        color: widget.config.shadowColor,
                                        offset: widget.config.shadowOffset,
                                        blurRadius:
                                            widget.config.shadowBlurRadius,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.05),
                                width: 0.5,
                              ),
                            ),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width *
                                  widget.config.maxWidth,
                              minHeight: 52,
                            ),
                            child: _buildContent(),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> dismissWithAnimation() async {
    try {
      // 触发淡出动画
      await _controller.reverse();
    } catch (e) {
      // 如果动画失败，忽略错误
    }
  }
}
