# Flutter Chen Common

[![Pub Version](https://img.shields.io/pub/v/flutter_chen_common)](https://pub.dev/packages/flutter_chen_common)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/yourname/yourrepo/blob/master/LICENSE)

## Overview

[English](README.md) | [中文](README_zh.md)


Flutter Chen Common is a feature-rich Flutter utility library that provides a one-stop solution for app development.

- Customizable theme system
- Enterprise-grade networking
- Enterprise-grade logging
- High-quality common widgets
- Handy utilities and extensions
- Smart refresh list solution
- Ready-to-use common popups
- Unified multi-state layout
- Context-free global Toast

## Features

- 🎨 Theme system: configure colors, corners, spacing via `ThemeExtension`
- 🌍 Internationalization: recommend official Flutter localization (built-in module deprecated)
- ⚡ Priority overrides: global configuration + per-component overrides
- 📱 Adaptive design: perfect fit for iOS/Material guidelines
- 🔥 Enterprise-grade modules: logging/networking/security out of the box

## Documentation

### Core
- [Networking](https://juejin.cn/post/7492312857905315849) – Structured logs, retries, token refresh
- [Logging](https://juejin.cn/post/7492398520583192585) – File logging, filters, custom outputs
- [Network Debug](https://juejin.cn/post/7593702885881348132) - The network request debugging module provides lightweight packet capture functionality, visual logs, and more.
- [Theme](docs/theme.md) – Customizable theme with light/dark support

### UI Components
- [Smart Refresh](https://juejin.cn/post/7516846036586594355) – Refresh list solution
- [Toast](https://juejin.cn/post/7512644310631940122) – Global Toast without BuildContext
- [Marquee](https://juejin.cn/post/7516846036586512435) – Any widget marquee
- [PopupMenu](https://juejin.cn/post/7520165877800222746?searchId=2026010823332660A8A22819C79196B6CF) – Beautiful popup menus

### [Online Demo](https://er-dong-chen.github.io/flutter_chen_common/)

## Quick Start

### Install

Add dependency in `pubspec.yaml`:

```yaml
dependencies:
  flutter_chen_common: latest version
```

Run:

```bash
flutter pub get
```
### Initialization

```dart
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // shared_preferences
  await SpUtil.init();
  // Logging
  Directory dir = await getApplicationDocumentsDirectory();
  await Log.init(
    LogConfig(
      retentionDays: 3,
      enableFileLog: true,
      logLevel: LogLevel.all,
      recordLevel: LogLevel.info,
      output: const [],
      printer: PrettyPrinter(dateTimeFormat: DateTimeFormat.dateAndTime),
      logDirectory: kIsWeb ? null : Directory('${dir.path}/logs'),
    ),
  );
  // Networking
  HttpClient.init(
    config: HttpConfig(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      commonHeaders: () => {"Authorization": SpUtil.getString('token')},
      interceptors: [CustomInterceptor()]
      enableLog: true,
      enableToken: true,
      maxRetries: 3,
      getToken: () => "token",
      onRefreshToken: () async {
        return "new_token";
      },
      onRefreshTokenFailed: () async {
        Log.d("Log in again");
      },
   ),
  );
  // Global context for overlays
  ComContext.init(navigatorKey);
  // Global Toast config (optional)
  ComToast.init(
    config: const ComToastConfig(
      duration: Duration(seconds: 2),
      position: ComToastPosition.center,
    ),
    builder: ComToastWidgetBuilder(
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

  await ComDebugManager.instance.init(
    dio: HttpClient.instance.dio,
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
    ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ComConfiguration(
      config: ComConfig.defaults().copyWith(
        emptyWidget: CustomEmptyWidget(), // example
        loadingWidget: CustomLoading(),   // example
      ),
      child: MaterialApp(
		    navigatorKey: navigatorKey,
        builder: (context, child) {
          ComNetworkLogger.show(context);
          child = ComToastBuilder()(context, child);
          return child;
        },
        navigatorObservers: [ComToastNavigatorObserver()],
        theme: ThemeData.light().copyWith(
          extensions: [ComTheme.light()],
        ),
        darkTheme: ThemeData.dark().copyWith(
          extensions: [ComTheme.dark()],
        ),
        home: MainPage(),
        localizationsDelegates: const [ // official localization
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('zh', 'CN'),
          Locale('en', 'US'),
        ],
      ),
    );
  }
}
```
### 🌐 Networking

```dart
HttpClient.instance.request(
  "/api",
  method: HttpMethod.post,
  fromJson: (json) => User.fromJson(json),
  showLoading: true,
)
HttpClient.instance.get("/api");
HttpClient.instance.post("/api");
HttpClient.instance.put("/api");
HttpClient.instance.patch("/api");
HttpClient.instance.delete("/api");
HttpClient.instance.uploadFile("/api","filePath");
HttpClient.instance.downloadFile("/api", "savePath");

// HttpConfig key fields:
// baseUrl, connectTimeout, receiveTimeout, sendTimeout,
// commonHeaders(): Map<String, dynamic>,
// interceptors: List<Interceptor>,
// enableLog, enableToken, enableRetry,
// maxRetries, retriesDelay,
// getToken(), onRefreshToken(), onRefreshTokenFailed()

// Sample log output
┌─────────────────────────────────────────────────────────────────────────────
│ ✅ [HTTP] 2025-04-05 23:30:29 Request sent [Duration] 88ms
│ Request: 200 GET http://www.weather.com.cn/data/sk/101010100.html?xxxx=xxxx
│ Headers: {"token":"xxxxx","content-type":"application/json"}
│ Query: {"xxxx":"xxxx"}
│ Response: {"weatherinfo":{"city":"北京","cityid":"101010100","WD":"东南风"}}
└──────────────────────────────────────────────────────────────────────────────
```

### 📝 Logging

```dart
Log.d("debug message");
Log.i("info message");
Log.w("warning message");
Log.e("error message");
Log.console("console message printed fully without prefix");
final Directory dir = await Log.getLogDir();

class LogConfig {
  final int retentionDays;
  final bool enableFileLog;
  final LogLevel logLevel;
  final LogLevel recordLevel;
  final List<LogOutput>? output;
  final Directory? logDirectory;

  const LogConfig({
    this.retentionDays = 3,
    this.enableFileLog = true,
    this.logLevel = LogLevel.all,
    this.recordLevel = LogLevel.info,
    this.output,
		this.logDirectory,
  });
}

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

Log.init(LogConfig(
  output: [SentryOutput()]
));
```

## Utils

| File                    | Description          |
| ----------------------- | -------------------- |
| `clipboard_util.dart`   | Clipboard            |
| `file_util.dart`        | File operations      |
| `keyboard_util.dart`    | Keyboard helpers     |
| `platform_util.dart`    | Platform detection   |
| `platform_util_web.dart`| Web platform helpers |
| `sp_util.dart`          | Local storage        |
| `utils.dart`            | Utils entry          |

---

## Widgets

### Basic

| File               | Description     |
| ------------------ | --------------- |
| `base_widget.dart` | Base (multi-state) |
| `com_loading.dart` | Loading widget  |

### Functional

| File                 | Description              |
| -------------------- | ------------------------ |
| `com_marquee.dart`   | Marquee                  |
| `com_popup_menu.dart`| Popup menu               |

### Refresh

| File                    | Description        |
| ----------------------- | ------------------ |
| `back_top_widget.dart`  | Back to top        |
| `refresh_controller.dart`| Refresh controller |
| `refresh_interface.dart` | Refresh interface  |
| `refresh_state.dart`     | Refresh state      |
| `refresh_strategy.dart`  | Refresh strategy   |
| `refresh_widget.dart`    | Smart refresh      |

---

## Theme

### Built-in

| Name        | Example           |
| ----------- | ----------------- |
| Light Theme | `ComTheme.light`  |
| Dark Theme  | `ComTheme.dark`   |

### Configurable

```dart
ComTheme(
  shapes: ComShapes.standard,
  spacing: ComSpacing.standard,
  success: Colors.green.shade600,
  error: Colors.red.shade600,
  warning: Colors.orange.shade600,
  link: Colors.blue.shade600,
)
```

## Internationalization
Built-in i18n module is deprecated. Use Flutter official `flutter_localizations` + `intl`.

## Global State Layout

```dart
// Global or local configuration
ComConfiguration(
  config: ComConfig.defaults().copyWith(
    emptyWidget: const ComLoading(), // example only
    loadingWidget: const ComEmpty(), // example only
    errorWidget: const ComErrorWidget(), // example only
    noNetworkWidget: (VoidCallback? onReconnect) => ComNoNetworkWidget(onReconnect: onReconnect), // example only
  ),
  child: child,
);

// BaseWidget states use global config by default; can be customized locally
BaseWidget(
  isConnected: isConnected,
  status: LayoutStatus.loading,
  loading: const ComLoading(),
  empty: const CustomEmpty(),
  error: BaseWidget.errorWidget(context),
  noNetwork: BaseWidget.noNetworkWidget(context),
  onReconnect: (){},
  child: child,
)

// State types
enum LayoutStatus {
  loading,
  success,
  empty,
  error,
  noNetwork,
}

// Global helpers
BaseWidget.loadingWidget(context)
BaseWidget.emptyWidget(context)
BaseWidget.errorWidget(context)
BaseWidget.noNetworkWidget(context)
...

```
 

## Contributing

We welcome all contributions:

- 🐛 Bug reports
- 💡 Feature ideas
- 📚 Docs improvements
- 🎨 Design assets
- 💻 Code contributions

## License

MIT License – see [LICENSE](LICENSE)
