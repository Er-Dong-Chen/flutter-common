# Network Debug Module

`network_debug` 是一个用于 Flutter 应用的统一调试模块，可在同一个界面中查看 HTTP 请求、WebSocket 连接、应用日志，以及项目显式接入的 Push 事件与 Storage 操作，并提供轻量级的内存保护与可注入的敏感信息脱敏能力。

## ✨ 功能特性

*   **实时抓包**：自动拦截并记录基于 Dio 的网络请求。
*   **WebSocket 调试**：记录连接状态、握手耗时、关闭信息及收发消息，默认按 Sent、Received、Event 各自保留最新 100 条，避免不同方向互相淘汰。
*   **应用日志**：自动接入库内 `Log`，默认只记录 `info` 及以上级别，`console` 按 `debug` 处理。
*   **Push 调试**：项目显式启用后主动上报接收、点击、Token、权限、生命周期、错误或自定义事件，不绑定具体推送厂商。
*   **Storage 调试**：项目显式启用后记录读、写、删除、清空、查询或错误操作，不绑定具体存储插件。
*   **统一切换**：点击顶部标题的下拉菜单，在 Network、WebSocket、Log 和已启用的扩展能力之间快速切换。
*   **分类清理**：右上角清理按钮只清除当前选中的调试数据，不影响其他分类。
*   **动态开关**：支持运行时动态开启/关闭调试，无需重新接入拦截器或重新挂载浮窗。
*   **重试合并**：一次业务请求触发的自动重试共用一条记录，并显示重试次数，避免失败尝试残留为 Pending。
*   **可视化浮窗**：提供可拖拽的悬浮按钮，一键唤起调试面板，并支持主动隐藏。
*   **请求导出**：内置 `Slow / Error` 两类请求导出能力，外部项目也可通过配置自定义导出实现。
*   **智能着色**：
    *   **状态码**：2xx 显示绿色，错误显示红色，其他显示橙色。
    *   **耗时**：<1000ms 显示绿色，1000ms-3000ms 显示橙色，>3000ms 显示红色。
*   **详情展示**：
    *   支持 Request/Response Headers 和 Body 的查看。
    *   JSON 数据自动格式化。
    *   自动隐藏 URL 域名，仅展示 Path 以节省空间。
    *   请求头会以最终实际发出的 `RequestOptions` 为准，包含后续拦截器追加的 Header。
*   **实用工具**：支持一键复制完整的请求/响应日志（包含 cURL 关键信息、Header、Body 等）。
*   **安全配置**：提供 HTTP、WebSocket 和应用日志脱敏回调，并限制单个载荷长度。模块默认不修改任何字段，具体规则由接入项目实现。

![ComNetworkLogger 效果预览](https://er-dong-chen.github.io/images/demo/network_debug.gif)

## 🚀 快速开始

### 1. 初始化（自动接入拦截器）

在应用启动或 `Dio` 初始化后，调用 `ComDebugManager.instance.init` 即可自动为给定的 `Dio` 接入网络调试拦截器，并设置调试配置。后续如果新增了新的 `Dio` 实例，也可以再次调用 `init(dio: anotherDio)` 继续接入：

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
      maxWebSocketConnectionCount: 10, // 最多保留的 WebSocket 连接
      maxWebSocketMessageCount: 100, // 每个 WebSocket 每种消息方向的数量
      maxWebSocketTotalMessageBytes: 8 * 1024 * 1024, // 所有连接消息载荷总预算
      webSocketNotifyInterval: const Duration(milliseconds: 100),
      minAppLogLevel: ComDebugLogLevel.info,
      // 项目完成对应采集与脱敏接入后再显式设为 true。
      enablePushDebug: false,
      enableStorageDebug: false,
      maxPushLogCount: 100,
      maxStorageLogCount: 100,
      maxStorageEntryCount: 200,
      maxStorageSnapshotBytes: 2 * 1024 * 1024,
      onDeleteStorage: (storage, key) async {
        if (storage == 'preferences') {
          return SpUtil.remove(key);
        }
        return false;
      },
      maxPayloadLength: 64 * 1024,
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
    // 让控制台 HTTP 日志同步跟随调试总开关，关闭时跳过计时、复制、脱敏和格式化。
    shouldLog: () => ComDebugManager.instance.isEnabled,
    interceptors: [
      ComNetworkDebugInterceptor(), // 手动添加网络调试拦截器
    ],
  ),
);
```

### 2. 显示调试入口

在需要显示调试入口的页面（通常是 `MaterialApp` 的 `builder` 或根页面），调用 `ComDebugLogger.show`：

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
        ComDebugLogger.show(
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

`ComDebugLogger.show` 只需要在应用启动时调用一次；后续通过 `ComDebugManager.instance.setEnabled(true/false)` 就可以动态控制浮窗和日志采集状态，无需重新调用 `show`。原有 `ComNetworkLogger` API 继续保留兼容。

如需主动移除悬浮入口，也可以调用：

```dart
ComDebugLogger.hide();
```

### 3. 动态开启 / 关闭调试

```dart
await ComDebugManager.instance.setEnabled(false); // 关闭采集与入口显示
await ComDebugManager.instance.setEnabled(true);  // 重新开启
```

### 4. 记录 WebSocket 生命周期

调试管理器不会替换业务层的 WebSocket 库，只需在现有的连接、收发和关闭回调中记录对应事件：

```dart
final manager = ComDebugManager.instance;
final socketLog = manager.startWebSocket(url: socketUrl);

manager.markWebSocketOpen(socketLog.id);
manager.addWebSocketMessage(
  socketLog.id,
  direction: ComWebSocketMessageDirection.sent,
  data: {'type': 'ping'},
);
manager.addWebSocketMessage(
  socketLog.id,
  direction: ComWebSocketMessageDirection.received,
  data: {'type': 'pong'},
);
manager.markWebSocketClosed(socketLog.id, closeCode: 1000);
```

收发总数不会因旧消息被清理而减少；界面会同时显示已丢弃的历史消息数。所有连接的消息载荷还受总字节预算约束，超限时优先淘汰最旧消息。WebSocket 高频消息默认每 100ms 合并刷新一次 UI，避免每条消息都触发整个列表重建；没有 UI 或其他监听者时不会调度刷新，只维护受上限约束的内存数据。

单条 WebSocket 消息超过 `maxPayloadLength` 后仅缓存截断后的内容，同时通过 `originalSizeBytes`、`retainedSizeBytes` 和 `isTruncated` 保留原始 UTF-8 大小、实际缓存大小及截断状态；详情页和复制文本都会明确展示这些信息。

### 5. 查看应用日志

完成 `ComDebugManager.init()` 后，通过库内 `Log.d`、`Log.i`、`Log.w`、`Log.e`、`Log.f` 等方法输出的日志会自动进入 Log 面板。初始化之前、调试开关关闭时或低于 `minAppLogLevel` 的日志不会记录，避免无意中增加内存开销。Log 面板将 Trace、Debug 和 Console 归为 Debug 分类，其余等级独立筛选。

应用日志消息同样遵循 `maxPayloadLength`，并通过 `ComAppLog.originalSizeBytes`、`retainedSizeBytes` 和 `isTruncated` 暴露载荷元数据，不会为了查看原始大小而额外保留完整大消息。

运行时更换某一类脱敏回调，或收紧 `maxPayloadLength` 时，已缓存的受影响类别会清空，避免旧记录继续按过时规则展示。库不会自带默认脱敏；脱敏回调异常默认只输出固定提示，项目可通过 `onCaptureError` 接管异常诊断。

### 6. 记录 Push 事件

公共库不依赖 FCM、APNs 或其他推送 SDK，且默认关闭 Push 调试。项目完成采集与脱敏接入后，在 `ComDebugConfig` 中设置 `enablePushDebug: true`，再从已有推送回调上报通用事件：

```dart
ComDebugManager.instance.addPushEvent(
  type: ComPushEventType.received,
  provider: 'project-adapter',
  messageId: messageId,
  title: title,
  body: body,
  payload: payload,
);
```

### 7. 记录 Storage 操作

公共库不会主动扫描项目存储，且默认关闭 Storage 调试。项目完成采集与脱敏接入后，在 `ComDebugConfig` 中设置 `enableStorageDebug: true`。启用后，内置 `SpUtil` 会自动记录自身操作；SharedPreferences、SecureStorage、Hive 或其他适配层可按需上报：

```dart
ComDebugManager.instance.addStorageOperation(
  operation: ComStorageOperation.write,
  storage: 'preferences',
  key: key,
  value: value,
  durationMs: elapsedMilliseconds,
);
```

只有调试总开关与 `enableStorageDebug` 同时开启时，`SpUtil` 才会记录自身读写操作；否则沿原始直接路径执行，不计时、不构造调试记录。其他存储实现仍通过上述接口或自身提供的通用观察器接入。

Storage 页面不会再根据操作历史猜测当前数据。项目通过 `loadStorageEntries` 提供真实快照，页面按 `storage` 名称动态分类；未配置时会显示明确的未接入提示。快照达到条目或字节预算时停止处理后续条目，页面会提示当前只展示部分数据。大型数据源宜返回惰性 `Iterable`，避免在进入库的预算控制前就构造完整快照。公共库不会直接依赖或操作 SecureStorage、Hive 等第三方 SDK：

```dart
ComDebugConfig(
  enableStorageDebug: true,
  loadStorageEntries: () async {
    final secureEntries = await secureStorage.readAll();
    return [
      for (final entry in SpUtil.snapshot().entries)
        ComStorageEntry(
          storage: 'preferences',
          key: entry.key,
          value: entry.value,
        ),
      for (final entry in secureEntries.entries)
        ComStorageEntry(
          storage: 'secure_storage',
          key: entry.key,
          value: entry.value,
        ),
    ];
  },
  onDeleteStorage: (storage, key) async {
    if (storage == 'preferences') return SpUtil.remove(key);
    if (storage == 'secure_storage') {
      await secureStorage.delete(key: key);
      return true;
    }
    return false;
  },
  onClearStorage: () async {
    final preferencesCleared = await SpUtil.clear();
    await secureStorage.deleteAll();
    return preferencesCleared;
  },
)
```

详情页删除单个条目、Storage 顶部清空所有数据都会在执行前二次确认。单项删除始终使用脱敏前的原始 `storage/key`；全量清空由项目通过 `onClearStorage` 清理所有已接入的存储实现。回调返回 `true` 后会重新加载真实快照，未配置相应回调时不显示删除入口。快照加载应直接读取底层存储，避免通过已埋点的读取方法产生额外操作日志；内置 `SpUtil.snapshot()` 专门用于这一场景。

### 8. 导出请求

库内部不依赖第三方分享库，默认导出行为是将所选类型的请求列表以 CSV 形式复制到剪贴板：

```dart
final export = await ComDebugManager.instance.exportLogs(
  type: ComDebugExportType.slow,
);
print(export.csv);
```

如果业务层需要“分享 / 存文件 / 上传”之类的自定义导出行为，可以在初始化时传入 `onExportLogs`：

```dart
await ComDebugManager.instance.init(
  dio: dio,
  comDebugConfig: ComDebugConfig(
    onExportLogs: (export) async {
      // export.logs: 结构化数据
      // export.csv: 默认 CSV 文本（更适合 Excel 打开）
      // export.json: JSON 文本
      // 交给业务层自行接 share/file/upload
    },
  ),
);
```

## ⚙️ 配置说明 (ComDebugConfig)

| 参数 | 类型 | 默认值 | 说明 |
| :--- | :--- | :--- | :--- |
| `enabled` | `bool` | `true` | 总开关；关闭后停止新增日志采集，浮窗入口也会自动隐藏。 |
| `maxLogCount` | `int` | `100` | 内存中保留的最大日志条数，超过限制将移除最早的日志。 |
| `maxWebSocketConnectionCount` | `int` | `10` | 最多保留的 WebSocket 连接数；超限时优先移除最早的 Closed/Error 连接，否则移除最早连接。 |
| `maxWebSocketMessageCount` | `int` | `100` | 每个 WebSocket 连接按 Sent、Received、Event 分别保留的最大消息数，各方向互不淘汰；总收发计数仍会继续累计。 |
| `maxWebSocketTotalMessageBytes` | `int` | `8MB` | 所有连接已缓存消息载荷的总字节预算，超限时淘汰最旧消息。 |
| `webSocketNotifyInterval` | `Duration` | `100ms` | WebSocket 高频消息触发 UI 刷新的合并间隔；设为 `Duration.zero` 可立即刷新。 |
| `minAppLogLevel` | `ComDebugLogLevel` | `info` | 应用日志最低采集级别；`console` 与 `debug` 同级。 |
| `enablePushDebug` | `bool` | `false` | Push 调试能力开关；未开启时不采集数据，也不显示 Push 入口。 |
| `enableStorageDebug` | `bool` | `false` | Storage 调试能力开关；未开启时 `SpUtil` 不增加调试开销，也不显示 Storage 入口。 |
| `maxPushLogCount` | `int` | `100` | 内存中保留的最大 Push 事件数量。 |
| `maxStorageLogCount` | `int` | `100` | 内存中保留的最大 Storage 操作数量。 |
| `maxStorageEntryCount` | `int` | `200` | 一次 Storage 快照最多保留的条目数，独立于操作日志上限。 |
| `maxStorageSnapshotBytes` | `int` | `2MB` | 一次 Storage 快照的累计载荷预算；截断时面板提示只展示部分条目。 |
| `maxPayloadLength` | `int` | `65536` | 单个 Body、WebSocket 消息、日志文本等的缓存预算；字符串按 UTF-8 字节截断，WebSocket 消息与应用日志另记录原始/缓存字节数及截断状态。 |
| `isBusinessCodeSuccessful` | `bool Function(int)` | `code == 200` | 响应体存在 `code` 时的项目成功判定；没有 `code` 时按 HTTP 2xx 判断。 |
| `sanitize` | `ComLogSanitizer?` | `null` | HTTP 日志脱敏回调。收到的是按 `maxPayloadLength` 限制后的日志副本，可安全修改而不会污染原始请求对象。 |
| `sanitizeWebSocket` | `ComWebSocketLogSanitizer?` | `null` | WebSocket 连接元数据及请求头脱敏回调。 |
| `sanitizeWebSocketMessage` | `ComWebSocketMessageSanitizer?` | `null` | WebSocket 单条消息脱敏回调。 |
| `sanitizeAppLog` | `ComAppLogSanitizer?` | `null` | 应用日志脱敏回调。 |
| `sanitizePushLog` | `ComPushLogSanitizer?` | `null` | Push 事件脱敏回调。 |
| `sanitizeStorageLog` | `ComStorageLogSanitizer?` | `null` | Storage 操作脱敏回调。 |
| `loadStorageEntries` | `ComStorageEntriesLoader?` | `null` | 由项目加载真实 Storage 快照；未配置时不展示基于操作日志推导的伪快照。 |
| `onDeleteStorage` | `ComStorageDeleteHandler?` | `null` | 删除真实存储项的项目回调；未配置时详情页不显示删除按钮。 |
| `onClearStorage` | `ComStorageClearHandler?` | `null` | 清空所有真实存储的项目回调；未配置时 Storage 顶部不显示垃圾桶。 |
| `onExportLogs` | `ComSlowLogsExporter?` | `null` | 自定义请求导出回调；未提供时默认复制 CSV 到剪贴板。 |
| `onCaptureError` | `ComDebugCaptureErrorHandler?` | `null` | 项目可选的调试采集异常回调；默认不打印可能含敏感值的原始异常。 |

## 📱 UI 说明

### Network 列表页
*   展示请求方法 (GET/POST)、URL Path、耗时、时间戳。
*   自动重试时额外显示 `Retry N`；耗时从首次请求开始累计。
*   支持按请求路径进行模糊搜索，可与顶部 Tab 筛选组合使用。
*   可通过顶部 Tab 筛选 `All`、`Pending`、`Success`、`Error`、`Slow`。
*   `Slow` 会筛选 `>=1000ms` 的已完成请求，并按“方法 + 标准化 URL”去重，仅保留最新一条。
*   右上角导出按钮会弹出菜单，可选择导出 `Slow` 或 `Error` 请求。
*   未自定义导出时，默认复制更适合 Excel 打开的 CSV 到剪贴板；如配置了 `onExportLogs`，则改走自定义逻辑。

### 详情页
*   **Status**: 状态码。
*   **Duration**: 请求耗时。
*   **Request/Response**: 分别展示请求和响应的详细信息。
*   **Copy 按钮**: 点击详情页右上角复制按钮，可将完整的请求链路信息复制到剪贴板，便于分享和调试。

### WebSocket 列表页
*   显示 `Connecting`、`Open`、`Closed`、`Error` 连接状态、握手耗时和存活时长。
*   详情中可按 All、Sent、Received、Event 筛选消息，并显示历史收发总数与已丢弃数量。
*   每条消息均可进入独立详情页，查看方向、时间、类型、大小和完整数据，并支持单条复制。

### Log 列表页
*   支持 Debug、Info、Warning、Error、Fatal 等级别筛选及文本搜索；Trace 和 Console 归入 Debug 分类。
*   复制和 JSON/CSV 导出不包含 `stackTrace`，避免携带冗长或敏感的调用栈。

### Push 列表页
*   仅在 `enablePushDebug` 为 `true` 时显示。
*   支持 All、Received、Opened、Error 分类筛选，以及消息、载荷和元数据搜索。
*   详情展示通用推送字段、Payload、Metadata 和错误信息，并支持格式化与复制。

### Storage 列表页
*   仅在 `enableStorageDebug` 为 `true` 时显示。
*   通过 `loadStorageEntries` 加载真实快照，并按存储类型动态生成 Preferences、Secure Storage、Hive、Cache 等分类。
*   顶部刷新按钮可重新读取快照；成功写入、删除或清空操作也会触发短防抖自动刷新。
*   详情展示当前 Value 和 Metadata 并支持复制；配置 `onDeleteStorage` 后可二次确认并使用脱敏前的原始身份删除单项真实数据。
*   配置 `onClearStorage` 后，顶部垃圾桶会在二次确认后清空项目接入的所有真实 Storage，而不是只清理调试记录。

## ⚠️ 注意事项

*   建议仅在 `Debug`模式下或非生产环境开启。
*   模块不会内置或默认启用任何脱敏规则；请求头、查询参数、Body、WebSocket 消息、应用日志、Push Payload 和 Storage Value 都可能包含敏感信息，接入项目应按自身数据规范配置相应脱敏回调。
*   项目脱敏回调抛出异常时，该条调试记录会被跳过，业务请求、响应和错误链路不会受影响。
*   内置 `HttpClient` 的控制台日志由 `HttpConfig.enableLog` 决定是否安装；需要运行时关闭其开销时，应同时配置 `HttpConfig.shouldLog`。动态回调异常时会安全地跳过日志。
*   `maxLogCount` 不宜设置过大，以免占用过多内存。
*   WebSocket 调试需要业务 WebSocket 客户端主动上报生命周期和消息，该模块不会全局替换或自动拦截任意 WebSocket 库。
*   Push 和 Storage 默认关闭。项目完成对应采集与脱敏接入后再显式开启；公共库不初始化厂商 SDK、不主动扫描真实存储，也不包含业务路由、业务 Key 或协议判断。
