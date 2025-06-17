# 日志系统

## 🌟 特性

- 📝 支持多级别日志
- 💾 支持文件日志
- 🔄 支持日志轮转
- 🎯 支持日志过滤
- 🔧 支持自定义输出
- 📱 支持日志上报
- 🛡️ 支持日志加密
- ⚡ 支持性能监控

## 🔥 核心特性解析

### 四层日志架构

| 层级           | 技术实现         | 性能指标       |
| -------------- | ---------------- | -------------- |
| **内存缓冲层** | 环形缓冲区设计   | 百万级日志/秒  |
| **隔离处理层** | Dart Isolate     | 零主线程阻塞   |
| **持久化层**   | 按日期分文件存储 | 自动滚动归档   |
| **传输层**     | 加密压缩传输     | TLS1.3+ AES256 |

## 🚀 快速开始

### 初始化配置

```dart
// 获取应用文档目录
Directory dir = await getApplicationDocumentsDirectory();

// 初始化日志系统
await Log.init(
  LogConfig(
    retentionDays: 3,           // 日志保留天数
    enableFileLog: true,        // 启用文件日志
    logLevel: LogLevel.all,     // 日志过滤级别
    recordLevel: LogLevel.info, // 日志记录级别
    output: const [],           // 自定义输出
    logDirectory: Directory('${dir.path}/logs'), // 日志目录
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

### 日志加密

```dart
// 自定义加密输出
class EncryptedOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final encrypted = encrypt(event.message);
    // 处理加密后的日志
  }
}

// 配置使用
Log.init(LogConfig(
  output: [EncryptedOutput()]
));
```

### 性能监控

```dart
// 开始性能监控
final stopwatch = Stopwatch()..start();

// 执行操作
await someOperation();

// 记录性能日志
Log.i(
  "Operation completed",
  tag: "Performance",
  extra: {
    "duration": stopwatch.elapsedMilliseconds,
    "operation": "someOperation",
  },
);
```

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

### LogConfig

| 参数 | 类型 | 描述 |
|------|------|------|
| retentionDays | int | 日志保留天数 |
| enableFileLog | bool | 是否启用文件日志 |
| logLevel | LogLevel | 日志过滤级别 |
| recordLevel | LogLevel | 日志记录级别 |
| output | List | 自定义输出列表 |
| logDirectory | Directory | 日志目录 |

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

## 🔧 最佳实践

1. 合理使用日志级别
2. 避免敏感信息泄露
3. 定期清理日志文件
4. 使用标签分类日志
5. 添加上下文信息
6. 监控日志文件大小
7. 实现日志轮转
8. 配置日志上报 