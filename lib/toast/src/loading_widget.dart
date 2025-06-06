import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';

/// Loading专用组件
class ComLoadingWidget extends StatefulWidget {
  final String? message;
  final ComToastConfig config;
  final bool barrierDismissible;
  final VoidCallback? onDismiss;
  final bool isCustom;

  const ComLoadingWidget({
    super.key,
    this.message,
    required this.config,
    this.barrierDismissible = false,
    this.onDismiss,
    this.isCustom = false,
  });

  @override
  State<ComLoadingWidget> createState() => ComLoadingWidgetState();
}

class ComLoadingWidgetState extends State<ComLoadingWidget>
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

  Widget _buildDefaultLoading() {
    return ComLoading(
      message: widget.message,
      color: widget.config.textColor ??
          Theme.of(context).colorScheme.onInverseSurface,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // 禁用返回键
      canPop: false,
      child: Material(
        color: Colors.black54,
        child: GestureDetector(
          onTap: widget.barrierDismissible ? widget.onDismiss : null,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: widget.isCustom && widget.config.builder != null
                    ? widget.config.builder!(context)
                    : _buildDefaultLoading(),
              ),
            ),
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
