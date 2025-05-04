// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:module_base/theme/theme.dart';
//
// import 'button/view.dart';
//
// class ComponentListPage extends StatelessWidget {
//   ComponentListPage({super.key});
//
//   final List<Map<String, dynamic>> _sections = [
//     {
//       'title': '基础组件',
//       'items': [
//         {'title': '按钮组件', 'page': () => ButtonPage()},
//         {'title': '图片组件', 'page': () => ImagePage()},
//         {'title': '加载组件', 'page': () => LoadingPage()},
//       ],
//     },
//     {
//       'title': '刷新组件',
//       'items': [
//         {'title': '刷新组件', 'page': () => RefreshPage()},
//       ],
//     },
//     {
//       'title': '扩展方法',
//       'items': [
//         {'title': '字符串扩展', 'page': () => StringExtensionPage()},
//         {'title': '日期扩展', 'page': () => DateExtensionPage()},
//         {'title': '数字扩展', 'page': () => NumberExtensionPage()},
//         {'title': '列表扩展', 'page': () => ListExtensionPage()},
//         {'title': 'Map扩展', 'page': () => MapExtensionPage()},
//       ],
//     },
//     {
//       'title': '工具类',
//       'items': [
//         {'title': '设备工具类', 'page': () => DeviceUtilsPage()},
//         {'title': '存储工具类', 'page': () => StorageUtilsPage()},
//         {'title': '网络工具类', 'page': () => NetworkUtilsPage()},
//         {'title': '其他工具类', 'page': () => OtherUtilsPage()},
//       ],
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('组件示例'),
//       ),
//       body: ListView.builder(
//         itemCount: _sections.length,
//         itemBuilder: (context, sectionIndex) {
//           final section = _sections[sectionIndex];
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(AppTheme.comTheme.spacing.medium),
//                 child: Text(
//                   section['title'],
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//               ),
//               ...List.generate(
//                 section['items'].length,
//                     (itemIndex) {
//                   final item = section['items'][itemIndex];
//                   return ListTile(
//                     title: Text(item['title']),
//                     trailing: const Icon(Icons.chevron_right),
//                     onTap: () => Get.to(item['page']),
//                   );
//                 },
//               ),
//               if (sectionIndex < _sections.length - 1)
//                 Divider(height: AppTheme.comTheme.spacing.medium),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
