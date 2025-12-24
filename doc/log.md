# 日志系统

## 🌟 特性

- 📝 支持多级别日志
- 💾 支持文件日志
- 🔄 支持日志轮转
- 🎯 支持日志过滤
- 🔧 支持自定义输出
- 📱 支持日志上报
- 🛡️ 支持日志加密

## 🔥 核心特性解析

### 文件结构与轮转

- 当前活动文件名：`latest.log`
- 轮转归档文件名：`{id}_{startMillis}_{endMillis}.log`
- 文件首行元信息：`session={id};start={startMillis}`
- 轮转阈值：默认 `5 MB`（`rotateSizeBytes`）
- 保留策略：默认保留 `3 天`（按文件最近修改时间）
- 写入策略：
  - 缓冲批量写入，默认缓冲 `bufferMaxEvents=256` 条
  - 延迟刷盘：`bufferFlushDelay=300ms`
  - 周期刷盘：`periodicFlushInterval=2s`
- 轮转时序：
  1. 检测到 `latest.log` 超过阈值
  2. 将 `latest.log` 重命名为 `{id}_{start}_{end}.log`
  3. 创建新的 `latest.log` 并写入首行 `session=...;start=...`

### 上传与加密

- 扫描目录下所有 `.log` 文件，跳过 `latest.log`
- 归档日志的时间由文件名解析：`{id}_{start}_{end}.log`
- 上传文件名：`{id}_{start}_{end}.log`
- 加密模式：
  - 压缩：`GZip`
  - 对称加密：`AES-CBC`（随机 32 字节密钥 + 16 字节 IV）
  - 非对称加密：`RSA`（公钥加密 AES 密钥与 IV）
- 明文模式（调试）：`LogPlainUploader.plainMode = kDebugMode`，在调试环境可输出明文

## 🚀 快速开始

### 初始化配置

```dart
// 获取应用文档目录
Directory dir = await getApplicationDocumentsDirectory();

// 初始化日志系统
await Log.init(
  LogConfig(
    id: "UID",                // 用户ID/会话ID（可选，默认 "0"）
    retentionDays: 3,           // 日志保留天数
    enableFileLog: true,        // 启用文件日志
    logLevel: LogLevel.all,     // 日志过滤级别
    recordLevel: LogLevel.info, // 日志记录级别
    output: const [],           // 自定义输出
    logDirectory: Directory('${dir.path}/logs'), // 日志目录
    rotateSizeBytes: 5 * 1024 * 1024,           // 轮转阈值
    bufferMaxEvents: 256,                        // 缓冲事件条数
    bufferFlushDelay: const Duration(milliseconds: 300), // 延迟刷盘
    periodicFlushInterval: const Duration(seconds: 2),   // 周期刷盘
    latestFileName: 'latest.log',                // 活动文件名
  ),
);
```

### 基础使用

```dart
// 调试日志
Log.d("debug message");

// 信息日志
Log.i("info message");

// 警告日志
Log.w("warning message");

// 错误日志
Log.e("error message", error: error, stackTrace: stackTrace);

// 控制台日志（无前缀、打印完全、方便复制）
Log.console("console message");

// 获取日志目录
final Directory dir = await Log.getLogDir();
```

## 🎨 日志配置

### 日志级别

```dart
enum LogLevel {
  verbose,  // 详细日志
  debug,    // 调试日志
  info,     // 信息日志
  warning,  // 警告日志
  error,    // 错误日志
  none,     // 不显示日志
  all,      // 显示所有日志
}
```

### 日志过滤

```dart
LogConfig(
  logLevel: LogLevel.info,  // 低于 info 级别的日志不打印
  recordLevel: LogLevel.warning,  // 低于 warning 级别的日志不写入文件
)
```

### 配置字段详解

| 参数 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `retentionDays` | `int` | `3` | 归档日志保留天数 |
| `enableFileLog` | `bool` | `true` | 是否启用文件写入 |
| `logLevel` | `LogLevel` | `LogLevel.all` | 控制打印到控制台的级别 |
| `recordLevel` | `LogLevel` | `LogLevel.info` | 控制写入文件的最低级别 |
| `logDirectory` | `Directory?` | `null` | 日志目录，非 Web 环境生效 |
| `output` | `List<LogOutput>?` | `null` | 自定义输出（如上报、掩码等） |
| `printer` | `LogPrinter?` | `PrettyPrinter()` | 控制台打印样式 |
| `filter` | `LogFilter?` | `ComLogFilter(...)` | 自定义过滤器 |
| `composeOutputs` | `List<LogOutput> Function(List<LogOutput>)?` | `null` | 输出组合器 |
| `rotateSizeBytes` | `int` | `5MB` | 轮转阈值 |
| `bufferMaxEvents` | `int` | `256` | 缓冲最大事件数 |
| `bufferFlushDelay` | `Duration` | `300ms` | 缓冲延迟刷盘 |
| `periodicFlushInterval` | `Duration` | `2s` | 周期刷盘间隔 |
| `latestFileName` | `String` | `latest.log` | 活动文件名 |

## ⚡ 高级功能

### 自定义输出

```dart
// 自定义输出插件
class SentryOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    if (event.level.value >= LogLevel.error.value) {
      Sentry.captureException(
        event.error,
        stackTrace: event.stackTrace,
        tags: {'log_level': event.level.name},
      );
    }
  }
}

// 配置使用
Log.init(LogConfig(
  output: [SentryOutput()]
));
```


## 🧩 实现细节

- 写入在独立 `Isolate` 中进行，避免阻塞 UI 线程
- 每次批量写入：
  - 将事件格式化并追加到 `latest.log`
  - 检查并触发轮转
  - 清理超期归档文件
- 首行元信息包含 `session` 和 `start`，示例：
  ```
  session=10086;start=1734500000000
  <日志内容...>
  ```
- 文件命名约定：
  - 活动：`latest.log`
  - 归档：`{id}_{start}_{end}.log`
- 上传命名约定：
  - `LogUploader`: `{id}_{start}_{end}.log`
  - `LogPlainUploader`: 同上（在调试环境可明文）

## 📚 API 参考

### Log

| 方法 | 描述 |
|------|------|
| d() | 调试日志 |
| i() | 信息日志 |
| w() | 警告日志 |
| e() | 错误日志 |
| console() | 控制台日志 |
| getLogDir() | 获取日志目录 |
| readLatestLogs() | 读取当前活动日志 `latest.log` 的内容 |
| getLogDirectorySize() | 获取日志目录内所有 `.log` 文件总大小（字节） |
| clearLogDirectoryLogs() | 清空日志目录所有 `.log` 文件并重建空的 `latest.log` |

#### 维护与清理示例

```dart
// 读取最新日志内容
final lines = await Log.readLatestLogs();

// 统计日志目录大小
final sizeBytes = await Log.getLogDirectorySize();

// 清空日志目录内所有日志文件，并重建 latest.log
final cleared = await Log.clearLogDirectoryLogs();
```

### LogConfig

参见上文“配置字段详解”表格。

### LogOutput

| 方法 | 描述 |
|------|------|
| output() | 输出日志 |

### OutputEvent

| 参数 | 类型 | 描述 |
|------|------|------|
| level | LogLevel | 日志级别 |
| message | String | 日志消息 |
| error | dynamic | 错误信息 |
| stackTrace | StackTrace? | 堆栈跟踪 |
| tag | String? | 日志标签 |
| extra | Map? | 额外信息 |
| time | DateTime | 日志时间 |

## 📝 日志格式

### 控制台日志

```
┌────────────────────────────────────────────────────────────────────────────────────────
│ #0   Log.i (package:flutter_chen_common/log/logger.dart:112:46)
│ #1   main (package:example/main.dart:53:7)
├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
│ 💡 info message
└────────────────────────────────────────────────────────────────────────────────────────
┌────────────────────────────────────────────────────────────────────────────────────────
│ #0   Log.w (package:flutter_chen_common/log/logger.dart:113:46)
│ #1   main (package:example/main.dart:54:7)
├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
│ ⚠️ warning message
└────────────────────────────────────────────────────────────────────────────────────────
┌────────────────────────────────────────────────────────────────────────────────
│ #0   Log.e (package:flutter_chen_common/log/logger.dart:115:16)
│ #1   main (package:example/main.dart:55:7)
├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
│ ⛔ error message
└────────────────────────────────────────────────────────────────────────────────────────
┌────────────────────────────────────────────────────────────────────────────────────────
│ ✅ [HTTP] 2025-04-05 23:30:29 Request sent [Duration] 88ms
│ Request: 200 GET http://www.weather.com.cn/data/sk/101010100.html?xxxx=xxxx
│ Headers: {"token":"xxxxx","content-type":"application/json"}
│ Query: {"xxxx":"xxxx"}
│ Response: {"weatherinfo":{"city":"北京","cityid":"101010100","WD":"东南风"}}
└────────────────────────────────────────────────────────────────────────────────────────
```
