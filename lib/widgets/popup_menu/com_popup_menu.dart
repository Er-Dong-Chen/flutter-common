import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chen_common/extension/context_extension.dart';

import '../../config/com_context.dart';
import '../../utils/platform_util.dart'
    if (dart.library.html) '../../utils/platform_util_web.dart';

/// ComPopupMenu - 一个功能丰富的弹出菜单组件
///
/// 主要特性：
/// - 支持单击和长按触发
/// - 智能位置计算，自动避免溢出
/// - 可自定义箭头和样式
/// - 支持控制器编程控制
/// - 内置无障碍支持
/// - 优化的内存管理
///
/// 使用示例：
/// ```dart
/// ComPopupMenu(
///   menuBuilder: Text('菜单内容'),
///   child: ElevatedButton(
///     onPressed: () {},
///     child: Text('点击显示菜单'),
///   ),
/// )
/// ```

/// 触发菜单的方式
enum PressType {
  /// 长按触发
  longPress,

  /// 单击触发
  singleClick,
}

/// 菜单首选位置
enum PreferredPosition {
  /// 在上方显示
  top,

  /// 在下方显示
  bottom,
}

/// 弹出菜单控制器
///
/// 用于编程控制菜单的显示和隐藏状态
class ComPopupMenuController extends ChangeNotifier {
  bool _menuIsShowing = false;
  bool _disposed = false;

  /// 菜单是否正在显示
  bool get menuIsShowing => _menuIsShowing;

  /// 显示菜单
  void showMenu() {
    if (_disposed) return;
    if (!_menuIsShowing) {
      _menuIsShowing = true;
      notifyListeners();
    }
  }

  /// 隐藏菜单
  void hideMenu() {
    if (_disposed) return;
    if (_menuIsShowing) {
      _menuIsShowing = false;
      notifyListeners();
    }
  }

  /// 切换菜单显示状态
  void toggleMenu() {
    if (_disposed) return;
    _menuIsShowing = !_menuIsShowing;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// 弹出菜单组件
///
/// 一个功能丰富的弹出菜单组件，支持自定义触发方式、位置和样式。
/// 具有智能位置计算、无障碍支持和优化的性能。
///
/// 参数说明：
/// - [child]: 触发菜单的子组件
/// - [menuBuilder]: 菜单内容构建器
/// - [pressType]: 触发方式（单击或长按）
/// - [controller]: 可选的控制器，用于编程控制
/// - [showArrow]: 是否显示箭头指示器
/// - [arrowColor]: 箭头颜色
/// - [barrierColor]: 遮罩层颜色
/// - [arrowSize]: 箭头大小
/// - [horizontalMargin]: 水平边距
/// - [verticalMargin]: 垂直边距
/// - [position]: 首选位置
/// - [menuOnChange]: 菜单状态变化回调
/// - [enablePassEvent]: 是否允许点击事件穿透
class ComPopupMenu extends StatefulWidget {
  const ComPopupMenu({
    super.key,
    required this.child,
    required this.menuBuilder,
    this.pressType = PressType.singleClick,
    this.controller,
    this.arrowColor,
    this.showArrow = true,
    this.barrierColor = Colors.black12,
    this.arrowSize = 14.0,
    this.horizontalMargin = 16.0,
    this.verticalMargin = 4.0,
    this.position,
    this.menuOnChange,
    this.enablePassEvent = true,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  })  : assert(arrowSize > 0, 'Arrow size must be positive'),
        assert(horizontalMargin >= 0, 'Horizontal margin must be non-negative'),
        assert(verticalMargin >= 0, 'Vertical margin must be non-negative');

  /// 触发菜单的子组件
  final Widget child;

  /// 触发方式
  final PressType pressType;

  /// 是否显示箭头
  final bool showArrow;

  /// 箭头颜色
  final Color? arrowColor;

  /// 遮罩层颜色
  final Color barrierColor;

  /// 水平边距
  final double horizontalMargin;

  /// 垂直边距
  final double verticalMargin;

  /// 箭头大小
  final double arrowSize;

  /// 控制器
  final ComPopupMenuController? controller;

  /// 菜单内容构建器
  final Widget? menuBuilder;

  /// 首选位置
  final PreferredPosition? position;

  /// 菜单状态变化回调
  final void Function(bool)? menuOnChange;

  /// 是否允许点击事件穿透到下层组件
  /// 仅在 [barrierColor] 为透明时有效
  final bool enablePassEvent;

  /// 语义化标签
  final String? semanticLabel;

  /// 是否从语义树中排除
  final bool excludeFromSemantics;

  @override
  ComPopupMenuState createState() => ComPopupMenuState();

  /// 创建一个简单的文本菜单
  ///
  /// 便利构造函数，用于快速创建包含文本的弹出菜单
  static ComPopupMenu text({
    Key? key,
    required Widget child,
    required String text,
    TextStyle? textStyle,
    EdgeInsets? padding,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    double? width,
    PressType pressType = PressType.singleClick,
    ComPopupMenuController? controller,
    PreferredPosition? position,
    bool showArrow = true,
    Color? arrowColor,
    void Function(bool)? onMenuChanged,
  }) {
    return ComPopupMenu(
      key: key,
      pressType: pressType,
      controller: controller,
      position: position,
      showArrow: showArrow,
      arrowColor: arrowColor,
      menuOnChange: onMenuChanged,
      menuBuilder: Container(
        width: width ?? 180,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor ??
              Theme.of(ComContext.context).colorScheme.surfaceContainerLowest,
          borderRadius: borderRadius ??
              BorderRadius.circular(
                  ComContext.context.comTheme.shapes.mediumRadius),
        ),
        child: Text(
          text,
          style: textStyle,
        ),
      ),
      child: child,
    );
  }

  /// 创建一个包含多个选项的菜单
  ///
  /// 便利构造函数，用于快速创建选项列表菜单
  static ComPopupMenu options({
    Key? key,
    required Widget child,
    required List<PopupMenuOption> options,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    double? width,
    PressType pressType = PressType.singleClick,
    ComPopupMenuController? controller,
    PreferredPosition? position,
    bool showArrow = true,
    Color? arrowColor,
    void Function(bool)? onMenuChanged,
  }) {
    return ComPopupMenu(
      key: key,
      pressType: pressType,
      controller: controller,
      position: position,
      showArrow: showArrow,
      arrowColor: arrowColor,
      menuOnChange: onMenuChanged,
      menuBuilder: Container(
        width: width ?? 180,
        decoration: BoxDecoration(
          color: backgroundColor ??
              Theme.of(ComContext.context).colorScheme.surfaceContainerLowest,
          borderRadius: borderRadius ??
              BorderRadius.circular(
                  ComContext.context.comTheme.shapes.mediumRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) => _buildOptionItem(option)).toList(),
        ),
      ),
      child: child,
    );
  }

  static Widget _buildOptionItem(PopupMenuOption option) {
    return InkWell(
      onTap: option.onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (option.icon != null) ...[
              Icon(option.icon, size: 18, color: option.iconColor),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                option.text,
                style: option.textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 弹出菜单选项
///
/// 用于 [ComPopupMenu.options] 构造函数的选项配置
class PopupMenuOption {
  const PopupMenuOption({
    required this.text,
    required this.onTap,
    this.icon,
    this.iconColor,
    this.textStyle,
  });

  /// 选项文本
  final String text;

  /// 点击回调
  final VoidCallback onTap;

  /// 选项图标
  final IconData? icon;

  /// 图标颜色
  final Color? iconColor;

  /// 文本样式
  final TextStyle? textStyle;
}

class ComPopupMenuState extends State<ComPopupMenu>
    with WidgetsBindingObserver {
  RenderBox? _childBox;
  RenderBox? _parentBox;
  OverlayEntry? _overlayEntry;
  ComPopupMenuController? _controller;
  bool _canResponse = true;
  bool _isControllerOwned = false;
  Rect _menuRect = Rect.zero; // 移除全局变量，使用实例变量

  /// 显示菜单
  void _showMenu() {
    try {
      if (_overlayEntry != null) {
        _hideMenu(); // 先隐藏已存在的菜单
      }

      final overlay = Overlay.of(context);
      if (overlay.context.mounted != true) return;
      _overlayEntry = OverlayEntry(
        builder: (context) {
          return _buildMenuOverlay(context);
        },
      );

      overlay.insert(_overlayEntry!);
    } catch (e) {
      debugPrint('ComPopupMenu: Error showing menu: $e');
      _overlayEntry = null;
    }
  }

  /// 构建菜单覆盖层
  Widget _buildMenuOverlay(BuildContext context) {
    if (_childBox == null || _parentBox == null || widget.menuBuilder == null) {
      return const SizedBox.shrink();
    }

    final arrow = _buildArrow(context);
    final menu = _buildMenu(context, arrow);

    return Semantics(
      label: widget.semanticLabel ?? '弹出菜单',
      excludeSemantics: widget.excludeFromSemantics,
      child: Listener(
        behavior: widget.enablePassEvent
            ? HitTestBehavior.translucent
            : HitTestBehavior.opaque,
        onPointerDown: _handlePointerDown,
        child: widget.barrierColor == Colors.transparent
            ? menu
            : Container(
                color: widget.barrierColor,
                child: menu,
              ),
      ),
    );
  }

  /// 构建箭头组件
  Widget _buildArrow(BuildContext context) {
    return ClipPath(
      clipper: _ArrowClipper(),
      child: Container(
        width: widget.arrowSize,
        height: widget.arrowSize,
        color: widget.arrowColor ??
            Theme.of(context).colorScheme.surfaceContainerLowest,
      ),
    );
  }

  /// 构建菜单内容
  Widget _buildMenu(BuildContext context, Widget arrow) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              math.max(0, _parentBox!.size.width - 2 * widget.horizontalMargin),
          minWidth: 0,
        ),
        child: CustomMultiChildLayout(
          delegate: _MenuLayoutDelegate(
            anchorSize: _childBox!.size,
            anchorOffset: _childBox!.localToGlobal(
              Offset(-widget.horizontalMargin, 0),
            ),
            verticalMargin: widget.verticalMargin,
            position: widget.position,
            onMenuRectChanged: (rect) => _menuRect = rect,
          ),
          children: <Widget>[
            if (widget.showArrow)
              LayoutId(
                id: _MenuLayoutId.arrow,
                child: arrow,
              ),
            if (widget.showArrow)
              LayoutId(
                id: _MenuLayoutId.downArrow,
                child: Transform.rotate(
                  angle: math.pi,
                  child: arrow,
                ),
              ),
            LayoutId(
              id: _MenuLayoutId.content,
              child: Material(
                color: Colors.transparent,
                child: widget.menuBuilder!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理指针事件
  void _handlePointerDown(PointerDownEvent event) {
    try {
      final offset = event.localPosition;
      // 检查点击位置是否在菜单内
      if (_menuRect
          .contains(Offset(offset.dx - widget.horizontalMargin, offset.dy))) {
        return;
      }

      _controller?.hideMenu();

      // 当 enablePassEvent 生效且点击 child 时，
      // 防止传递的事件再次触发 showMenu
      _canResponse = false;
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _canResponse = true;
        }
      });
    } catch (e) {
      debugPrint('ComPopupMenu: Error handling pointer down: $e');
    }
  }

  /// 隐藏菜单
  void _hideMenu() {
    try {
      if (_overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        _menuRect = Rect.zero;
      }
    } catch (e) {
      debugPrint('ComPopupMenu: Error hiding menu: $e');
    }
  }

  /// 更新菜单显示状态
  void _updateView() {
    if (!mounted) return;

    try {
      final menuIsShowing = _controller?.menuIsShowing ?? false;
      widget.menuOnChange?.call(menuIsShowing);

      if (menuIsShowing) {
        _showMenu();
      } else {
        _hideMenu();
      }
    } catch (e) {
      debugPrint('ComPopupMenu: Error updating view: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 初始化控制器
    if (widget.controller != null) {
      _controller = widget.controller;
      _isControllerOwned = false;
    } else {
      _controller = ComPopupMenuController();
      _isControllerOwned = true;
    }

    _controller?.addListener(_updateView);

    // 延迟获取渲染对象
    WidgetsBinding.instance.addPostFrameCallback(_initRenderBoxes);
  }

  /// 初始化渲染对象
  void _initRenderBoxes(Duration timeStamp) {
    if (!mounted) return;

    try {
      _childBox = context.findRenderObject() as RenderBox?;
      final overlay = Overlay.maybeOf(context);
      if (overlay != null) {
        _parentBox = overlay.context.findRenderObject() as RenderBox?;
      }
    } catch (e) {
      debugPrint('ComPopupMenu: Error initializing render boxes: $e');
    }
  }

  @override
  void didUpdateWidget(ComPopupMenu oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 处理控制器更改
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_updateView);

      if (_isControllerOwned && _controller != null) {
        _controller!.dispose();
      }

      if (widget.controller != null) {
        _controller = widget.controller;
        _isControllerOwned = false;
      } else {
        _controller = ComPopupMenuController();
        _isControllerOwned = true;
      }

      _controller?.addListener(_updateView);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 应用进入后台时隐藏菜单
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller?.hideMenu();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _hideMenu();
    _controller?.removeListener(_updateView);

    // 只有当我们拥有控制器时才释放它
    if (_isControllerOwned && _controller != null) {
      _controller!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = _buildTriggerWidget();

    // iOS 不支持 PopScope，使用其他方式处理返回键
    if (PlatformUtil.isIOS) {
      return child;
    } else {
      return PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool canPop, _) {
          if (_controller?.menuIsShowing == true) {
            _controller?.hideMenu();
          }
        },
        child: child,
      );
    }
  }

  /// 构建触发器组件
  Widget _buildTriggerWidget() {
    return Semantics(
      button: true,
      label: widget.semanticLabel ??
          (widget.pressType == PressType.longPress ? '长按显示菜单' : '点击显示菜单'),
      excludeSemantics: widget.excludeFromSemantics,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: _handleTap,
          onLongPress: _handleLongPress,
          child: widget.child,
        ),
      ),
    );
  }

  /// 处理点击事件
  void _handleTap() {
    if (widget.pressType == PressType.singleClick && _canResponse) {
      _performMenuAction();
    }
  }

  /// 处理长按事件
  void _handleLongPress() {
    if (widget.pressType == PressType.longPress && _canResponse) {
      _performMenuAction();
    }
  }

  /// 执行菜单操作
  void _performMenuAction() {
    try {
      // 震动反馈（仅在支持的平台上）
      if (!PlatformUtil.isWeb) {
        HapticFeedback.lightImpact();
      }

      _controller?.toggleMenu();
    } catch (e) {
      debugPrint('ComPopupMenu: Error performing menu action: $e');
    }
  }

  /// 显示菜单（公开方法）
  void showMenu() {
    _controller?.showMenu();
  }

  /// 隐藏菜单（公开方法）
  void hideMenu() {
    _controller?.hideMenu();
  }

  /// 切换菜单状态（公开方法）
  void toggleMenu() {
    _controller?.toggleMenu();
  }

  /// 菜单是否正在显示
  bool get isMenuShowing => _controller?.menuIsShowing ?? false;
}

/// 菜单布局ID枚举
enum _MenuLayoutId {
  /// 向上的箭头
  arrow,

  /// 向下的箭头
  downArrow,

  /// 菜单内容
  content,
}

/// 菜单内部位置枚举
enum _MenuPosition {
  /// 底部左对齐
  bottomLeft,

  /// 底部居中
  bottomCenter,

  /// 底部右对齐
  bottomRight,

  /// 顶部左对齐
  topLeft,

  /// 顶部居中
  topCenter,

  /// 顶部右对齐
  topRight,
}

class _MenuLayoutDelegate extends MultiChildLayoutDelegate {
  _MenuLayoutDelegate({
    required this.anchorSize,
    required this.anchorOffset,
    required this.verticalMargin,
    this.position,
    this.onMenuRectChanged,
  });

  final Size anchorSize;
  final Offset anchorOffset;
  final double verticalMargin;
  final PreferredPosition? position;
  final void Function(Rect)? onMenuRectChanged;

  @override
  void performLayout(Size size) {
    Size contentSize = Size.zero;
    Size arrowSize = Size.zero;
    Offset contentOffset = const Offset(0, 0);
    Offset arrowOffset = const Offset(0, 0);

    double anchorCenterX = anchorOffset.dx + anchorSize.width / 2;
    double anchorTopY = anchorOffset.dy;
    double anchorBottomY = anchorTopY + anchorSize.height;
    _MenuPosition menuPosition = _MenuPosition.bottomCenter;

    if (hasChild(_MenuLayoutId.content)) {
      contentSize = layoutChild(
        _MenuLayoutId.content,
        BoxConstraints.loose(size),
      );
    }
    if (hasChild(_MenuLayoutId.arrow)) {
      arrowSize = layoutChild(
        _MenuLayoutId.arrow,
        BoxConstraints.loose(size),
      );
    }
    if (hasChild(_MenuLayoutId.downArrow)) {
      layoutChild(
        _MenuLayoutId.downArrow,
        BoxConstraints.loose(size),
      );
    }

    // 智能位置计算，考虑空间优先级
    bool isTop = false;
    if (position == null) {
      // 自动计算位置：优先在下方显示，空间不足时在上方
      final spaceBelow = size.height - anchorBottomY;
      final spaceAbove = anchorTopY;
      final menuHeight = contentSize.height + arrowSize.height + verticalMargin;

      if (spaceBelow >= menuHeight) {
        isTop = false; // 下方空间足够
      } else if (spaceAbove >= menuHeight) {
        isTop = true; // 上方空间足够
      } else {
        // 两方都不足，选择空间较大的一方
        isTop = spaceAbove > spaceBelow;
      }
    } else {
      isTop = position == PreferredPosition.top;
    }

    // 水平位置计算，考虑边界检测
    const edgeMargin = 8.0; // 边界边距
    final leftSpace = anchorCenterX - contentSize.width / 2;
    final rightSpace = size.width - (anchorCenterX + contentSize.width / 2);

    if (leftSpace >= edgeMargin && rightSpace >= edgeMargin) {
      // 中间位置有足够空间
      menuPosition =
          isTop ? _MenuPosition.topCenter : _MenuPosition.bottomCenter;
    } else if (leftSpace < edgeMargin) {
      // 左侧空间不足，向左对齐
      menuPosition = isTop ? _MenuPosition.topLeft : _MenuPosition.bottomLeft;
    } else {
      // 右侧空间不足，向右对齐
      menuPosition = isTop ? _MenuPosition.topRight : _MenuPosition.bottomRight;
    }

    switch (menuPosition) {
      case _MenuPosition.bottomCenter:
        arrowOffset = Offset(
          math.max(
              arrowSize.width / 2,
              math.min(anchorCenterX - arrowSize.width / 2,
                  size.width - arrowSize.width / 2)),
          anchorBottomY + verticalMargin,
        );
        contentOffset = Offset(
          math.max(
              0,
              math.min(anchorCenterX - contentSize.width / 2,
                  size.width - contentSize.width)),
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.bottomLeft:
        arrowOffset = Offset(
          math.max(
              arrowSize.width / 2,
              math.min(anchorCenterX - arrowSize.width / 2,
                  size.width - arrowSize.width / 2)),
          anchorBottomY + verticalMargin,
        );
        contentOffset = Offset(
          math.max(0, math.min(8.0, size.width - contentSize.width)),
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.bottomRight:
        arrowOffset = Offset(
          math.max(
              arrowSize.width / 2,
              math.min(anchorCenterX - arrowSize.width / 2,
                  size.width - arrowSize.width / 2)),
          anchorBottomY + verticalMargin,
        );
        contentOffset = Offset(
          math.max(0, size.width - contentSize.width - 8.0),
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.topCenter:
        arrowOffset = Offset(
          math.max(
              arrowSize.width / 2,
              math.min(anchorCenterX - arrowSize.width / 2,
                  size.width - arrowSize.width / 2)),
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          math.max(
              0,
              math.min(anchorCenterX - contentSize.width / 2,
                  size.width - contentSize.width)),
          math.max(
              0,
              anchorTopY -
                  verticalMargin -
                  arrowSize.height -
                  contentSize.height),
        );
        break;
      case _MenuPosition.topLeft:
        arrowOffset = Offset(
          math.max(
              arrowSize.width / 2,
              math.min(anchorCenterX - arrowSize.width / 2,
                  size.width - arrowSize.width / 2)),
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          math.max(0, math.min(8.0, size.width - contentSize.width)),
          math.max(
              0,
              anchorTopY -
                  verticalMargin -
                  arrowSize.height -
                  contentSize.height),
        );
        break;
      case _MenuPosition.topRight:
        arrowOffset = Offset(
          math.max(
              arrowSize.width / 2,
              math.min(anchorCenterX - arrowSize.width / 2,
                  size.width - arrowSize.width / 2)),
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          math.max(0, size.width - contentSize.width - 8.0),
          math.max(
              0,
              anchorTopY -
                  verticalMargin -
                  arrowSize.height -
                  contentSize.height),
        );
        break;
    }
    if (hasChild(_MenuLayoutId.content)) {
      positionChild(_MenuLayoutId.content, contentOffset);
    }

    final menuRect = Rect.fromLTWH(
      contentOffset.dx,
      contentOffset.dy,
      contentSize.width,
      contentSize.height,
    );

    // 通知回调菜单位置
    onMenuRectChanged?.call(menuRect);
    bool isBottom = false;
    if (_MenuPosition.values.indexOf(menuPosition) < 3) {
      // bottom
      isBottom = true;
    }
    if (hasChild(_MenuLayoutId.arrow)) {
      positionChild(
        _MenuLayoutId.arrow,
        isBottom
            ? Offset(arrowOffset.dx, arrowOffset.dy + 0.1)
            : const Offset(-100, 0),
      );
    }
    if (hasChild(_MenuLayoutId.downArrow)) {
      positionChild(
        _MenuLayoutId.downArrow,
        !isBottom
            ? Offset(arrowOffset.dx, arrowOffset.dy - 0.1)
            : const Offset(-100, 0),
      );
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    if (oldDelegate is! _MenuLayoutDelegate) return true;

    return anchorSize != oldDelegate.anchorSize ||
        anchorOffset != oldDelegate.anchorOffset ||
        verticalMargin != oldDelegate.verticalMargin ||
        position != oldDelegate.position;
  }
}

/// 箭头裁剪器
///
/// 创建一个三角形箭头指向菜单的裁剪路径
class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // 创建一个向上的三角形箭头
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // 箭头形状不会变化，不需要重新裁剪
    return false;
  }
}
