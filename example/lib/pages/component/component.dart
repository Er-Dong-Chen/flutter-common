import 'package:example/pages/component/image/view.dart';
import 'package:example/pages/component/list/view.dart';
import 'package:example/pages/component/status/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/widgets/base/com_arrow.dart';
import 'package:get/get.dart';

import 'button/view.dart';

class ComponentListPage extends StatelessWidget {
  ComponentListPage({super.key});

  final List<Map<String, dynamic>> _sections = [
    {
      'title': '基础组件',
      'items': [
        {'title': '按钮组件', 'page': () => ButtonPage()},
        {'title': '图片组件', 'page': () => ImagePage()},
      ],
    },
    {
      'title': '视图组件',
      'items': [
        {'title': '刷新组件', 'page': () => ListPage()},
        {'title': '状态组件', 'page': () => StatusPage()},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('组件示例'),
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
                      trailing: ComArrow(),
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
