# Toast 提示

## 🌟 特性

- 🚀 全局使用，无需传入 `BuildContext`
- 🎨 简洁的内置样式（成功、错误、警告、信息、加载）
- 🌈 自动适配主题颜色（背景色、文本色）
- ⚡ 平滑的淡入淡出动画效果
- 🎯 灵活的位置配置
- 📱 支持自定义内容
- 🔧 完全可配置
- 🛡️ 智能消息过滤（空消息、重复消息）

## 📱 效果预览

![ComToast 效果预览](https://er-dong-chen.github.io/images/demo/toast.gif)

## 🚀 快速开始

### 初始化配置

在 `MaterialApp` 中配置：

```dart
MaterialApp(
  builder: ComToastBuilder(),
  navigatorObservers: [ComToastNavigatorObserver()],
)
```

### 基础使用

```dart
// 普通提示
ComToast.show('这是一条普通提示');

// 成功提示
ComToast.success('操作成功');

// 错误提示
ComToast.error('操作失败');

// 警告提示
ComToast.warning('请注意');

// 信息提示
ComToast.info('这是一条信息');

// 关闭Toast
ComToast.dismiss();
```

## 🎨 自定义配置

### 自定义样式

```dart
ComToast.show(
  '自定义Toast',
  config: ComToastConfig(
    duration: const Duration(seconds: 3),
    position: ComToastPosition.center,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 16.0,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    borderRadius: 8.0,
    maxWidth: 200.0,
    showShadow: true,
  ),
);

ComToast.initTheme(
  theme: ComToastTheme(
    success: const ComToastConfig(
      iconWidget:
          Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
    ),
    error: const ComToastConfig(
      iconWidget: Icon(Icons.cancel, color: Color(0xFFEF4444), size: 20),
    ),
    warning: const ComToastConfig(
      iconWidget:
          Icon(Icons.priority_high, color: Color(0xFFF59E0B), size: 20),
    ),
    info: const ComToastConfig(
      iconWidget:
          Icon(Icons.info_outline, color: Color(0xFF3B82F6), size: 20),
    ),
    loading: ComToastConfig(
      builder: (ctx) => const ComContainer(
        width: 120,
        child: ComLoading(),
      ),
      clickThrough: false,
      duration: Duration.zero,
    ),
  ),
);
```

### 自定义内容

```dart
ComToast.custom(
  builder: (context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.yellow),
        const SizedBox(width: 8),
        Text('自定义Toast', style: TextStyle(color: Colors.white)),
      ],
    ),
  ),
);
```

## ⚡ Loading 功能

### 基础使用

```dart
// 显示Loading
ComToast.loading(message: '加载中...');

// 隐藏Loading
ComToast.hideLoading();

// 自动处理Loading的异步操作
final result = await ComToast.autoLoading(
  () => api.getData(),
  message: '加载数据中...',
);
```

### 自定义 Loading

```dart
ComToast.customLoading(
  builder: (context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(color: Colors.white),
        const SizedBox(height: 8),
        Text('自定义Loading', style: TextStyle(color: Colors.white)),
      ],
    ),
  ),
);
```

## 🔧 高级配置

### 全局配置

```dart
ComToast.init(
  config: ComToastConfig(
    duration: const Duration(seconds: 2),
    position: ComToastPosition.bottom,
  ),
);
```

### 消息过滤

```dart
// 设置重复消息过滤时间（毫秒）
ComToast.setDuplicateFilterDuration(1000);

// 清除消息过滤缓存
ComToast.clearMessageFilter();
```

### 其他功能

```dart
// 关闭当前显示的Toast
ComToast.dismiss();
```

## 📚 API 参考

### ComToastConfig

| 参数 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| duration | Duration | 2秒 | 显示时长 |
| position | ComToastPosition | bottom | 显示位置 |
| backgroundColor | Color | 主题色 | 背景颜色 |
| textColor | Color | 白色 | 文字颜色 |
| fontSize | double | 14.0 | 文字大小 |
| padding | EdgeInsets | 16.0 | 内边距 |
| borderRadius | double | 8.0 | 圆角大小 |
| maxWidth | double | 200.0 | 最大宽度 |
| showShadow | bool | true | 是否显示阴影 |

### ComToastPosition

| 值 | 描述 |
|------|------|
| top | 顶部显示 |
| center | 中间显示 |
| bottom | 底部显示 |