# 国际化

## 🌟 特性

- 🌍 支持多语言切换
- 📚 内置中英文支持
- ⚡ 支持动态语言切换
- 🎯 支持自定义文本
- 🔧 支持语言持久化
- 📱 完美适配 iOS/Material 设计规范
- 🛡️ 支持语言回退机制
- 🎨 支持格式化文本

## 📱 效果预览

![国际化效果预览](assets/images/localization_preview.gif)

## 🚀 快速开始

### 基础配置

```dart
MaterialApp(
  localizationsDelegates: [
    ComLocalizations.delegate,
  ],
  supportedLocales: [
    const Locale('zh', 'CN'),
    const Locale('en', 'US'),
  ],
  home: MainPage(),
)
```

### 使用国际化文本

```dart
// 获取本地化实例
final l10n = ComLocalizations.of(context);

// 使用本地化文本
Text(l10n.confirm)
Text(l10n.cancel)
Text(l10n.loading)
```

## 🎨 自定义文本

### 创建自定义本地化类

```dart
class FrIntl extends ComIntl {
  @override
  String get confirm => "Confirmer";
  
  @override
  String get cancel => "Annuler";
  
  @override
  String get loading => "Chargement...";
}
```

### 注册新语言

```dart
// 注册法语支持
ComLocalizations.addLocalization('fr', FrIntl());

// 配置MaterialApp
MaterialApp(
  supportedLocales: [
    const Locale('fr'), // 新增法语支持
  ],
)
```

## 📚 API 参考

### ComLocalizations

| 方法 | 描述 |
|------|------|
| of(context) | 获取本地化实例 |
| addLocalization() | 添加新的语言支持 |
| delegate | 本地化代理 |

### ComIntl

| 属性 | 描述 |
|------|------|
| confirm | 确认按钮文本 |
| cancel | 取消按钮文本 |
| loading | 加载中文本 |
| noData | 暂未数据文本 |
| loadingFailed | 加载失败文本 |
| networkError | 网络失败文本 |
| networkRetry | 网络重试文本 |

### Locale

| 参数 | 类型 | 描述 |
|------|------|------|
| languageCode | String | 语言代码 |
| countryCode | String? | 国家/地区代码 |

## 🌍 默认支持的语言

| 语言 | 代码 | 状态 |
|------|------|------|
| 简体中文 | zh_CN | ✅ 内置 |
| 英文 | en_US | ✅ 内置 |