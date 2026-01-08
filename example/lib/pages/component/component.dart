import 'package:example/pages/component/list/list_page.dart';
import 'package:example/pages/component/marquee/marquee_page.dart';
import 'package:example/pages/component/popup_menu/popup_page.dart';
import 'package:example/pages/component/status/status_page.dart';
import 'package:example/pages/component/toast/toast_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:module_base/widgets/base/com_arrow.dart';

class ComponentListPage extends StatelessWidget {
  ComponentListPage({super.key});

  final List<Map<String, dynamic>> _sections = [
    // {
    //   'title': '基础组件',
    //   'items': [
    //     {
    //       'title': 'Basic Components',
    //       'subtitle': '箭头、容器、分割线等基础组件',
    //       'page': () => const BasicComponentsPage()
    //     },
    //     {
    //       'title': 'Button',
    //       'subtitle': '按钮组件演示',
    //       'page': () => const ButtonPage()
    //     },
    //     {
    //       'title': 'Image',
    //       'subtitle': '图片组件演示',
    //       'page': () => const ImagePage()
    //     },
    //   ],
    // },
    {
      'title': '布局组件',
      'items': [
        // {'title': 'Sliver Header', 'subtitle': '固定和浮动标题栏', 'page': () => const SliverPage()},
        {
          'title': 'Refresh List',
          'subtitle': '下拉刷新列表组件',
          'page': () => const ListPage()
        },
        {
          'title': 'Layout Status',
          'subtitle': '页面状态布局',
          'page': () => StatusPage()
        },
      ],
    },
    {
      'title': '交互组件',
      'items': [
        {
          'title': 'PopupMenu',
          'subtitle': '弹出菜单组件',
          'page': () => const PopupMenuPage()
        },
        {
          'title': 'Toast',
          'subtitle': '消息提示组件',
          'page': () => const ToastPage()
        },
      ],
    },
    {
      'title': '动画组件',
      'items': [
        {
          'title': 'Marquee',
          'subtitle': '跑马灯滚动组件',
          'page': () => const MarqueePage()
        },
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
                      subtitle: item['subtitle'] != null
                          ? Text(item['subtitle'])
                          : null,
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
