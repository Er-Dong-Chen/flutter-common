# Network Debug Module

`network_debug` 是一个用于 Flutter 应用的网络请求调试模块，提供了轻量级的抓包功能、可视化的日志查看界面以及灵活的配置选项。

## ✨ 功能特性

*   **实时抓包**：自动拦截并记录基于 Dio 的网络请求。
*   **可视化浮窗**：提供可拖拽的悬浮按钮，一键唤起调试面板。
*   **智能着色**：
    *   **状态码**：2xx 显示绿色，错误显示红色，其他显示橙色。
    *   **耗时**：<1000ms 显示绿色，1000ms-3000ms 显示橙色，>3000ms 显示红色。
*   **详情展示**：
    *   支持 Request/Response Headers 和 Body 的查看。
    *   JSON 数据自动格式化。
    *   自动隐藏 URL 域名，仅展示 Path 以节省空间。
*   **实用工具**：支持一键复制完整的请求/响应日志（包含 cURL 关键信息、Header、Body 等）。
*   **安全配置**：支持敏感数据（如 Authorization）脱敏处理。

## 🚀 快速开始

### 1. 初始化（自动接入拦截器）

在应用启动或 `Dio` 初始化后，调用 `ComDebugManager.instance.init` 即可自动为给定的 `Dio` 接入网络调试拦截器，并设置调试配置：

```dart
import 'package:flutter_chen_common/network/debug/network_debug.dart';
import 'package:dio/dio.dart';

void initNetwork() async {
  // 例如使用内置 HttpClient
  final dio = HttpClient.instance.dio;

  await ComDebugManager.instance.init(
    dio: dio,
    comDebugConfig: ComDebugConfig(
      enabled: Env.env != EnvEnum.prod,
      maxLogCount: 100, // 最大日志缓存数量
      sanitize: (log) {
        // 敏感数据脱敏示例
        if (log.request?.headers.containsKey('Authorization') ?? false) {
          log.request?.headers['Authorization'] = '***';
        }
        return log;
      },
    ),
  );
}
```

如不使用自动接入，也可以手动添加拦截器：

```dart
HttpClient.init(
  config: HttpConfig(
    baseUrl: 'https://api.example.com',
    interceptors: [
      ComNetworkLogInterceptor(), // 手动添加网络调试拦截器
    ],
  ),
);
```

### 2. 显示调试入口

在需要显示调试入口的页面（通常是 `MaterialApp` 的 `builder` 或根页面），调用 `ComNetworkLogger.show`：

```dart
import 'package:flutter_chen_common/network/debug/network_debug.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Home')),
      ),
      builder: (context, child) {
        // 在此处挂载浮窗
        ComNetworkLogger.show(
          context, 
          bottom: 100,       // 初始底部距离
          right: 20          // 初始右侧距离
        );
        return child!;
      },
    );
  }
}
```

当 `enabled` 关闭时，`ComNetworkLogger.show` 会直接不做任何操作（不插入浮窗、不占用资源）。

## ⚙️ 配置说明 (ComDebugConfig)

| 参数 | 类型 | 默认值 | 说明 |
| :--- | :--- | :--- | :--- |
| `enabled` | `bool` | `true` | 总开关；关闭后拦截器与浮窗均不生效、零开销。 |
| `maxLogCount` | `int` | `100` | 内存中保留的最大日志条数，超过限制将移除最早的日志。 |
| `sanitize` | `ComLogSanitizer?` | `null` | 日志脱敏回调函数。可在此处修改 `ComNetworkDebug` 对象（如隐藏 Token），返回处理后的日志对象。 |

## 📱 UI 说明

### 列表页
*   展示请求方法 (GET/POST)、URL Path、耗时、时间戳。
*   可通过顶部 Tab 筛选 `All` (全部)、`Success` (成功)、`Error` (失败)。

### 详情页
*   **Status**: 状态码。
*   **Duration**: 请求耗时。
*   **Request/Response**: 分别展示请求和响应的详细信息。
*   **Copy 按钮**: 点击右上角复制按钮，可将完整的请求链路信息复制到剪贴板，便于分享和调试。

## ⚠️ 注意事项

*   建议仅在 `Debug`模式下或非生产环境开启。
*   `maxLogCount` 不宜设置过大，以免占用过多内存。
