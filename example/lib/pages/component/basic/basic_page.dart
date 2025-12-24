import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';

class BasicComponentsPage extends StatefulWidget {
  const BasicComponentsPage({super.key});

  @override
  State<BasicComponentsPage> createState() => _BasicComponentsPageState();
}

class _BasicComponentsPageState extends State<BasicComponentsPage> {
  bool _isChecked = false;
  bool? _triStateChecked = false;
  final double _rating = 3.5;
  final _controller = MarqueeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('基础组件'),
        leading: const ComBack(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildArrowSection(),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          _buildDividerSection(),
          const SizedBox(height: 24),
          _buildEmptySection(),
          const SizedBox(height: 24),
          _buildLoadingSection(),
          const SizedBox(height: 24),
          _buildTagSection(),
          const SizedBox(height: 24),
          _buildCheckboxSection(),
          const SizedBox(height: 24),
          _buildListGroupSection(),
          const SizedBox(height: 24),
          _buildTitleBarSection(),
        ],
      ),
    );
  }

  Widget _buildArrowSection() {
    return _buildSection(
      title: 'ComArrow 箭头组件',
      children: [
        const Text('不同方向的箭头：'),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                ComArrow(direction: ArrowDirection.left),
                SizedBox(height: 4),
                Text('左', style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                ComArrow(direction: ArrowDirection.right),
                SizedBox(height: 4),
                Text('右', style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                ComArrow(direction: ArrowDirection.up),
                SizedBox(height: 4),
                Text('上', style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                ComArrow(direction: ArrowDirection.down),
                SizedBox(height: 4),
                Text('下', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('不同颜色和大小：'),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ComArrow(color: Colors.red),
            ComArrow(color: Colors.blue),
            ComArrow(color: Colors.green),
            ComArrow(color: Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildDividerSection() {
    return _buildSection(
      title: 'ComDivider 分割线组件',
      children: [
        const Text('默认分割线：'),
        const SizedBox(height: 8),
        const ComDivider(),
        const Text('可超出父级分割线：'),
        const SizedBox(height: 8),
        const ComDivider(indent: -30, endIndent: -30),
        const SizedBox(height: 16),
        const Text('自定义分割线：'),
        const SizedBox(height: 8),
        const ComDivider(
          color: Colors.blue,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        const SizedBox(height: 16),
        const Text('虚线效果（通过多个短线实现）：'),
        const SizedBox(height: 8),
        Row(
          children: List.generate(
            20,
            (index) => Expanded(
              child: Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                color: index % 2 == 0 ? Colors.grey : Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySection() {
    return _buildSection(
      title: 'ComEmpty 空状态组件',
      children: [
        const ComEmpty(
          message: Text('暂无数据'),
        ),
        const SizedBox(height: 24),
        const ComEmpty(
          imageSize: 60,
          image: Icon(Icons.search, size: 60, color: Colors.grey),
          message: Text('没有找到相关内容'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return _buildSection(
      title: 'ComLoading 加载组件',
      children: [
        const SizedBox(
          height: 120,
          child: ComLoading(
            message: '加载中...',
          ),
        ),
        const SizedBox(height: 16),
        const SizedBox(
          height: 80,
          child: ComLoading(
            size: 30,
            color: Colors.blue,
            message: '请稍等',
          ),
        ),
      ],
    );
  }

  Widget _buildTagSection() {
    return _buildSection(
      title: 'ComTag 标签组件',
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const ComTag(child: Text('默认标签')),
            const ComTag(
              color: Colors.blue,
              child: Text('蓝色标签'),
            ),
            ComTag(
              color: Colors.green,
              borderRadius: BorderRadius.circular(6),
              child: const Text('圆角标签'),
            ),
            const ComTag(
              color: Colors.orange,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('大标签'),
            ),
            ComTag(
              color: Colors.red,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('标签被点击了！')),
                );
              },
              child: const Text('可点击'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckboxSection() {
    return _buildSection(
      title: 'ComCheckbox 复选框组件',
      children: [
        ComCheckboxListTile(
          title: const Text('普通复选框'),
          value: _isChecked,
          onChanged: (value) {
            setState(() {
              _isChecked = value ?? false;
            });
          },
        ),
        ComCheckboxListTile(
          title: const Text('普通勾选框'),
          value: _isChecked,
          checkboxShape: const CircleBorder(),
          onChanged: (value) {
            setState(() {
              _isChecked = value ?? false;
            });
          },
        ),
        ComCheckboxListTile(
          title: const Text('三态复选框'),
          subtitle: const Text('支持 true、false、null 三种状态'),
          value: _triStateChecked,
          tristate: true,
          onChanged: (value) {
            setState(() {
              if (_triStateChecked == false) {
                _triStateChecked = true;
              } else if (_triStateChecked == true) {
                _triStateChecked = null;
              } else {
                _triStateChecked = false;
              }
            });
          },
        ),
        const ComCheckboxListTile(
          title: Text('禁用状态'),
          value: true,
          onChanged: null,
        ),
      ],
    );
  }

  Widget _buildListGroupSection() {
    return _buildSection(
      title: 'ComListGroup 列表组组件',
      children: [
        const ComListGroup(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text('首页'),
              trailing: ComArrow(),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('个人中心'),
              trailing: ComArrow(),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('设置'),
              trailing: ComArrow(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitleBarSection() {
    return _buildSection(
      title: 'ComTitleBar 标题栏组件',
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const ComTitleBar(
            title: Text('默认标题栏'),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const ComTitleBar(
            title: Text('自定义标题栏'),
            backgroundColor: Colors.transparent,
            actions: [
              Icon(Icons.share),
              SizedBox(width: 8),
              Icon(Icons.more_vert),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return ComContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
