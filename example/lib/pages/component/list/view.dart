import 'package:flutter/material.dart';
import 'package:flutter_chen_common/widgets/widgets.dart';
import 'package:get/get.dart';

import 'logic.dart';

class ListPage extends StatelessWidget {
  ListPage({super.key});

  final logic = Get.put(ListLogic());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListLogic>(
      builder: (controller) {
        return Scaffold(
            appBar: AppBar(
              leading: ComBack(),
              title: const Text("Refresh List"),
            ),
            body: RefreshWidget(
              controller: logic,
              slivers: [
                RefreshListWidget(
                  itemBuilder: (item, index) => _buildItem(index),
                  controller: logic,
                  showList: false,
                ),
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
