import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpClient.init(
    config: HttpConfig(
      baseUrl: '',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      enableLog: true,
      maxRetries: 3,
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
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: const [
          ComLocalizations.delegate,
          RefreshLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('zh', 'CN'),
          Locale('en', 'US'),
        ],
        home: DemoPage(),
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
    await HttpClient.instance.request(
      "http://www.weather.com.cn/data/sk/101010100.html",
      options: Options(headers: {
        "token": "xxxxx",
        "xxxx": "xxxx",
      }),
      data: {
        "xxxx": "xxxx",
        "xxxxx": "xxxxx",
      },
      method: HttpMethod.get.name,
    );
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
