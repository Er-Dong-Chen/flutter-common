import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:example/network/network_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:get/get.dart';
import 'package:module_base/module_base.dart';

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
        // home: ComponentListPage(),
        home: DemoPage(),
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

class DemoLogic extends PagingController {
  @override
  Future<void> onInit() async {
    // TODO: implement onReady
    super.onInit();
  }

  @override
  Future<PagingResponse> loadData() async {
    Log.d("debug message");
    Log.i("info message");
    Log.w("warning message");
    Log.e("error message");
    Log.console("console message 可完整打印不被截断并且无前缀");
    final Directory dir = await Log.getLogDir(); // 获取日志文件目录

    final res = await HttpClient.instance
        .request("https://gutendex.com/books", data: {"xx": "xx"});

    // TODO: implement loadData
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
  DemoPage({super.key});

  final logic = Get.put(DemoLogic());

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
                showList: false,
              ),
            ],
          ),
        );
      },
      id: logic.pagingState.refreshId,
    );
  }

  Widget _buildItem(index) {
    if (index % 3 == 0) {
      return Container(
        color: Colors.deepOrange,
        width: double.infinity,
        height: 300,
      );
    }
    return Container(
      color: Colors.green,
      width: double.infinity,
      height: 200,
    );
  }
}
