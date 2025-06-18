import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';

class DialogPage extends StatelessWidget {
  const DialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialog'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            title: 'Toast 提示',
            children: [
              ComButton(
                child: const Text('显示普通Toast'),
                onPressed: () => DialogUtil.showToast('这是一条普通提示'),
              ),
            ],
          ),
          _buildSection(
            title: 'Loading 加载',
            children: [
              ComButton(
                child: const Text('显示Loading'),
                onPressed: () {
                  DialogUtil.showLoading(text: '加载中...');
                  Future.delayed(const Duration(seconds: 2), () {
                    DialogUtil.hideLoading();
                  });
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Alert Dialog 警告框',
            children: [
              ComButton(
                child: const Text('显示基础警告框'),
                onPressed: () => DialogUtil.showAlertDialog(
                  content:
                      const Text('这是一个基础的警告框这是一个基础的警告框这是一个基础的警告框这是一个基础的警告框'),
                ),
              ),
              const SizedBox(height: 8),
              ComButton(
                child: const Text('显示自定义警告框'),
                onPressed: () => DialogUtil.showAlertDialog(
                  title: const Text('自定义标题'),
                  content: const Text('这是自定义内容的警告框'),
                  confirm: const Text('知道了'),
                  onConfirm: () {
                    DialogUtil.showToast('点击了确认按钮');
                  },
                ),
              ),
              const SizedBox(height: 8),
              ComButton(
                child: const Text('显示iOS风格警告框'),
                onPressed: () => DialogUtil.showAlertDialog(
                  title: const Text('温馨提示'),
                  content: const Text('这是一个iOS风格的警告框'),
                  showIOS: true,
                ),
              ),
            ],
          ),
          _buildSection(
            title: 'Action Sheet 操作表',
            children: [
              ComButton(
                child: const Text('显示操作表'),
                onPressed: () => DialogUtil.showActionSheet(
                  title: const Text('选择操作'),
                  content: const Text('请选择要执行的操作'),
                  actions: const [
                    Text('操作一'),
                    Text('操作二'),
                    Text('操作三'),
                  ],
                  onConfirm: (index) {
                    DialogUtil.showToast('选择了操作${index + 1}');
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            title: 'Dialog 对话框',
            children: [
              ComButton(
                child: const Text('显示基础对话框'),
                onPressed: () => DialogUtil.showDialog(
                  title: const Text('温馨提示'),
                  content: const Text('这是一个基础的对话框'),
                ),
              ),
              const SizedBox(height: 8),
              ComButton(
                child: const Text('显示自定义对话框'),
                onPressed: () => DialogUtil.showDialog(
                  title: const Text('自定义标题'),
                  content: Column(
                    children: [
                      const Text('这是自定义内容的对话框'),
                      const SizedBox(height: 16),
                      ComButton(
                        child: const Text('自定义按钮'),
                        onPressed: () {
                          DialogUtil.showToast('点击了自定义按钮');
                        },
                      ),
                    ],
                  ),
                  showClose: true,
                ),
              ),
            ],
          ),
          _buildSection(
            title: 'Modal Bottom 底部弹窗',
            children: [
              ComButton(
                child: const Text('显示底部弹窗'),
                onPressed: () => DialogUtil.showModalBottom(
                  title: const Text('底部弹窗'),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('这是底部弹窗的内容'),
                        const SizedBox(height: 16),
                        ComButton(
                          child: const Text('关闭'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          _buildSection(
            title: 'Date Picker 日期选择器',
            children: [
              ComButton(
                child: const Text('显示日期选择器'),
                onPressed: () => DialogUtil.showDatePicker(
                  initialDateTime: DateTime.now(),
                  minimumDate: DateTime(2020),
                  maximumDate: DateTime(2030),
                  onConfirm: (date) {
                    DialogUtil.showToast('选择了$date');
                  },
                ),
              ),
              const SizedBox(height: 8),
              ComButton(
                child: const Text('显示时间选择器'),
                onPressed: () => DialogUtil.showDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  onConfirm: (date) {
                    DialogUtil.showToast('选择了$date');
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            title: 'Picker 选择器',
            children: [
              ComButton(
                child: const Text('显示选择器'),
                onPressed: () => DialogUtil.showPicker(
                  children: List.generate(
                    5,
                    (index) => Center(
                      child: Text('选项 ${index + 1}'),
                    ),
                  ),
                  onConfirm: (index) {
                    DialogUtil.showToast('选择了选项${index + 1}');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }
}
