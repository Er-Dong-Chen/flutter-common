# Flutter Chen Common

[![Pub Version](https://img.shields.io/pub/v/flutter_chen_common)](https://pub.dev/packages/flutter_chen_common)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/yourname/yourrepo/blob/master/LICENSE)

## 🌟 简介

Flutter Chen Common 是一个功能丰富的 Flutter 通用库，为应用开发提供一站式解决方案。

- 可定制的主题系统
- 完整的国际化支持
- 企业级网络请求封装
- 企业级日志体系封装
- N+高质量常用组件
- 常用开发工具及扩展集合
- 智能刷新列表解决方案
- 开箱即用的各类通用弹窗
- 全局统一各状态布局
- 全局无需Context的Toast

## 特性

- 🎨 **主题系统**：通过 `ThemeExtension` 全局配置颜色/圆角/间距等样式
- 🌍 **国际化支持**：内置中英文，支持自定义文本和动态语言切换
- ⚡ **优先级覆盖**：支持全局配置 + 组件级参数覆盖
- 📱 **自适应设计**：完美适配 iOS/Material 设计规范
- 🔥 **企业级方案**：内置日志/网络/安全等通用模块，提供开箱即用的复杂场景解决方案

## 📚 文档目录

### 核心功能
- [网络请求](docs/network.md) - 企业级网络请求封装，内置日志打印、网络重试、token刷新等拦截器
- [日志系统](docs/log.md) - 企业级日志体系，支持文件日志、日志过滤、自定义扩展等
- [主题系统](docs/theme.md) - 可定制的主题系统，支持亮暗主题切换
- [国际化](docs/localization.md) - 完整的国际化支持，内置中英文

### UI 组件
- [智能刷新](docs/refresh.md) - 智能刷新列表解决方案
- [Toast](docs/toast.md) - 全局无需Context的Toast提示
- [Marquee](docs/marquee.md) - 支持任意widget，满足所有场景的跑马灯
- [PopupMenu](docs/popup_menu.md) - 智能美观的PopupMenu菜单

### [Online Demo](https://er-dong-chen.github.io/flutter_chen_common/)

## 🚀 快速开始

### 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  flutter_chen_common: latest version
```

运行命令：

```bash
flutter pub get
```
### 初始化配置

```dart
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 存储初始化
  await SpUtil.init();
  // 日志初始化
  Directory dir = await getApplicationDocumentsDirectory();
  await Log.init(
    LogConfig(
      retentionDays: 3,
      enableFileLog: true,
      logLevel: LogLevel.all,
      recordLevel: LogLevel.info,
      output: const [],
      logDirectory: kIsWeb ? null : Directory('${dir.path}/logs'),
    ),
  );
  // 网络模块初始化
  HttpClient.init(
    config: HttpConfig(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      commonHeaders: {},
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
  // 全局context服务初始化
  ComContext.init(navigatorKey);
  // 全局Toast配置（可选）
  ComToast.init(
    config: ComToastConfig(
      duration: const Duration(seconds: 2),
      position: ComToastPosition.center,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ComConfiguration(
      config: ComConfig.defaults().copyWith(
        emptyWidget: CustomEmptyWidget(),
        loadingWidget: CustomLoading(),
      ),
      child: MaterialApp(
		    navigatorKey: navigatorKey,
        builder: ComToastBuilder(),
        navigatorObservers: [ComToastNavigatorObserver()],
        theme: ThemeData.light().copyWith(
          extensions: [ComTheme.light()],
        ),
        darkTheme: ThemeData.dark().copyWith(
          extensions: [ComTheme.dark()],
        ),
        home: MainPage(),
        localizationsDelegates: [
          ComLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CN'),
          const Locale('en', 'US'),
        ],
      ),
    );
  }
}
```
### 🌐 网络请求

```dart
HttpClient.instance.request(
  "/api",
  method: HttpType.post.name,
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

HttpConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.sendTimeout = const Duration(seconds: 15),
    this.commonHeaders = const {},
    this.interceptors = const [],
    this.enableLog = true,
    this.enableToken = true,
    this.maxRetries = 3,
    this.retriesDelay = const Duration(seconds: 1),
    this.getToken,
    this.onRefreshToken,
    this.onRefreshTokenFailed,
  });

// 打印样式如下
┌─────────────────────────────────────────────────────────────────────────────
│ ✅ [HTTP] 2025-04-05 23:30:29 Request sent [Duration] 88ms
│ Request: 200 GET http://www.weather.com.cn/data/sk/101010100.html?xxxx=xxxx
│ Headers: {"token":"xxxxx","content-type":"application/json"}
│ Query: {"xxxx":"xxxx"}
│ Response: {"weatherinfo":{"city":"北京","cityid":"101010100","WD":"东南风"}}
└──────────────────────────────────────────────────────────────────────────────
```

### 📝日志体系

```dart
Log.d("debug message");
Log.i("info message");
Log.w("warning message");
Log.e("error message");
Log.console("console message 可完整打印不被截断并且无前缀");
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


## 📦 工具类（Utils）

| 文件名                 | 功能描述                                                     |
| ---------------------- | ------------------------------------------------------------ |
| `clipboard_util.dart`  | 剪贴板操作工具                                  |
| `clone_util.dart`      | 对象克隆工具                                         |
| `color_util.dart`      | 颜色处理工具
| `date_util.dart`       | 日期时间工具
| `encrypt_util.dart`    | 加密解密工具（已移入module_base）                                     |
| `file_util.dart`       | 文件操作工具          |
| `function_util.dart`   | 防抖/节流函数工具              |
| `image_util.dart`      | 图片处理工具           |
| `json_util.dart`       | JSON工具               |
| `keyboard_util.dart`   | 键盘工具                       |
| `permission_util.dart` | 权限管理工具（已移入module_base） |
| `sp_util.dart`         | 本地存储工具             |
| `text_util.dart`       | 文本处理工具                  |
| `dialog_util.dart`     | 弹窗工具类（通用各类弹窗Toast、Android、iOS确定弹窗、弹窗、选择弹窗、底部弹窗等） |

---

## 🎨 通用组件（Widgets）

| 文件名                         | 功能描述                                                     |
| ------------------------------ | ------------------------------------------------------------ |
| `base_widget.dart`             | 基础组件基类（统一多状态管理，无网络自动切换该状态布局）     |
| `com_album.dart`               | 图片九宫格组件（已移入到module_base）                        |
| `com_arrow.dart`               | 方向箭头组件（支持上下左右箭头，常用于列表项导航）           |
| `com_avatar.dart`              | 头像组件（已移入到module_base中）                            |
| `com_button.dart`              | 按钮组件（主按钮、线性按钮、禁用状态、渐变色、自定义样式）   |
| `com_checkbox.dart`            | 复选框组件（支持radio效果）                                  |
| `com_checkbox_list_title.dart` | 列表复选框组件（支持radio效果）                              |
| `com_empty.dart`               | 空状态组件（数据为空时展示占位图或提示文字）                 |
| `com_image.dart`               | 图片组件（占位图、加载失败兜底）（已移入module_base）        |
| `com_list_group.dart`          | 分组列表组件（下划线分隔的列表项布局，自定义下划线）         |
| `com_loading.dart`             | 加载组件（全局Loading，可自定义）                            |
| `com_popup_menu.dart`          | 弹出菜单组件（自定义菜单项、位置调整）                       |
| `com_rating.dart`              | 评分组件（星级评分、支持半星、自定义图标）                   |
| `com_tag.dart`                 | 标签组件（多颜色/尺寸、圆角样式）                            |
| `com_title_bar.dart`           | 标题栏组件（左中右布局、标题居中、常用于底部弹窗标题）       |
| `com_divider.dart`             | 下划线组件（CustomPainter实现的Divider,支持负数）            |
| `com_sliver_header.dart`       | SliverPinnedHeader固定Header组件                             |

---

## 🎨 主题系统

### 内置主题

| 主题名称    | 示例代码         |
| ----------- | ---------------- |
| Light Theme | `ComTheme.light` |
| Dark Theme  | `ComTheme.dark`  |

### 可配置属性

```dart
ComTheme(
  // theme: ComColors.lightTheme,  // 颜色体系(已删除使用ColorScheme中颜色)
  // primaryGradient: LinearGradient( //
  //   colors: [
  //     ComColors.lightTheme.shade500,
  //     ComColors.lightTheme.shade600,
  //   ],
  // ),
  shapes: ComShapes.standard,
  spacing: ComSpacing.standard,
  success: Colors.green.shade600,
  error: Colors.red.shade600,
  warning: Colors.orange.shade600,
  link: Colors.blue.shade600,
)
```

## 🌍 国际化配置

```dart
// 语言新增或覆盖
// 1. 创建法语本地化类
class FrIntl extends ComIntl {
  @override String get confirm => "xxx";
  @override String get cancel => "xxx";
  @override String get loading => "...";
}

// 2. 注册语言
ComLocalizations.addLocalization('fr', FrIntl());

// 3. 配置MaterialApp
MaterialApp(
  supportedLocales: [
    Locale('fr'), // 新增法语支持
  ],
)
```

## 全局状态布局

```dart
// 全局配置或局部配置
ComConfiguration(
  config: ComConfig.defaults().copyWith(
    emptyWidget: const ComLoading(),
    loadingWidget: const ComEmpty(),
    errorWidget: const ComErrorWidget(),
    noNetworkWidget: (VoidCallback? onReconnect) =>
                    ComNoNetworkWidget(onReconnect: onReconnect),
  ),
  child: child,
);

// BaseWidget的各状态布局默认使用全局统一配置，局部可自定义
// isConnected配合connectivity_plus库自动实现无网络情况显示无网络状态布局，网络正常情况显示正常布局
// status控制页面各状态内容布局显示
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

// 状态类型说明
enum LayoutStatus {
  loading,
  success,
  empty,
  error,
  noNetwork,
}

// 全局统一使用
BaseWidget.loadingWidget(context)
BaseWidget.emptyWidget(context)
BaseWidget.errorWidget(context)
BaseWidget.noNetworkWidget(context)
...

// 使用默认库中状态组件项目需要包含以下图片资源才能正常加载显示
assets/images/empty.png
assets/images/error.png
assets/images/no_network.png

```

## 全局日期时间

```dart
// default_formatter默认实现中英文，使用示例
Log.d(DateUtil.formatDate(DateTime.now()));
Log.d(DateUtil.formatDateMs(DateTime.now().millisecondsSinceEpoch,
    format: "yyyy/MM/dd"));
Log.d(DateUtil.getTimeAgoByMs(DateTime.now().millisecondsSinceEpoch));
Log.d(DateUtil.getTimeAgoForChatByMs(DateTime.now().millisecondsSinceEpoch));

// 自定义Formatter
class IntlDateFormatter implements DateFormatterDelegate {
  @override
  String format(DateTime? dateTime, {String? pattern, Locale? locale}) {
    if (dateTime == null) return '';
    return DateFormat(pattern, locale?.languageCode).format(dateTime);
  }
  // 其他方法实现...
}

// 初始化时注入
void main() {
  DateTimeFormatter.setDelegate(IntlDateFormatter());
  runApp(MyApp());
}
```

🤝 贡献指南

我们欢迎各种形式的贡献，包括但不限于：

- 🐛 Bug 报告
- 💡 功能建议
- 📚 文档改进
- 🎨 设计资源
- 💻 代码提交

## 📄 许可证

MIT License - 详情见 [LICENSE](LICENSE) 文件