import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';

class PopupMenuPage extends StatefulWidget {
  const PopupMenuPage({super.key});

  @override
  State<PopupMenuPage> createState() => _PopupMenuPageState();
}

class _PopupMenuPageState extends State<PopupMenuPage> {
  final ComPopupMenuController _controller = ComPopupMenuController();
  final ComPopupMenuController _customController = ComPopupMenuController();
  String _selectedAction = '暂无操作';
  bool _enableArrow = true;
  PreferredPosition? _preferredPosition;
  Color _menuBackgroundColor = Colors.white;
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ComBack(),
        title: const Text('PopupMenu'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isDarkTheme = !_isDarkTheme;
                _menuBackgroundColor =
                    _isDarkTheme ? Colors.grey[800]! : Colors.white;
              });
            },
            icon: Icon(_isDarkTheme ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      backgroundColor: _isDarkTheme ? Colors.grey[900] : Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 状态展示区域
            _buildStatusCard(),

            const SizedBox(height: 24),

            // 设置区域
            _buildSettingsCard(),

            const SizedBox(height: 24),

            // 示例区域
            _buildExamplesCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      color: _isDarkTheme ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 当前状态',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isDarkTheme ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '最后操作: $_selectedAction',
                      style: TextStyle(
                        color: _isDarkTheme ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      color: _isDarkTheme ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '⚙️ 配置选项',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isDarkTheme ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // 箭头开关
            SwitchListTile(
              title: Text(
                '显示箭头',
                style: TextStyle(
                    color: _isDarkTheme ? Colors.white : Colors.black87),
              ),
              subtitle: Text(
                '控制菜单是否显示指向箭头',
                style: TextStyle(
                    color: _isDarkTheme ? Colors.grey[400] : Colors.grey[600]),
              ),
              value: _enableArrow,
              onChanged: (bool value) {
                setState(() {
                  _enableArrow = value;
                });
              },
            ),

            const Divider(),

            // 位置选择
            Text(
              '首选位置',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: _isDarkTheme ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('自动'),
                  selected: _preferredPosition == null,
                  onSelected: (selected) {
                    setState(() {
                      _preferredPosition = null;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('顶部'),
                  selected: _preferredPosition == PreferredPosition.top,
                  onSelected: (selected) {
                    setState(() {
                      _preferredPosition = PreferredPosition.top;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('底部'),
                  selected: _preferredPosition == PreferredPosition.bottom,
                  onSelected: (selected) {
                    setState(() {
                      _preferredPosition = PreferredPosition.bottom;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamplesCard() {
    return Card(
      color: _isDarkTheme ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎯 示例展示',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isDarkTheme ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // 示例网格
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2.5,
              children: [
                // 基础菜单
                _buildExampleItem(
                  '基础菜单',
                  Icons.menu,
                  Colors.blue,
                  () => _buildBasicMenu(),
                ),

                // 图标菜单
                _buildExampleItem(
                  '图标菜单',
                  Icons.apps,
                  Colors.green,
                  () => _buildIconMenu(),
                ),

                // 长按触发
                _buildExampleItemLongPress(
                  '长按触发',
                  Icons.touch_app,
                  Colors.orange,
                  () => _buildBasicMenu(),
                ),

                // 自定义样式
                _buildExampleItem(
                  '自定义样式',
                  Icons.palette,
                  Colors.purple,
                  () => _buildStyledMenu(),
                ),

                // 无箭头菜单
                _buildExampleItem(
                  '无箭头菜单',
                  Icons.crop_free,
                  Colors.teal,
                  () => _buildNoArrowMenu(),
                  showArrow: false,
                ),

                // 控制器操作
                _buildControllerExample(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleItem(
    String title,
    IconData icon,
    Color color,
    Widget Function() menuBuilder, {
    bool showArrow = true,
  }) {
    return ComPopupMenu(
      pressType: PressType.singleClick,
      showArrow: _enableArrow && showArrow,
      arrowColor: _menuBackgroundColor,
      position: _preferredPosition,
      menuBuilder: menuBuilder(),
      menuOnChange: (show) {
        if (show) {
          setState(() {
            _selectedAction = '打开了$title';
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleItemLongPress(
    String title,
    IconData icon,
    Color color,
    Widget Function() menuBuilder,
  ) {
    return ComPopupMenu(
      pressType: PressType.longPress,
      showArrow: _enableArrow,
      arrowColor: _menuBackgroundColor,
      position: _preferredPosition,
      menuBuilder: menuBuilder(),
      menuOnChange: (show) {
        if (show) {
          setState(() {
            _selectedAction = '长按打开了$title';
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControllerExample() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ComPopupMenu(
            controller: _customController,
            showArrow: _enableArrow,
            arrowColor: _menuBackgroundColor,
            position: _preferredPosition,
            menuBuilder: _buildControllerMenu(),
            menuOnChange: (show) {
              if (show) {
                setState(() {
                  _selectedAction = '控制器菜单已打开';
                });
              }
            },
            child: Icon(Icons.smart_button, color: Colors.red, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            '控制器操作',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicMenu() {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: _menuBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: 180,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(Icons.home, '首页', action: '点击了首页'),
          _buildDivider(),
          _buildMenuItem(Icons.settings, '设置', action: '点击了设置'),
          _buildDivider(),
          _buildMenuItem(Icons.person, '个人中心', action: '点击了个人中心'),
          _buildDivider(),
          _buildMenuItem(Icons.exit_to_app, '退出',
              color: Colors.red, action: '点击了退出'),
        ],
      ),
    );
  }

  Widget _buildIconMenu() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _menuBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
        children: [
          _buildIconMenuItem(Icons.star, '收藏', Colors.amber),
          _buildIconMenuItem(Icons.share, '分享', Colors.blue),
          _buildIconMenuItem(Icons.download, '下载', Colors.green),
          _buildIconMenuItem(Icons.edit, '编辑', Colors.orange),
          _buildIconMenuItem(Icons.delete, '删除', Colors.red),
          _buildIconMenuItem(Icons.more_horiz, '更多', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStyledMenu() {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 8,
      color: Colors.deepPurple[50],
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🎨 自定义菜单',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[700],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple[300]!, Colors.purple[300]!],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(height: 12),
            _buildStyledMenuItem(Icons.star, '收藏此页面', Colors.amber[600]!),
            const SizedBox(height: 8),
            _buildStyledMenuItem(Icons.share, '分享给朋友', Colors.blue[600]!),
            const SizedBox(height: 8),
            _buildStyledMenuItem(Icons.report, '举报内容', Colors.red[600]!),
          ],
        ),
      ),
    );
  }

  Widget _buildNoArrowMenu() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal[200]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, color: Colors.teal[600], size: 24),
          const SizedBox(height: 8),
          Text(
            '这是一个没有箭头的菜单\n适合需要简洁外观的场景',
            style: TextStyle(
              color: Colors.teal[700],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildControllerMenu() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _menuBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: 150,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '控制器操作',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _isDarkTheme ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              _customController.hideMenu();
              setState(() {
                _selectedAction = '通过控制器关闭菜单';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 32),
            ),
            child: const Text('关闭菜单', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(height: 4),
          ElevatedButton(
            onPressed: () {
              _customController.toggleMenu();
              setState(() {
                _selectedAction = '通过控制器切换菜单状态';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 32),
            ),
            child: const Text('切换状态', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text,
      {Color? color, required String action}) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedAction = action;
        });
        // 关闭菜单的逻辑由组件内部处理
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon,
                color: color ?? (_isDarkTheme ? Colors.white : Colors.black87),
                size: 20),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: color ?? (_isDarkTheme ? Colors.white : Colors.black87),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconMenuItem(IconData icon, String tooltip, Color color) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedAction = '点击了$tooltip';
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 2),
            Text(
              tooltip,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledMenuItem(IconData icon, String text, Color color) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedAction = '点击了$text';
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color.withOpacity(0.1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: (_isDarkTheme ? Colors.grey[600] : Colors.grey[200])
          ?.withOpacity(0.5),
    );
  }
}
