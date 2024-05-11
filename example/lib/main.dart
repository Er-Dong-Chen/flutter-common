import 'package:flutter/material.dart';
import 'package:flutter_chen_common/widgets/refresh/refresh_controller.dart';
import 'package:flutter_chen_common/widgets/refresh/refresh_state.dart';
import 'package:flutter_chen_common/widgets/refresh/refresh_widget.dart';
import 'package:get/get.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: DemoPage(),
    );
  }
}

class DemoLogic extends PagingController {
  @override
  Future<PagingResponse> loadData() async {
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
