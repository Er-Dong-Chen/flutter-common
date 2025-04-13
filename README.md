# Flutter Chen Common
[![Pub Version](https://img.shields.io/pub/v/flutter_chen_common)](https://pub.dev/packages/flutter_chen_common)[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/yourname/yourrepo/blob/master/LICENSE)

## 🌟 简介

本库为Flutter应用开发提供一站式解决方案，包含：

- 可定制的主题系统
- 完整的国际化支持
- 企业级网络请求封装
- 企业级日志体系封装
- N+高质量常用组件
- 常用开发工具及扩展集合
- 刷新列表一整套解决方案
- 开箱即用的通用各类弹窗
- 全局统一各状态布局


## 特性

- 🎨 **主题系统**：通过 `ThemeExtension` 全局配置颜色/圆角/间距等样式
- 🌍 **国际化支持**：内置中英文，支持自定义文本和动态语言切换
- ⚡ **优先级覆盖**：支持全局配置 + 组件级参数覆盖
- 📱 **自适应设计**：完美适配 iOS/Material 设计规范
- 🔥 **企业级方案**：内置日志/网络/安全等通用模块，提供开箱即用的复杂场景解决方案


## 🚀 快速接入

### 安装依赖

在 `pubspec.yaml` 中添加依赖：

```yaml
/// 1.8.0版本已移除图片选择裁剪上传oss一站式解决方案
dependencies:
  flutter_chen_common: 最新版本
```

运行命令：
```bash
flutter pub get
```

### 初始化配置

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 存储初始化
  await SpUtil.init();
  // 日志初始化
  await Log.init(
    const LogConfig(
      retentionDays: 3,
      enableFileLog: true,
      logLevel: LogLevel.all,
      recordLevel: LogLevel.info,
      output: [CustomSentryOutput()],
    ),
  );
  // 网络模块初始化
  HttpClient.init(
    config: HttpConfig(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      commonHeaders: {"platform": Platform.isIOS ? 'ios' : 'android'},
      interceptors: [CustomInterceptor()]
      enableLog: true,
      enableToken: true,
      maxRetries: 3,
      getToken: () => "token",
      onRefreshToken: () async {
        return "new_token";
      },
      onRefreshTokenFailed: () async {
        Log.d("重新登录");
      },
   ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ComConfiguration(
      config: ComConfig.defaults().copyWith(
        emptyWidget: CustomEmptyWidget(), // 自定义全局空视图
        loadingWidget: CustomLoading(),  // 自定义全局加载视图
      ),
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: [ComTheme.light()], // 启用亮色主题
        ),
        darkTheme: ThemeData.dark().copyWith(
          extensions: [ComTheme.dark()], // 启用暗色主题
        ),
        home: MainPage(),
        localizationsDelegates: [
          ComLocalizations.delegate, // 国际化
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
// 网络请求使用
HttpClient.instance.request(
  "/xxxx",
  method: HttpType.post.name,
  fromJson: (json) => User.fromJson(json),
  showLoading: true,
)

// HttpConfig，内置日志打印、网络重试拦截器、token无感刷新以及相关操作
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
    this.getToken,
    this.onRefreshToken,
    this.onRefreshTokenFailed,
  });

// 打印样式如下（日志打印完全不会被截断，json格式化方便复制查看数据，在开启日志拦截以及记录日志时会将日志写入文件
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
// 统一调用示例
Log.d("debug message");
Log.i("info message");
Log.w("warning message");
Log.e("error message");
Log.console("console message 可完整打印不被截断并且无前缀");
final Directory dir = await Log.getLogDir(); // 获取日志文件目录

class LogConfig {
  final int retentionDays; // 日志保留天数
  final bool enableFileLog; // 是否启用日志写入
  final LogLevel logLevel;  // 日志过滤级别，低于该日志级别不打印
  final LogLevel recordLevel;   // 日志记录级别（Network日志级别分别是Info、Error），低于该日志级别不写入日志文件
  final List<LogOutput>? output;  // 可自定义扩展LogOutput，如Sentry上报、日志上传服务器、加密脱敏输出等（类似dio拦截器）

  const LogConfig({
    this.retentionDays = 3,
    this.enableFileLog = true,
    this.logLevel = LogLevel.all,
    this.recordLevel = LogLevel.info,
    this.output,
  });
}
```

## 🎨 主题系统

### 内置主题

| 主题名称      | 示例代码          |
| ----------- | ---------------- |
| Light Theme | `ComTheme.light` |
| Dark Theme  | `ComTheme.dark`  |

### 可配置属性

```dart
ComTheme(
  theme: ComColors.lightTheme,  // 颜色体系
  shapes: ComShapes.standard,	// 圆角体系
  spacing: ComSpacing.standard,	// 间距体系
  primaryGradient: LinearGradient(
    colors: [
      ComColors.lightTheme.shade500,
      ComColors.lightTheme.shade500,
    ],
  ),
  success: Colors.green.shade600,
  error: Colors.red.shade600,
  warning: Colors.orange.shade600,
  link: Colors.blue.shade600,
)

// 色系
static MaterialColor lightTheme = const MaterialColor(
  0xFF3783FD,
  <int, Color>{
    50: Color(0xfff8f6f9), // surface 背景色
    100: Color(0xfff8f2fa), // surfaceContainerLow 浅色背景色
    200: Color(0xfff2ecf4), // surfaceContainer 标准背景色
    300: Color(0xffece6ee), // surfaceContainerHigh 较深背景色
    400: Color(0xffe6e0e9), // surfaceContainerHighest 深色背景色
    500: Color(0xFF3783FD), // primary 主题色
    600: Color(0xff1d1b20), // onSurface 主要内容色
    700: Color(0xFF909399), // onSurfaceVariant 次要内容色
    800: Color(0xffffffff), // surfaceContainerLowest 相同色
    900: Color(0xff322f35), // inverseSurface 相反色
  },
);
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
    emptyWidget: const ComLoading(), // 定义全局空视图
    loadingWidget: const ComEmpty(),   // 定义全局加载视图
    errorWidget: const ComErrorWidget(), // 定义错误加载视图
    noNetworkWidget: (VoidCallback? onReconnect) =>
                    ComNoNetworkWidget(onReconnect: onReconnect), // // 定义全局网络错误视图
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
  loading,    // 加载中
  success,    // 加载成功
  empty,      // 数据为空
  error,      // 加载失败
  noNetwork,  // 无网络连接
}

// 全局统一使用
BaseWidget.loadingWidget(context)
BaseWidget.errorWidget(context)
...

```

## 📦 工具类（Utils）

| 文件名                 | 功能描述                                                                 |
|------------------------|--------------------------------------------------------------------------|
| `clipboard_util.dart`  | 剪贴板操作工具（复制/粘贴文本、监听剪贴板内容）                          |
| `clone_util.dart`      | 对象深拷贝/浅拷贝工具（支持复杂对象克隆）                                |
| `color_util.dart`      | 颜色处理工具（HEX与RGB互转、颜色混合、随机颜色生成）                     |
| `date_util.dart`       | 日期时间工具（格式化、解析、计算时间差）                                     |
| `device_util.dart`     | 设备信息工具（获取设备信息）                                               |
| `encrypt_util.dart`    | 加密解密工具（算法封装）                                                     |
| `file_util.dart`       | 文件操作工具（读写文件、目录管理、文件压缩/解压）                        |
| `function_util.dart`   | 通用函数工具（防抖/节流、空安全处理、类型转换）                          |
| `image_util.dart`      | 图片处理工具（压缩、缓存管理、网络图片加载、格式转换）                   |
| `json_util.dart`       | JSON工具（序列化/反序列化、动态解析、数据校验）                          |
| `keyboard_util.dart`   | 键盘工具（控制键盘显隐、监听高度变化）                                   |
| `log_util.dart`        | 日志工具（分级输出、日志存储、调试模式开关）                             |
| `package_util.dart`    | 应用包管理工具（获取应用包信息）                                     |
| `permission_util.dart` | 权限管理工具（全局权限处理、多权限判断及请求）                       |
| `sp_util.dart`         | 本地存储工具（基于SharedPreferences，支持复杂数据存取）                  |
| `text_util.dart`       | 文本处理工具（字符串校验、截断、正则匹配）                                |
| `dialog_util.dart`     | 弹窗工具类（通用各类弹窗Toast、Android、iOS确定弹窗、弹窗、选择弹窗、底部弹窗等）                                |

---

## 🎨 通用组件（Widgets）

| 文件名                          | 功能描述                                                                 |
|---------------------------------|--------------------------------------------------------------------------|
| `refresh_widget.dart`           | 刷新列表组件（包含上拉加载、下拉刷新、回至顶部、页面数据状态视图（加载、空数据、列表、瀑布流）等功能）                               |
| `base_widget.dart`              | 基础组件基类（统一多状态管理，无网络自动切换该状态布局）                               |
| `com_album.dart`                | 相册组件（图片九宫格仿微信朋友圈显示）                                     |
| `com_arrow.dart`                | 方向箭头组件（支持上下左右箭头，常用于列表项导航）                          |
| `com_avatar.dart`               | 头像组件（圆形/方形、网络/本地/文字头像）                                |
| `com_button.dart`               | 按钮组件（主按钮、线性按钮、禁用状态、渐变色、自定义样式）                         |
| `com_checkbox.dart`             | 复选框组件（支持单选/多选、自定义图标）                                  |
| `com_checkbox_list_title.dart`  | 列表复选框组件（ListTitle形式下的复现框）                             |
| `com_empty.dart`                | 空状态组件（数据为空时展示占位图或提示文字）                             |
| `com_gallery.dart`              | 图片画廊组件（图片查看预览等操作）                             |
| `com_image.dart`                | 增强图片组件（占位图、加载失败兜底、缓存策略）                           |
| `com_list_group.dart`           | 分组列表组件（下划线分隔的列表项布局，自定义下划线）                          |
| `com_loading.dart`              | 加载组件（全局Loading，可自定义）                                 |
| `com_popup_menu.dart`           | 弹出菜单组件（自定义菜单项、位置调整）                         |
| `com_rating.dart`               | 评分组件（星级评分、支持半星、自定义图标）                               |
| `com_tag.dart`                  | 标签组件（多颜色/尺寸、圆角样式）                                |
| `com_title_bar.dart`            | 标题栏组件（左中右布局、标题居中、常用于底部弹窗标题）                           |
| `com_divider.dart`              | 下划线组件（CustomPainter实现的Divider,支持负数）                           |

---


## 智能列表解决方案（RefreshWidget）
```dart
class DemoLogic extends PagingController {
  @override
  Future<PagingResponse> loadData() async {
    dynamic result = {"current": 1, "total": 3, "records": []};
    await Future.delayed(2000.milliseconds, () {
      for (var i = 0; i < 20; ++i) {
        result["records"]?.add(i);
      }
    });

    return PagingResponse.fromMapJson(result);
  }
}

class DemoPage extends StatelessWidget {
  DemoPage({Key? key}) : super(key: key);

  final logic = Get.find<DemoLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DemoLogic>(
      builder: (controller) {
        return Scaffold(
            body: RefreshWidget(
              controller: logic,
              slivers: [
                RefreshListWidget(
                    itemBuilder: (item, index) => _buildItem(index),
                    controller: logic,
                    showList: false),
              ],
            ));
      },
      id: logic.pagingState.refreshId,
    );
  }

  Widget _buildItem(index) {
    if (index % 3 == 0) {
      return Container(
        color: Colors.deepOrange,
        width: double.infinity,
        height: 300.h,
      );
    }
    return Container(
      color: Colors.green,
      width: double.infinity,
      height: 200.h,
    );
  }
}
```

## 示例项目

查看完整示例：

```bash
git clone https://github.com/Er-Dong-Chen/flutter-common.git
cd flutter-common/example
flutter run
```

## 🤝贡献指南
我们欢迎以下类型的贡献：

🐛 Bug 报告

💡 功能建议

📚 文档改进

🎨 设计资源

💻 代码提交

欢迎提交 PR 或 Issue！贡献前请阅读：

- [代码规范](docs/CODESTYLE.md)
- [全局主题指南](docs/I18N_GUIDE.md)
- [国际化指南](docs/THEME_GUIDE.md)
- [测试要求](docs/TESTING.md)

## 许可证

MIT License - 详情见 [LICENSE](LICENSE) 文件
