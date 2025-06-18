import 'package:flutter/material.dart';

/// 跑马灯滚动方向
enum MarqueeDirection {
  /// 向左滚动
  left,

  /// 向右滚动
  right,

  /// 向上滚动
  up,

  /// 向下滚动
  down,
}

/// 跑马灯组件
class ComMarquee extends StatefulWidget {
  /// 要滚动的子组件
  final Widget child;

  /// 滚动方向
  final MarqueeDirection direction;

  /// 滚动速度（每秒移动的像素数）
  final double speed;

  /// 是否无限循环
  final bool infinite;

  /// 是否自动开始滚动
  final bool autoStart;

  /// 滚动间隔（毫秒）
  final int pauseDuration;

  /// 是否在鼠标悬停时暂停
  final bool pauseOnHover;

  /// 滚动完成回调
  final VoidCallback? onComplete;

  const ComMarquee({
    super.key,
    required this.child,
    this.direction = MarqueeDirection.left,
    this.speed = 50.0,
    this.infinite = true,
    this.autoStart = true,
    this.pauseDuration = 0,
    this.pauseOnHover = false,
    this.onComplete,
  });

  @override
  State<ComMarquee> createState() => _ComMarqueeState();
}

class _ComMarqueeState extends State<ComMarquee> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isHovering = false;
  bool _isPaused = false;
  bool _isContentMeasured = false;
  bool _isFirstFrame = true;
  Size? _lastContentSize;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.infinite) {
          _controller.reset();
          if (widget.pauseDuration > 0) {
            Future.delayed(Duration(milliseconds: widget.pauseDuration), () {
              if (mounted && !_isPaused && !_isHovering) {
                _controller.forward();
              }
            });
          } else {
            if (!_isPaused && !_isHovering) {
              _controller.forward();
            }
          }
        } else {
          widget.onComplete?.call();
        }
      }
    });
  }

  void _startAnimation() {
    if (!_isPaused && !_isHovering && _isContentMeasured) {
      if (_isFirstFrame) {
        _isFirstFrame = false;
        _controller.value = 0.0;
      }
      _controller.forward();
    }
  }

  void _pauseAnimation() {
    _isPaused = true;
    _controller.stop();
  }

  void _resumeAnimation() {
    _isPaused = false;
    if (!_isHovering) {
      _controller.forward();
    }
  }

  void _resetAnimation() {
    _controller.reset();
    _isPaused = false;
    _isFirstFrame = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: MouseRegion(
        onEnter: widget.pauseOnHover
            ? (_) {
                setState(() {
                  _isHovering = true;
                  _controller.stop();
                });
              }
            : null,
        onExit: widget.pauseOnHover
            ? (_) {
                setState(() {
                  _isHovering = false;
                  if (!_isPaused) {
                    _controller.forward();
                  }
                });
              }
            : null,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return _buildScrollingContent(constraints);
          },
        ),
      ),
    );
  }

  Widget _buildScrollingContent(BoxConstraints constraints) {
    final isHorizontal = widget.direction == MarqueeDirection.left ||
        widget.direction == MarqueeDirection.right;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _ContentMeasurer(
          child: widget.child,
          builder: (contentSize) {
            // 检查内容尺寸是否发生变化
            if (_lastContentSize != contentSize) {
              _lastContentSize = contentSize;
              _isContentMeasured = true;

              final containerWidth = constraints.maxWidth;
              final containerHeight = constraints.maxHeight;
              final contentWidth = contentSize.width;
              final contentHeight = contentSize.height;

              // 计算滚动距离和动画时长
              double scrollDistance;
              if (isHorizontal) {
                scrollDistance = containerWidth + contentWidth;
              } else {
                scrollDistance = containerHeight + contentHeight;
              }

              // 根据速度计算动画时长
              final duration = Duration(
                  milliseconds: (scrollDistance * 1000 / widget.speed).round());

              // 只在尺寸变化时更新动画时长
              if (_controller.duration != duration) {
                _controller.duration = duration;
                if (widget.autoStart && !_isPaused && !_isHovering) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      _startAnimation();
                    }
                  });
                }
              }
            }

            final containerWidth = constraints.maxWidth;
            final containerHeight = constraints.maxHeight;
            final contentWidth = contentSize.width;
            final contentHeight = contentSize.height;

            // 计算偏移量
            double translateX = 0;
            double translateY = 0;

            switch (widget.direction) {
              case MarqueeDirection.left:
                translateX = containerWidth -
                    (containerWidth + contentWidth) * _animation.value;
                break;
              case MarqueeDirection.right:
                translateX = -contentWidth +
                    (containerWidth + contentWidth) * _animation.value;
                break;
              case MarqueeDirection.up:
                translateY = containerHeight -
                    (containerHeight + contentHeight) * _animation.value;
                break;
              case MarqueeDirection.down:
                translateY = -contentHeight +
                    (containerHeight + contentHeight) * _animation.value;
                break;
            }

            return OverflowBox(
              alignment:
                  isHorizontal ? Alignment.centerLeft : Alignment.topCenter,
              minWidth: isHorizontal ? contentWidth : null,
              maxWidth: isHorizontal ? contentWidth : null,
              minHeight: !isHorizontal ? contentHeight : null,
              maxHeight: !isHorizontal ? contentHeight : null,
              child: Transform.translate(
                offset: Offset(translateX, translateY),
                child: widget.child,
              ),
            );
          },
        );
      },
    );
  }

  /// 开始滚动
  void start() => _startAnimation();

  /// 暂停滚动
  void pause() => _pauseAnimation();

  /// 恢复滚动
  void resume() => _resumeAnimation();

  /// 重置滚动
  void reset() => _resetAnimation();
}

/// 内容大小测量器
class _ContentMeasurer extends StatefulWidget {
  final Widget child;
  final Widget Function(Size contentSize) builder;

  const _ContentMeasurer({
    required this.child,
    required this.builder,
  });

  @override
  State<_ContentMeasurer> createState() => _ContentMeasurerState();
}

class _ContentMeasurerState extends State<_ContentMeasurer> {
  Size _contentSize = Size.zero;
  final GlobalKey _childKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureContent();
    });
  }

  void _measureContent() {
    final RenderBox? renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      if (size != _contentSize) {
        setState(() {
          _contentSize = size;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 隐藏的测量组件
        Positioned(
          left: -10000,
          top: -10000,
          child: Opacity(
            opacity: 0,
            child: IgnorePointer(
              child: Container(
                key: _childKey,
                child: widget.child,
              ),
            ),
          ),
        ),
        // 实际显示的内容
        widget.builder(_contentSize),
      ],
    );
  }
}

/// 跑马灯列表组件（无缝循环滚动）
class ComMarqueeList extends StatefulWidget {
  /// 列表Widget数据
  final List<Widget> children;

  /// 滚动方向
  final MarqueeDirection direction;

  /// 滚动速度
  final double speed;

  /// 显示的项目数量
  final int visibleItemCount;

  /// 项目间距
  final double itemSpacing;

  /// 是否无限循环
  final bool infinite;

  /// 是否自动开始
  final bool autoStart;

  /// 每轮滚动完成后的停留时间（毫秒）
  final int pauseDuration;

  /// 项目高度（垂直滚动时使用）
  final double itemHeight;

  /// 项目宽度（水平滚动时使用）
  final double itemWidth;

  const ComMarqueeList({
    super.key,
    required this.children,
    this.direction = MarqueeDirection.up,
    this.speed = 30.0,
    this.visibleItemCount = 3,
    this.itemSpacing = 8.0,
    this.infinite = true,
    this.autoStart = true,
    this.pauseDuration = 0,
    this.itemHeight = 60.0,
    this.itemWidth = 120.0,
  });

  @override
  State<ComMarqueeList> createState() => _ComMarqueeListState();
}

class _ComMarqueeListState extends State<ComMarqueeList>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initAnimation();
    if (widget.autoStart && widget.children.isNotEmpty) {
      _startAnimation();
    }
  }

  void _initAnimation() {
    // 计算一次完整滚动需要的时间
    final isVertical = widget.direction == MarqueeDirection.up ||
        widget.direction == MarqueeDirection.down;

    final itemSize = isVertical ? widget.itemHeight : widget.itemWidth;
    final totalScrollDistance =
        (itemSize + widget.itemSpacing) * widget.children.length;

    // 根据总距离和速度计算动画时长
    final totalDuration = Duration(
        milliseconds: (totalScrollDistance * 1000 / widget.speed).round());

    _controller = AnimationController(
      duration: totalDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.infinite) {
        _controller.reset();
        if (widget.pauseDuration > 0) {
          Future.delayed(Duration(milliseconds: widget.pauseDuration), () {
            if (mounted) {
              _controller.forward();
            }
          });
        } else {
          _controller.forward();
        }
      }
    });
  }

  void _startAnimation() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return const SizedBox.shrink();
    }

    final isVertical = widget.direction == MarqueeDirection.up ||
        widget.direction == MarqueeDirection.down;

    return isVertical ? _buildVerticalMarquee() : _buildHorizontalMarquee();
  }

  Widget _buildVerticalMarquee() {
    // 计算容器高度
    final containerHeight = widget.visibleItemCount == 1
        ? widget.itemHeight
        : widget.visibleItemCount * (widget.itemHeight + widget.itemSpacing) -
            widget.itemSpacing;

    return SizedBox(
      height: containerHeight,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // 计算当前应该显示的项目索引和偏移
          final totalItems = widget.children.length;
          final singleItemHeight = widget.itemHeight + widget.itemSpacing;

          // 当前的滚动偏移量
          final scrollOffset = _animation.value * totalItems * singleItemHeight;
          final currentItemIndex =
              (scrollOffset / singleItemHeight).floor() % totalItems;
          final itemOffset = scrollOffset % singleItemHeight;

          // 构建当前可见的项目列表
          final List<Widget> visibleItems = [];

          // 计算需要显示的项目数量（比可见项目多2个，确保平滑过渡）
          final itemsToShow = widget.visibleItemCount + 2;

          for (int i = 0; i < itemsToShow; i++) {
            final itemIndex = (currentItemIndex + i) % totalItems;
            final item = widget.children[itemIndex];

            // 计算每个项目的位置
            double itemTop = 0;
            if (widget.direction == MarqueeDirection.up) {
              itemTop = (i * singleItemHeight) - itemOffset;
            } else {
              itemTop =
                  containerHeight - ((i + 1) * singleItemHeight) + itemOffset;
            }

            visibleItems.add(
              Positioned(
                top: itemTop,
                left: 0,
                right: 0,
                height: widget.itemHeight,
                child: item,
              ),
            );
          }

          return ClipRect(
            child: Stack(
              children: visibleItems,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalMarquee() {
    // 计算容器宽度
    final containerWidth = widget.visibleItemCount == 1
        ? widget.itemWidth
        : widget.visibleItemCount * (widget.itemWidth + widget.itemSpacing) -
            widget.itemSpacing;

    return SizedBox(
      width: containerWidth,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // 计算当前应该显示的项目索引和偏移
          final totalItems = widget.children.length;
          final singleItemWidth = widget.itemWidth + widget.itemSpacing;

          // 当前的滚动偏移量
          final scrollOffset = _animation.value * totalItems * singleItemWidth;
          final currentItemIndex =
              (scrollOffset / singleItemWidth).floor() % totalItems;
          final itemOffset = scrollOffset % singleItemWidth;

          // 构建当前可见的项目列表
          final List<Widget> visibleItems = [];

          // 计算需要显示的项目数量（比可见项目多2个，确保平滑过渡）
          final itemsToShow = widget.visibleItemCount + 2;

          for (int i = 0; i < itemsToShow; i++) {
            final itemIndex = (currentItemIndex + i) % totalItems;
            final item = widget.children[itemIndex];

            // 计算每个项目的位置
            double itemLeft = 0;
            if (widget.direction == MarqueeDirection.left) {
              itemLeft = (i * singleItemWidth) - itemOffset;
            } else {
              itemLeft =
                  containerWidth - ((i + 1) * singleItemWidth) + itemOffset;
            }

            visibleItems.add(
              Positioned(
                left: itemLeft,
                top: 0,
                width: widget.itemWidth,
                height: widget.itemHeight,
                child: item,
              ),
            );
          }

          return ClipRect(
            child: Stack(
              children: visibleItems,
            ),
          );
        },
      ),
    );
  }

  /// 开始滚动
  void start() => _startAnimation();

  /// 暂停滚动
  void pause() => _controller.stop();

  /// 恢复滚动
  void resume() => _controller.forward();

  /// 重置滚动
  void reset() {
    _controller.reset();
  }
}
