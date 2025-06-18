import 'package:example/pages/component/image/image_page.dart';
import 'package:example/pages/component/list/list_page.dart';
import 'package:example/pages/component/marquee/marquee_page.dart';
import 'package:example/pages/component/popup_menu/popup_page.dart';
import 'package:example/pages/component/status/status_page.dart';
import 'package:example/pages/component/toast/toast_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:get/get.dart';

import 'button/button_page.dart';
import 'dialog/dialog_page.dart';

class ComponentListPage extends StatelessWidget {
  ComponentListPage({super.key});

  final List<Map<String, dynamic>> _sections = [
    {
      'title': '基础组件',
      'items': [
        {'title': 'Button', 'page': () => const ButtonPage()},
        {'title': 'Image', 'page': () => const ImagePage()},
      ],
    },
    {
      'title': '视图组件',
      'items': [
        {'title': 'Refresh List', 'page': () => const ListPage()},
        {'title': 'Layout Status', 'page': () => StatusPage()},
      ],
    },
    {
      'title': '反馈组件',
      'items': [
        {'title': 'PopupMenu', 'page': () => const PopupMenuPage()},
        {'title': 'Dialog', 'page': () => const DialogPage()},
        {'title': 'Toast', 'page': () => const ToastPage()},
      ],
    },
    {
      'title': '跑马灯组件',
      'items': [
        {'title': 'Marquee', 'page': () => const MarqueePage()},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('组件示例'),
      ),
      body: ListView.builder(
        itemCount: _sections.length,
        itemBuilder: (context, sectionIndex) {
          final section = _sections[sectionIndex];
          return Column(
            children: [
              CupertinoListSection.insetGrouped(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                header: Text(section['title']),
                children: [
                  ...List.generate(section['items'].length, (itemIndex) {
                    final item = section['items'][itemIndex];
                    return CupertinoListTile(
                      title: Text(item['title']),
                      trailing: const ComArrow(),
                      onTap: () => Get.to(item['page']),
                    );
                  }),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
