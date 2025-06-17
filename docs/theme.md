# 主题系统

## 🌟 特性

- 🎨 支持亮暗主题切换
- 🌈 完整的颜色系统
- ⚡ 可定制的圆角系统
- 📏 统一的间距系统
- 🔧 支持主题扩展
- 🎯 支持动态主题切换
- 📱 完美适配 iOS/Material 设计规范
- 🛡️ 支持主题持久化

## 📱 效果预览

![主题系统效果预览](assets/images/theme_preview.gif)

## 🚀 快速开始

### 基础配置

```dart
MaterialApp(
  theme: ThemeData.light().copyWith(
    extensions: [ComTheme.light()],
  ),
  darkTheme: ThemeData.dark().copyWith(
    extensions: [ComTheme.dark()],
  ),
  home: MainPage(),
)
```

### 使用主题

```dart
// 获取主题
final theme = Theme.of(context).extension<ComTheme>();

// 使用主题颜色
Container(
  color: theme?.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: theme?.onPrimary),
  ),
)

// 使用主题圆角
Container(
  decoration: BoxDecoration(
    borderRadius: theme?.shapes.small,
  ),
)

// 使用主题间距
Padding(
  padding: theme?.spacing.medium ?? EdgeInsets.zero,
  child: child,
)
```

## 🎨 自定义主题

### 创建自定义主题

```dart
final customTheme = ComTheme(
  // 圆角系统
  shapes: ComShapes(
    small: BorderRadius.circular(4),
    medium: BorderRadius.circular(8),
    large: BorderRadius.circular(16),
  ),
  
  // 间距系统
  spacing: ComSpacing(
    small: const EdgeInsets.all(8),
    medium: const EdgeInsets.all(16),
    large: const EdgeInsets.all(24),
  ),
);
```

### 注册自定义主题

```dart
MaterialApp(
  theme: ThemeData.light().copyWith(
    extensions: [customTheme],
  ),
  home: MainPage(),
)
```

## 📚 API 参考

### ComTheme

| 参数 | 类型 | 描述 |
|------|------|------|
| shapes | ComShapes | 圆角系统 |
| spacing | ComSpacing | 间距系统 |

### ComShapes

| 参数 | 类型 | 描述 |
|------|------|------|
| small | BorderRadius | 小圆角 |
| medium | BorderRadius | 中等圆角 |
| large | BorderRadius | 大圆角 |

### ComSpacing

| 参数 | 类型 | 描述 |
|------|------|------|
| small | EdgeInsets | 小间距 |
| medium | EdgeInsets | 中等间距 |
| large | EdgeInsets | 大间距 | 