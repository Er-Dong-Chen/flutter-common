import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'locale_controller.dart';

void main() {
  HttpClient.init(
    config: HttpConfig(
      baseUrl: '',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      enableLog: true,
      maxRetries: 3,
    ),
  );
  final adapter = DioAdapter(dio: HttpClient.instance.dio);
  adapter.onPost(
    '/login',
    (request) => request.reply(200, {
      "id": "1",
      "name": "张三",
      "email": "zhangsan@example.com",
      "profilePictureUrl": "https://example.com/images/zhangsan.jpg"
    }),
    data: {},
  );
  Get.put(LocaleController());
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
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.blue,
        ),
        locale: Get.find<LocaleController>().currentLocale,
        localizationsDelegates: [
          ComLocalizations.delegate,
          RefreshLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('zh', 'CN'),
          Locale('en', 'US'),
        ],
        home: DemoPage(),
      ),
    );
  }
}

class DemoLogic extends PagingController {
  final localeController = Get.find<LocaleController>();
  @override
  Future<void> onInit() async {
    // TODO: implement onReady
    super.onInit();
  }

  @override
  Future<PagingResponse> loadData() async {
    // 切换中英文
    final newLocale = localeController.currentLocale.languageCode == 'zh'
        ? Locale('en', 'US')
        : Locale('zh', 'CN');
    localeController.switchLocale(newLocale);

    // DialogUtil.showAlertDialog();

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
