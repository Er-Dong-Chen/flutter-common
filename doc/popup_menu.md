# PopupMenu 弹出菜单

## 🌟 特性

- 🎯 灵活的触发方式（单击、长按）
- 📍 智能位置计算（自动适配屏幕边缘）
- 🎨 可定制的箭头指示器
- 🎭 支持自定义菜单内容
- 🎮 完整的控制器支持
- 🌈 丰富的样式配置选项
- 📱 完美的移动端体验
- 🛡️ 智能遮罩层处理
- ⚡ 流畅的动画效果
- 🔧 高度可配置和扩展

## 📱 效果预览

![PopupMenu 效果预览](https://er-dong-chen.github.io/images/demo/popup_menu.gif)

## 🚀 快速开始

### 基础使用

```dart
ComPopupMenu(
  pressType: PressType.singleClick,
  menuBuilder: Container(
    padding: const EdgeInsets.all(16),
    color: Colors.white,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.home),
          title: Text('首页'),
          onTap: () => print('点击了首页'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('设置'),
          onTap: () => print('点击了设置'),
        ),
      ],
    ),
  ),
  child: Chip(label: Text('点击显示菜单')),
)
```

### 🎯 便利构造函数

#### 快速文本菜单

```dart
ComPopupMenu.text(
  text: '这是一个简单的文本提示\\n支持多行显示',
  textStyle: TextStyle(fontSize: 14, color: Colors.black87),
  backgroundColor: Colors.white,
  padding: EdgeInsets.all(16),
  borderRadius: BorderRadius.circular(8),
  child: ElevatedButton(
    onPressed: () {},
    child: Text('显示文本菜单'),
  ),
)
```

#### 快速选项菜单

```dart
ComPopupMenu.options(
  options: [
    PopupMenuOption(
      text: '收藏',
      icon: Icons.star,
      iconColor: Colors.amber,
      onTap: () => print('点击了收藏'),
    ),
    PopupMenuOption(
      text: '分享',
      icon: Icons.share,
      iconColor: Colors.blue,
      onTap: () => print('点击了分享'),
    ),
    PopupMenuOption(
      text: '删除',
      icon: Icons.delete,
      iconColor: Colors.red,
      textStyle: TextStyle(color: Colors.red),
      onTap: () => print('点击了删除'),
    ),
  ],
  backgroundColor: Colors.white,
  child: IconButton(
    icon: Icon(Icons.more_vert),
    onPressed: () {},
  ),
)
```

### 长按触发

```dart
ComPopupMenu(
  pressType: PressType.longPress,
  menuBuilder: _buildMenu(),
  child: Container(
    padding: EdgeInsets.all(12),
    child: Text('长按显示菜单'),
  ),
)
```

## 🎨 自定义样式

### 箭头配置

```dart
ComPopupMenu(
  showArrow: true,
  arrowSize: 16.0,
  arrowColor: Colors.white,
  menuBuilder: _buildMenu(),
  child: _buildTrigger(),
)
```

### 位置控制

```dart
ComPopupMenu(
  position: PreferredPosition.top, // 强制在顶部显示
  verticalMargin: 8.0,
  horizontalMargin: 16.0,
  menuBuilder: _buildMenu(),
  child: _buildTrigger(),
)
```

### 自定义遮罩

```dart
ComPopupMenu(
  barrierColor: Colors.black26,
  enablePassEvent: false, // 禁用点击穿透
  menuBuilder: _buildMenu(),
  child: _buildTrigger(),
)
```

## 🎮 控制器使用

### 创建控制器

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final ComPopupMenuController _controller = ComPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 使用控制器的菜单
        ComPopupMenu(
          controller: _controller,
          menuBuilder: _buildMenu(),
          child: Text('受控菜单'),
        ),
        
        // 外部控制按钮
        ElevatedButton(
          onPressed: () => _controller.showMenu(),
          child: Text('显示菜单'),
        ),
        ElevatedButton(
          onPressed: () => _controller.hideMenu(),
          child: Text('隐藏菜单'),
        ),
        ElevatedButton(
          onPressed: () => _controller.toggleMenu(),
          child: Text('切换菜单'),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### 监听菜单状态

```dart
ComPopupMenu(
  menuOnChange: (bool isShowing) {
    print('菜单状态: ${isShowing ? "显示" : "隐藏"}');
    // 可以在这里处理菜单状态变化的逻辑
  },
  menuBuilder: _buildMenu(),
  child: _buildTrigger(),
)
```

## 🎯 高级用法

### 图标网格菜单

```dart
Widget _buildIconGridMenu() {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1,
      children: [
        _buildIconItem(Icons.star, '收藏', Colors.amber),
        _buildIconItem(Icons.share, '分享', Colors.blue),
        _buildIconItem(Icons.download, '下载', Colors.green),
        _buildIconItem(Icons.edit, '编辑', Colors.orange),
        _buildIconItem(Icons.delete, '删除', Colors.red),
        _buildIconItem(Icons.more_horiz, '更多', Colors.grey),
      ],
    ),
  );
}

Widget _buildIconItem(IconData icon, String label, Color color) {
  return InkWell(
    onTap: () => print('点击了$label'),
    borderRadius: BorderRadius.circular(8),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
```

### 自定义样式菜单

```dart
Widget _buildStyledMenu() {
  return Material(
    borderRadius: BorderRadius.circular(16),
    elevation: 8,
    color: Colors.deepPurple[50],
    child: Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🎨 自定义菜单',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[700],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple[300]!, Colors.purple[300]!],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 12),
          _buildStyledMenuItem(Icons.star, '收藏此页面', Colors.amber[600]!),
          const SizedBox(height: 8),
          _buildStyledMenuItem(Icons.share, '分享给朋友', Colors.blue[600]!),
          const SizedBox(height: 8),
          _buildStyledMenuItem(Icons.report, '举报内容', Colors.red[600]!),
        ],
      ),
    ),
  );
}
```

### 无箭头简洁菜单

```dart
ComPopupMenu(
  showArrow: false,
  menuBuilder: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.teal[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.teal[200]!),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline, color: Colors.teal[600], size: 24),
        const SizedBox(height: 8),
        Text(
          '这是一个没有箭头的菜单\n适合需要简洁外观的场景',
          style: TextStyle(
            color: Colors.teal[700],
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  ),
  child: Chip(label: Text('简洁菜单')),
)
```

## 🔧 最佳实践

### 1. 合理选择触发方式

```dart
// 主要操作使用单击
ComPopupMenu(
  pressType: PressType.singleClick,
  menuBuilder: _buildMainActions(),
  child: ElevatedButton(child: Text('操作菜单')),
)

// 辅助操作使用长按
ComPopupMenu(
  pressType: PressType.longPress,
  menuBuilder: _buildContextActions(),
  child: ListTile(title: Text('长按查看更多选项')),
)
```

### 2. 响应式菜单宽度

```dart
Widget _buildResponsiveMenu() {
  return LayoutBuilder(
    builder: (context, constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      final menuWidth = math.min(screenWidth * 0.8, 300.0);
      
      return Container(
        width: menuWidth,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: _buildMenuContent(),
      );
    },
  );
}
```

### 3. 主题适配

```dart
Widget _buildThemedMenu(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? Colors.grey[800] : Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: _buildMenuItems(isDark),
  );
}
```

### 4. 宽度控制最佳实践

```dart
// 推荐：为便利构造函数设置合理的宽度限制
ComPopupMenu.text(
  text: '很长的文本内容可能会导致菜单过宽',
  maxWidth: 300, // 限制最大宽度
  child: ElevatedButton(
    child: Text('文本菜单'),
    onPressed: () {},
  ),
)

// 推荐：选项菜单设置最小和最大宽度
ComPopupMenu.options(
  options: [...],
  minWidth: 120, // 确保菜单有足够宽度
  maxWidth: 250, // 防止菜单过宽
  child: IconButton(
    icon: Icon(Icons.more_vert),
    onPressed: () {},
  ),
)

// 不推荐：让菜单宽度不受限制
ComPopupMenu.options(
  options: [...],
  // 没有设置宽度限制，可能导致菜单过宽
  child: IconButton(icon: Icon(Icons.more_vert)),
)
```

### 5. 错误处理

```dart
class SafePopupMenuExample extends StatefulWidget {
  @override
  _SafePopupMenuExampleState createState() => _SafePopupMenuExampleState();
}

class _SafePopupMenuExampleState extends State<SafePopupMenuExample> {
  final ComPopupMenuController _controller = ComPopupMenuController();
  
  @override
  void dispose() {
    // 确保控制器被正确释放
    _controller.dispose();
    super.dispose();
  }
  
  void _safeMenuAction() {
    try {
      // 安全的菜单操作
      if (mounted && !_controller.menuIsShowing) {
        _controller.showMenu();
      }
    } catch (e) {
      // 处理可能的错误
      debugPrint('Menu action failed: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ComPopupMenu(
      controller: _controller,
      menuOnChange: (isShowing) {
        // 安全的状态更新
        if (mounted) {
          setState(() {
            // 更新UI状态
          });
        }
      },
      menuBuilder: _buildSafeMenu(),
      child: ElevatedButton(
        onPressed: _safeMenuAction,
        child: Text('安全菜单'),
      ),
    );
  }
  
  Widget _buildSafeMenu() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.check),
            title: Text('安全操作'),
            onTap: () {
              // 确保在mounted状态下操作
              if (mounted) {
                _controller.hideMenu();
                // 执行安全的业务逻辑
              }
            },
          ),
        ],
      ),
    );
  }
}
```

## 📚 API 参考

### ComPopupMenu

| 参数 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| child | Widget | 必需 | 触发菜单的子组件 |
| menuBuilder | Widget? | 必需 | 菜单内容构建器 |
| pressType | PressType | singleClick | 触发方式 |
| controller | ComPopupMenuController? | null | 菜单控制器 |
| showArrow | bool | true | 是否显示箭头 |
| arrowColor | Color? | null | 箭头颜色 |
| arrowSize | double | 14.0 | 箭头大小 |
| barrierColor | Color | Colors.black12 | 遮罩层颜色 |
| horizontalMargin | double | 16.0 | 水平边距 |
| verticalMargin | double | 4.0 | 垂直边距 |
| position | PreferredPosition? | null | 首选位置 |
| menuOnChange | void Function(bool)? | null | 菜单状态变化回调 |
| enablePassEvent | bool | true | 是否启用点击穿透 |
| semanticLabel | String? | null | 语义化标签 |
| excludeFromSemantics | bool | false | 是否从语义树中排除 |

### PopupMenuOption

| 参数 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| text | String | 必需 | 选项文本 |
| onTap | VoidCallback | 必需 | 点击回调 |
| icon | IconData? | null | 选项图标 |
| iconColor | Color? | null | 图标颜色 |
| textStyle | TextStyle? | null | 文本样式 |

### 便利构造函数

#### ComPopupMenu.text()

| 参数 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| child | Widget | 必需 | 触发菜单的子组件 |
| text | String | 必需 | 显示的文本内容 |
| textStyle | TextStyle? | null | 文本样式 |
| padding | EdgeInsets? | EdgeInsets.symmetric(horizontal: 16, vertical: 12) | 内边距 |
| backgroundColor | Color? | Colors.white | 背景颜色 |
| borderRadius | BorderRadius? | BorderRadius.circular(8) | 圆角半径 |
| pressType | PressType | singleClick | 触发方式 |
| controller | ComPopupMenuController? | null | 菜单控制器 |
| position | PreferredPosition? | null | 首选位置 |
| showArrow | bool | true | 是否显示箭头 |
| arrowColor | Color? | null | 箭头颜色 |
| onMenuChanged | void Function(bool)? | null | 菜单状态变化回调 |

#### ComPopupMenu.options()

| 参数 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| child | Widget | 必需 | 触发菜单的子组件 |
| options | List\<PopupMenuOption\> | 必需 | 选项列表 |
| backgroundColor | Color? | Colors.white | 背景颜色 |
| borderRadius | BorderRadius? | BorderRadius.circular(8) | 圆角半径 |
| pressType | PressType | singleClick | 触发方式 |
| controller | ComPopupMenuController? | null | 菜单控制器 |
| position | PreferredPosition? | null | 首选位置 |
| showArrow | bool | true | 是否显示箭头 |
| arrowColor | Color? | null | 箭头颜色 |
| onMenuChanged | void Function(bool)? | null | 菜单状态变化回调 |

### PressType

| 值 | 描述 |
|------|------|
| singleClick | 单击触发 |
| longPress | 长按触发 |

### PreferredPosition

| 值 | 描述 |
|------|------|
| top | 优先在顶部显示 |
| bottom | 优先在底部显示 |

### ComPopupMenuController

| 方法/属性 | 类型 | 描述 |
|------|------|------|
| showMenu() | void | 显示菜单 |
| hideMenu() | void | 隐藏菜单 |
| toggleMenu() | void | 切换菜单显示状态 |
| menuIsShowing | bool | 获取当前菜单是否显示（只读属性） |
| dispose() | void | 释放控制器资源 |

## ♿ 无障碍支持

### 语义化标签

```dart
ComPopupMenu(
  semanticLabel: '操作菜单', // 为屏幕阅读器提供描述
  excludeFromSemantics: false, // 包含在语义树中
  menuBuilder: _buildMenu(),
  child: IconButton(
    icon: Icon(Icons.more_vert),
    onPressed: () {},
  ),
)
```

### 触觉反馈

组件在菜单操作时会自动提供适当的触觉反馈（仅在支持的平台上）：

```dart
// 组件内部会自动调用
if (!PlatformUtil.isWeb) {
  HapticFeedback.lightImpact();
}
```

### 键盘导航

组件支持标准的Flutter键盘导航模式，可以通过Tab键访问和操作。

## 🎭 样式定制

### 自定义箭头样式

你可以通过修改 `arrowColor` 和 `arrowSize` 来定制箭头外观：

```dart
ComPopupMenu(
  showArrow: true,
  arrowSize: 20.0,
  arrowColor: Colors.blue,
  // ...
)
```

### 自定义动画效果

组件内置了平滑的淡入淡出动画，如果需要自定义动画效果，可以在 `menuBuilder` 中包装动画组件：

```dart
Widget _buildAnimatedMenu() {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 200),
    builder: (context, value, child) {
      return Transform.scale(
        scale: value,
        child: Opacity(
          opacity: value,
          child: _buildMenuContent(),
        ),
      );
    },
  );
}
```

## 🐛 常见问题

### Q: 菜单位置不正确？
A: 确保触发组件有明确的尺寸，避免使用 `Flexible` 或 `Expanded` 包装触发组件。新版本已经改进了位置计算算法，支持更好的边界检测。

### Q: 点击菜单外部无法关闭？
A: 检查 `barrierColor` 是否为透明色，如果是透明色需要设置 `enablePassEvent: false`。

### Q: 在某些情况下菜单不显示？
A: 确保在 `WidgetsBinding.instance.addPostFrameCallback` 之后调用显示方法。新版本增强了错误处理，会在控制台输出调试信息。

### Q: 如何在菜单中添加复杂交互？
A: 在 `menuBuilder` 中可以添加任何 Flutter 组件，包括按钮、输入框、列表等。推荐使用新的便利构造函数 `ComPopupMenu.options()` 来简化常见的选项菜单。

### Q: 控制器使用后出现内存泄漏？
A: 确保在 `dispose()` 方法中调用 `controller.dispose()`。新版本改进了控制器生命周期管理，只有自创建的控制器才会被自动释放。

### Q: 菜单在屏幕边缘被截断？
A: 新版本已经优化了边界检测算法，会自动调整菜单位置避免溢出。如果仍有问题，可以调整 `horizontalMargin` 和 `verticalMargin` 参数。

### Q: 如何快速创建简单的文本提示菜单？
A: 使用新的便利构造函数：
```dart
ComPopupMenu.text(
  text: '提示内容',
  child: YourTriggerWidget(),
)
```

### Q: 语义化支持如何配置？
A: 使用 `semanticLabel` 参数为屏幕阅读器提供描述，使用 `excludeFromSemantics` 控制是否包含在语义树中。