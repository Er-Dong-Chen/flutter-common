import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:module_base/module_base.dart';

class PopupMenuPage extends StatefulWidget {
  const PopupMenuPage({super.key});

  @override
  State<PopupMenuPage> createState() => _PopupMenuPageState();
}

class _PopupMenuPageState extends State<PopupMenuPage> {
  final ComPopupMenuController _controller = ComPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ComBack(),
        title: const Text('PopupMenu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 示例 1: 基础用法
            ComPopupMenu(
              pressType: PressType.singleClick,
              menuBuilder: _buildBasicMenu(),
              child: const Chip(label: Text('基础菜单')),
              menuOnChange: (show) => print('菜单状态: $show'),
            ),

            const SizedBox(height: 20),

            // 示例 2: 自定义样式
            ComPopupMenu(
              showArrow: true,
              arrowSize: 20,
              arrowColor: AppTheme.colorScheme.surface,
              horizontalMargin: 30,
              verticalMargin: 10,
              menuBuilder: _buildStyledMenu(),
              child: const Chip(label: Text('自定义样式')),
            ),

            const SizedBox(height: 20),

            // 示例 3: 长按触发
            ComPopupMenu(
              pressType: PressType.longPress,
              menuBuilder: _buildBasicMenu(),
              child: const Chip(label: Text('长按触发')),
            ),

            const SizedBox(height: 20),

            // 示例 4: 无箭头模式
            ComPopupMenu(
              showArrow: false,
              menuBuilder: _buildNoArrowMenu(),
              child: const Chip(label: Text('无箭头菜单')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicMenu() {
    return ComContainer(
      padding: EdgeInsets.zero,
      color: AppTheme.colorScheme.surfaceContainerLowest,
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(Icons.home, '首页'),
          _buildMenuItem(Icons.settings, '设置'),
          _buildMenuItem(Icons.exit_to_app, '退出'),
        ],
      ),
    );
  }

  Widget _buildStyledMenu() {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 8,
      color: AppTheme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text('自定义菜单'),
            const Divider(),
            _buildMenuItem(
              Icons.star,
              '收藏',
            ),
            _buildMenuItem(Icons.share, '分享'),
          ],
        ),
      ),
    );
  }

  Widget _buildLongPressMenu() {
    return ComContainer(
      width: 150,
      padding: EdgeInsets.zero,
      color: AppTheme.colorScheme.surfaceContainerLowest,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        children: List.generate(6, (index) => const Icon(Icons.ac_unit)),
      ),
    );
  }

  Widget _buildNoArrowMenu() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text('这是一个没有箭头的菜单'),
    );
  }

  Widget _buildMenuItem(IconData icon, String text, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('点击了 $text')),
        );
        _controller.hideMenu();
      },
    );
  }
}
