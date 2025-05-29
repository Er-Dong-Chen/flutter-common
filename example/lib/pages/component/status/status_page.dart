import 'package:flutter/material.dart';
import 'package:flutter_chen_common/widgets/base/base_widget.dart';
import 'package:flutter_chen_common/widgets/base/com_arrow.dart';
import 'package:flutter_chen_common/widgets/base/com_container.dart';
import 'package:flutter_chen_common/widgets/base/com_popup_menu.dart';
import 'package:get/get.dart';
import 'package:module_base/theme/theme.dart';

import 'status_logic.dart';

class StatusPage extends StatelessWidget {
  StatusPage({super.key});

  final logic = Get.put(StatusLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ComBack(),
        title: const Text('Status'),
        actions: [
          ComPopupMenu(
            verticalMargin: 0,
            menuBuilder: ComContainer(
              width: 100,
              padding: const EdgeInsets.symmetric(vertical: 4),
              // padding: EdgeInsets.zero,
              radius: AppTheme.comTheme.shapes.smallRadius,
              child: Column(
                children: logic.statusArr
                    .map((e) => GestureDetector(
                          onTap: () => logic.changeStatus(e),
                          child: ComContainer(
                            padding: const EdgeInsets.all(4),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              '$e',
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            pressType: PressType.singleClick,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.comTheme.spacing.medium),
              child: const Text('切换状态'),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return BaseWidget(
          status: logic.status.value,
          child: Padding(
            padding: EdgeInsets.all(AppTheme.comTheme.spacing.medium),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '这是默认状态下布局内容',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: AppTheme.comTheme.spacing.small),
                  const Text('根据不同状态显示不同状态布局内容\n网络自动监听，无网络情况下优先状态'),
                  SizedBox(height: AppTheme.comTheme.spacing.extraSmall),
                  Text(
                    'Tips: RefreshList 自带所有状态',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
