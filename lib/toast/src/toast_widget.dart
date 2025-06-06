import 'package:flutter/material.dart';

import 'toast_config.dart';

/// Toast组件
class ComToastWidget extends StatefulWidget {
  final String message;
  final ComToastConfig config;
  final VoidCallback onDismiss;

  const ComToastWidget({
    super.key,
    required this.message,
    required this.config,
    required this.onDismiss,
  });

  @override
  State<ComToastWidget> createState() => ComToastWidgetState();
}

class ComToastWidgetState extends State<ComToastWidget>
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
                              color: _getBackgroundColor(),
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

  /// 触发淡出动画
  Future<void> dismissWithAnimation() async {
    try {
      // 触发淡出动画
      await _controller.reverse();
    } catch (e) {
      // 如果动画失败，忽略错误
    }
  }
}
