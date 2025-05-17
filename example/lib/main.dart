import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:example/network/network_interceptor.dart';
import 'package:example/pages/component/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:get/get.dart';
import 'package:module_base/module_base.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.init();
  await Log.init(
    const LogConfig(
      retentionDays: 3,
      enableFileLog: true,
      logLevel: LogLevel.all,
      recordLevel: LogLevel.info,
      output: [],
    ),
  );
  HttpClient.init(
    config: HttpConfig(
      baseUrl: Env.config.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      commonHeaders: {"language": Get.deviceLocale?.languageCode},
      interceptors: [NetworkInterceptor()],
      enableLog: true,
      enableToken: true,
      enableRetry: true,
      maxRetries: 3,
      retriesDelay: const Duration(seconds: 1),
      getToken: () => SpUtil.getString("token"),
      onRefreshToken: () async {
        return "new_token";
      },
      onRefreshTokenFailed: () async {
        Log.d("重新登录");
      },
    ),
  );
  ComContext.init(navigatorKey);
  Log.d("debug message");
  Log.i("info message");
  Log.w("warning message");
  Log.e("error message");
  Log.console("console message 可完整打印不被截断并且无前缀");
  final Directory dir = await Log.getLogDir(); // 获取日志文件目录

  HttpClient.instance.request("https://gutendex.com/books",
      data: {"xx": "xx"}, options: Options(extra: {'custom': true}));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ComConfiguration(
      config: ComConfig.defaults(),
      child: GetMaterialApp(
        navigatorKey: navigatorKey,
        home: ComponentListPage(),
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: AppThemeMode.getLocalThemeModel(),
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
      ),
    );
  }
}
