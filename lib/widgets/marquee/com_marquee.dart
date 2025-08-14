import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// ComMarquee - 一个高性能的跑马灯组件
///
/// 主要特性：
/// - 支持四个方向的滚动（左、右、上、下）
/// - 可配置的滚动速度和暂停时间
/// - 支持鼠标悬停暂停
/// - 智能内容检测（只有内容超出容器时才滚动）
/// - 内置控制器支持编程控制
/// - 优化的性能和内存管理
///
/// 使用示例：
/// ```dart
/// ComMarquee(
///   child: Text('这是一个滚动的文本'),
///   direction: MarqueeDirection.left,
///   speed: 50.0,
///   pauseOnHover: true,
/// )
/// ```

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

/// 跑马灯状态接口
abstract class _MarqueeStateInterface {
  void start();
  void pause();
  void resume();
  void reset();
  bool get isAnimating;
  bool get isPaused;
}

/// 跑马灯控制器
class MarqueeController {
  _MarqueeStateInterface? _state;

  void _attachState(_MarqueeStateInterface state) {
    _state = state;
  }

  void _detachState() {
    _state = null;
  }

  /// 开始滚动
  void start() => _state?.start();

  /// 暂停滚动
  void pause() => _state?.pause();

  /// 恢复滚动
  void resume() => _state?.resume();

  /// 重置滚动
  void reset() => _state?.reset();

  /// 是否正在滚动
  bool get isScrolling => _state?.isAnimating ?? false;

  /// 是否已暂停
  bool get isPaused => _state?.isPaused ?? false;
}

/// 跑马灯组件
///
/// 一个支持自定义滚动方向和速度的跑马灯组件。
/// 支持水平和垂直方向的滚动，具有智能内容检测功能。
///
/// 参数说明：
/// - [child]: 要滚动的子组件
/// - [direction]: 滚动方向，默认向左
/// - [speed]: 滚动速度（像素/秒），默认50.0
/// - [infinite]: 是否无限循环，默认true
/// - [autoStart]: 是否自动开始滚动，默认true
/// - [pauseDuration]: 每轮滚动后的暂停时间（毫秒），默认0
/// - [pauseOnHover]: 是否在鼠标悬停时暂停，默认false
/// - [controller]: 可选的控制器，用于编程控制滚动
/// - [minScrollDistance]: 最小滚动距离，默认0.0
/// - [scrollOnlyWhenOverflow]: 是否只在内容超出容器时才滚动，默认false
/// - [onComplete]: 滚动完成时的回调函数
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

  /// 控制器
  final MarqueeController? controller;

  /// 最小滚动距离（只有当内容超出容器时才滚动）
  final double minScrollDistance;

  /// 是否只在内容超出容器时才滚动
  final bool scrollOnlyWhenOverflow;

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
    this.controller,
    this.minScrollDistance = 0.0,
    this.scrollOnlyWhenOverflow = false,
  });

  @override
  State<ComMarquee> createState() => _ComMarqueeState();
}

class _ComMarqueeState extends State<ComMarquee>
    with TickerProviderStateMixin
    implements _MarqueeStateInterface {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isHovering = false;
  bool _isPaused = false;
  bool _isContentMeasured = false;
  bool _isFirstFrame = true;
  bool _shouldScroll = true;
  Size? _lastContentSize;
  Size? _containerSize;

  @override
  void initState() {
    super.initState();
    widget.controller?._attachState(this);
    _initAnimation();
  }

  @override
  void didUpdateWidget(ComMarquee oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 更新控制器绑定
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detachState();
      widget.controller?._attachState(this);
    }

    // 检查是否需要重新初始化动画
    if (oldWidget.speed != widget.speed ||
        oldWidget.direction != widget.direction ||
        oldWidget.infinite != widget.infinite) {
      _resetAnimation();
      _initAnimation();
    }
  }

  void _initAnimation() {
    try {
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
        if (!mounted) return;

        if (status == AnimationStatus.completed) {
          if (widget.infinite) {
            _controller.reset();
            if (widget.pauseDuration > 0) {
              Future.delayed(Duration(milliseconds: widget.pauseDuration), () {
                if (mounted && !_isPaused && !_isHovering && _shouldScroll) {
                  _controller.forward();
                }
              });
            } else {
              if (!_isPaused && !_isHovering && _shouldScroll) {
                _controller.forward();
              }
            }
          } else {
            try {
              widget.onComplete?.call();
            } catch (e) {
              debugPrint('ComMarquee onComplete callback error: $e');
            }
          }
        }
      });
    } catch (e) {
      debugPrint('ComMarquee animation initialization error: $e');
    }
  }

  void _startAnimation() {
    if (!_isPaused && !_isHovering && _isContentMeasured && _shouldScroll) {
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
    try {
      _controller.reset();
      _isPaused = false;
      _isFirstFrame = true;
      _shouldScroll = _shouldScrollContent();
    } catch (e) {
      debugPrint('ComMarquee reset animation error: $e');
    }
  }

  @override
  void dispose() {
    widget.controller?._detachState();
    _controller.dispose();
    super.dispose();
  }

  /// 检查是否需要滚动
  bool _shouldScrollContent() {
    if (!widget.scrollOnlyWhenOverflow) return true;
    if (_containerSize == null || _lastContentSize == null) return false;

    final isHorizontal = widget.direction == MarqueeDirection.left ||
        widget.direction == MarqueeDirection.right;

    if (isHorizontal) {
      return _lastContentSize!.width >
          _containerSize!.width + widget.minScrollDistance;
    } else {
      return _lastContentSize!.height >
          _containerSize!.height + widget.minScrollDistance;
    }
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

    // 缓存容器尺寸
    _containerSize = Size(constraints.maxWidth, constraints.maxHeight);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _OptimizedContentMeasurer(
          child: widget.child,
          builder: (contentSize) {
            // 检查内容尺寸是否发生变化
            if (_lastContentSize != contentSize) {
              _lastContentSize = contentSize;
              _isContentMeasured = true;
              _shouldScroll = _shouldScrollContent();

              // 只有在需要滚动时才计算动画
              if (_shouldScroll) {
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

                // 确保最小滚动距离
                scrollDistance = scrollDistance.clamp(
                    widget.minScrollDistance, double.infinity);

                // 根据速度计算动画时长
                final duration = Duration(
                    milliseconds:
                        (scrollDistance * 1000 / widget.speed).round());

                // 只在尺寸变化时更新动画时长
                if (_controller.duration != duration) {
                  _controller.duration = duration;
                  if (widget.autoStart && !_isPaused && !_isHovering) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      if (mounted && _shouldScroll) {
                        _startAnimation();
                      }
                    });
                  }
                }
              }
            }

            // 如果不需要滚动，直接返回静态内容
            if (!_shouldScroll) {
              return widget.child;
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
              alignment: isHorizontal ? Alignment.centerLeft : Alignment.topCenter,
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
  @override
  void start() => _startAnimation();

  /// 暂停滚动
  @override
  void pause() => _pauseAnimation();

  /// 恢复滚动
  @override
  void resume() => _resumeAnimation();

  /// 重置滚动
  @override
  void reset() => _resetAnimation();

  /// 是否正在动画
  @override
  bool get isAnimating => _controller.isAnimating;

  /// 是否已暂停
  @override
  bool get isPaused => _isPaused;
}

/// 优化的内容大小测量器
class _OptimizedContentMeasurer extends StatefulWidget {
  final Widget child;
  final Widget Function(Size contentSize) builder;

  const _OptimizedContentMeasurer({
    required this.child,
    required this.builder,
  });

  @override
  State<_OptimizedContentMeasurer> createState() =>
      _OptimizedContentMeasurerState();
}

class _OptimizedContentMeasurerState extends State<_OptimizedContentMeasurer> {
  Size _contentSize = Size.zero;
  final GlobalKey _childKey = GlobalKey();
  bool _isMeasuring = false;

  @override
  void initState() {
    super.initState();
    _scheduleMeasurement();
  }

  @override
  void didUpdateWidget(_OptimizedContentMeasurer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _scheduleMeasurement();
    }
  }

  void _scheduleMeasurement() {
    if (!_isMeasuring && mounted) {
      _isMeasuring = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _measureContent();
        }
        _isMeasuring = false;
      });
    }
  }

  void _measureContent() {
    if (!mounted) return;

    final RenderBox? renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox?.hasSize == true) {
      final size = renderBox!.size;
      if (size != _contentSize && size.width > 0 && size.height > 0) {
        if (mounted) {
          setState(() {
            _contentSize = size;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 隐藏的测量组件，放在屏幕外但给予充分的空间
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
///
/// 一个专门用于显示列表项目的跑马灯组件，支持无缝循环滚动。
/// 适用于公告栏、新闻列表等场景。
///
/// 主要特性：
/// - 支持垂直和水平滚动
/// - 可自定义可见项目数量
/// - 支持项目间距设置
/// - 支持鼠标悬停暂停
/// - 内置控制器支持
///
/// 使用示例：
/// ```dart
/// ComMarqueeList(
///   children: [
///     Text('第一条公告'),
///     Text('第二条公告'),
///     Text('第三条公告'),
///   ],
///   direction: MarqueeDirection.up,
///   visibleItemCount: 2,
///   itemHeight: 40.0,
/// )
/// ```
///
/// 参数说明：
/// - [children]: 列表中的组件项（不能为空）
/// - [direction]: 滚动方向，默认向上
/// - [speed]: 滚动速度（像素/秒），默认30.0
/// - [visibleItemCount]: 同时显示的项目数量，默认3
/// - [itemSpacing]: 项目间距，默认8.0
/// - [itemHeight]: 项目高度（垂直滚动时），默认60.0
/// - [itemWidth]: 项目宽度（水平滚动时），默认120.0
/// - [infinite]: 是否无限循环，默认true
/// - [autoStart]: 是否自动开始，默认true
/// - [pauseDuration]: 每轮滚动后的暂停时间（毫秒），默认0
/// - [controller]: 可选的控制器
/// - [pauseOnHover]: 是否在鼠标悬停时暂停，默认false
/// - [onComplete]: 滚动完成时的回调函数
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

  /// 控制器
  final MarqueeController? controller;

  /// 是否在鼠标悬停时暂停
  final bool pauseOnHover;

  /// 滚动完成回调
  final VoidCallback? onComplete;

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
    this.controller,
    this.pauseOnHover = false,
    this.onComplete,
  })  : assert(
            visibleItemCount > 0, 'Visible item count must be greater than 0'),
        assert(speed > 0, 'Speed must be greater than 0'),
        assert(itemHeight > 0, 'Item height must be greater than 0'),
        assert(itemWidth > 0, 'Item width must be greater than 0');

  @override
  State<ComMarqueeList> createState() => _ComMarqueeListState();
}

class _ComMarqueeListState extends State<ComMarqueeList>
    with TickerProviderStateMixin
    implements _MarqueeStateInterface {
  late AnimationController _controller;
  late Animation<double> _animation;
  late ScrollController _scrollController;
  bool _isHovering = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    widget.controller?._attachState(this);
    _scrollController = ScrollController();
    _initAnimation();
    if (widget.autoStart && widget.children.isNotEmpty) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(ComMarqueeList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 更新控制器绑定
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detachState();
      widget.controller?._attachState(this);
    }

    // 检查是否需要重新初始化动画
    if (oldWidget.speed != widget.speed ||
        oldWidget.direction != widget.direction ||
        oldWidget.children.length != widget.children.length) {
      _controller.reset();
      _initAnimation();
      if (widget.autoStart && !_isPaused && !_isHovering) {
        _startAnimation();
      }
    }
  }

  void _initAnimation() {
    try {
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
        if (!mounted) return;

        if (status == AnimationStatus.completed && widget.infinite) {
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
        } else if (status == AnimationStatus.completed && !widget.infinite) {
          try {
            widget.onComplete?.call();
          } catch (e) {
            debugPrint('ComMarqueeList onComplete callback error: $e');
          }
        }
      });
    } catch (e) {
      debugPrint('ComMarqueeList animation initialization error: $e');
    }
  }

  void _startAnimation() {
    if (mounted && !_isPaused && !_isHovering) {
      try {
        _controller.forward();
      } catch (e) {
        debugPrint('ComMarqueeList start animation error: $e');
      }
    }
  }

  @override
  void dispose() {
    widget.controller?._detachState();
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

    Widget child =
        isVertical ? _buildVerticalMarquee() : _buildHorizontalMarquee();

    // 添加鼠标悬停支持
    if (widget.pauseOnHover) {
      child = MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovering = true;
            _controller.stop();
          });
        },
        onExit: (_) {
          setState(() {
            _isHovering = false;
            if (!_isPaused) {
              _controller.forward();
            }
          });
        },
        child: child,
      );
    }

    return child;
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
  @override
  void start() {
    _isPaused = false;
    _startAnimation();
  }

  /// 暂停滚动
  @override
  void pause() {
    _isPaused = true;
    try {
      _controller.stop();
    } catch (e) {
      debugPrint('ComMarqueeList pause error: $e');
    }
  }

  /// 恢复滚动
  @override
  void resume() {
    _isPaused = false;
    if (!_isHovering) {
      try {
        _controller.forward();
      } catch (e) {
        debugPrint('ComMarqueeList resume error: $e');
      }
    }
  }

  /// 重置滚动
  @override
  void reset() {
    _isPaused = false;
    try {
      _controller.reset();
    } catch (e) {
      debugPrint('ComMarqueeList reset error: $e');
    }
  }

  /// 是否正在动画
  @override
  bool get isAnimating => _controller.isAnimating;

  /// 是否已暂停
  @override
  bool get isPaused => _isPaused;
}
