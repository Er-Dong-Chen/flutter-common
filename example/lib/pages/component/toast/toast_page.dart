import 'package:flutter/material.dart';
import 'package:flutter_chen_common/toast/src/toast.dart';
import 'package:flutter_chen_common/toast/src/toast_config.dart';
import 'package:flutter_chen_common/widgets/base/com_button.dart';

/// ComToast 完整使用示例
///
/// 展示 Toast 和 Loading 的所有功能特性
/// 包括基础用法、自定义样式、实际场景应用等
class ToastPage extends StatefulWidget {
  const ToastPage({super.key});

  @override
  State<ToastPage> createState() => _ToastPageState();
}

class _ToastPageState extends State<ToastPage> {
  int _uploadProgress = 0;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toast'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.white,
                )),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('📱 基础 Toast 类型'),
              _buildBasicToastSection(),
              const SizedBox(height: 24),
              _buildSectionTitle('🎨 自定义 Toast'),
              _buildCustomToastSection(),
              const SizedBox(height: 24),
              _buildSectionTitle('⏳ Loading 功能'),
              _buildLoadingSection(),
              const SizedBox(height: 24),
              _buildSectionTitle('🎭 自定义 Loading'),
              _buildCustomLoadingSection(),
              const SizedBox(height: 24),
              _buildSectionTitle('🔄 实际应用场景'),
              const SizedBox(height: 12),
              _buildRealScenarioSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildBasicToastSection() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ComButton(
                onPressed: () => ComToast.show('这是一个普通的 Toast 消息'),
                child: const Text('普通 Toast'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ComButton(
                color: Colors.green,
                onPressed: () => ComToast.success('操作成功！数据已保存'),
                child: const Text('成功'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ComButton(
                color: Colors.red,
                onPressed: () => ComToast.error('操作失败！请检查网络连接'),
                child: const Text('错误'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ComButton(
                color: Colors.orange,
                onPressed: () => ComToast.warning('警告：余额不足，请及时充值'),
                child: const Text('警告'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ComButton(
          color: Colors.blue,
          onPressed: () => ComToast.info('新版本已发布，请及时更新'),
          child: const Text('信息 Toast'),
        ),
      ],
    );
  }

  Widget _buildCustomToastSection() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ComButton(
                onPressed: () {
                  ComToast.show(
                    '顶部 Toast',
                    config: const ComToastConfig(
                      position: ComToastPosition.top,
                    ),
                  );
                },
                child: const Text('顶部位置'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ComButton(
                onPressed: () {
                  ComToast.show(
                    '底部 Toast',
                    config: const ComToastConfig(
                      position: ComToastPosition.bottom,
                    ),
                  );
                },
                child: const Text('底部位置'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ComButton(
          onPressed: () {
            ComToast.custom(
              builder: (context) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pink, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      '自定义渐变 Toast',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Text('自定义 Toast'),
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ComButton(
                onPressed: () => _showBasicLoading(),
                child: const Text('基础 Loading'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ComButton(
                onPressed: () => _showMessageLoading(),
                child: const Text('带文字 Loading'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ComButton(
          onPressed: () => _testAutoLoading(),
          child: const Text('自动 Loading'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildCustomLoadingSection() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ComButton(
                onPressed: () => _showDownloadLoading(),
                child: const Text('下载样式'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ComButton(
                onPressed: () => _showUploadLoading(),
                child: const Text('上传样式'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ComButton(
                onPressed: () => _showProgressLoading(),
                child: const Text('进度条样式'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ComButton(
                onPressed: () => _showAnimatedLoading(),
                child: const Text('动画样式'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRealScenarioSection() {
    return Row(
      children: [
        Expanded(
          child: ComButton(
            onPressed: () => _simulateNetworkRequest(),
            child: const Text('模拟网络请求'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ComButton(
            onPressed: () => _simulateFormSubmit(),
            child: const Text('模拟表单提交'),
          ),
        ),
      ],
    );
  }

  // Loading 相关方法
  void _showBasicLoading() {
    ComToast.loading();

    // 3秒后自动关闭
    Future.delayed(const Duration(seconds: 3), () {
      if (ComToast.isLoadingShowing) {
        ComToast.hideLoading();
        ComToast.success('基础Loading演示完成');
      }
    });
  }

  void _showMessageLoading() {
    ComToast.loading(message: '正在加载数据...');

    // 4秒后自动关闭
    Future.delayed(const Duration(seconds: 4), () {
      if (ComToast.isLoadingShowing) {
        ComToast.hideLoading();
        ComToast.success('带文字Loading演示完成');
      }
    });
  }

  void _testAutoLoading() async {
    try {
      final result = await ComToast.autoLoading(
        () => _mockAsyncOperation(),
        message: '自动Loading测试中...',
      );
      ComToast.success('自动Loading完成: $result');
    } catch (e) {
      ComToast.error('操作失败: $e');
    }
  }

  void _showDownloadLoading() {
    ComToast.customLoading(
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download, size: 48, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              '正在下载...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '请稍候，正在处理您的请求',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 120,
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: true,
    );

    // 3秒后自动关闭
    Future.delayed(const Duration(seconds: 3), () {
      if (ComToast.isLoadingShowing) {
        ComToast.hideLoading();
        ComToast.success('下载完成！');
      }
    });
  }

  void _showUploadLoading() {
    ComToast.customLoading(
      builder: (context) => Container(
        width: 280,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.purple, Colors.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_upload,
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '正在上传文件',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '请保持网络连接',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: 4,
                  width: 120 * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '70%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    // 4秒后自动关闭
    Future.delayed(const Duration(seconds: 4), () {
      if (ComToast.isLoadingShowing) {
        ComToast.hideLoading();
        ComToast.success('上传完成！');
      }
    });
  }

  void _showProgressLoading() {
    setState(() {
      _uploadProgress = 0;
      _isUploading = true;
    });

    ComToast.customLoading(
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.backup, size: 40, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              '数据同步中',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: _uploadProgress / 100,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$_uploadProgress%',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    // 模拟进度更新
    _updateProgress();
  }

  void _updateProgress() {
    if (!_isUploading) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_uploadProgress < 100 && _isUploading) {
        setState(() {
          _uploadProgress += 2;
        });
        _updateProgress();
      } else {
        setState(() {
          _isUploading = false;
        });
        if (ComToast.isLoadingShowing) {
          ComToast.hideLoading();
          ComToast.success('同步完成！');
        }
      }
    });
  }

  void _showAnimatedLoading() {
    ComToast.customLoading(
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '智能分析中...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'AI 正在处理您的数据',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );

    // 5秒后自动关闭
    Future.delayed(const Duration(seconds: 5), () {
      if (ComToast.isLoadingShowing) {
        ComToast.hideLoading();
        ComToast.success('分析完成！');
      }
    });
  }

  // 场景模拟方法
  Future<void> _simulateNetworkRequest() async {
    try {
      final result = await ComToast.autoLoading(
        () => _mockNetworkCall(),
        message: '正在请求数据...',
      );
      ComToast.success('网络请求成功: $result');
    } catch (e) {
      ComToast.error('网络请求失败: $e');
    }
  }

  Future<void> _simulateFormSubmit() async {
    // 表单验证
    if (DateTime.now().millisecond % 3 == 0) {
      ComToast.warning('请填写完整信息');
      return;
    }

    ComToast.info('正在提交表单...');

    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      ComToast.success('表单提交成功！');
    } catch (e) {
      ComToast.error('提交失败，请重试');
    }
  }

  Future<void> _simulateFileOperation() async {
    ComToast.loading(message: '正在处理文件...');

    try {
      // 模拟文件操作
      for (int i = 0; i <= 100; i += 20) {
        await Future.delayed(const Duration(milliseconds: 300));
        // 这里可以更新进度
      }

      ComToast.hideLoading();
      ComToast.success('文件处理完成！');
    } catch (e) {
      ComToast.hideLoading();
      ComToast.error('文件处理失败');
    }
  }

  Future<void> _simulatePayment() async {
    // 第一步：验证支付信息
    ComToast.loading(message: '验证支付信息...');
    await Future.delayed(const Duration(seconds: 1));

    // 第二步：处理支付
    ComToast.loading(message: '正在处理支付...');
    await Future.delayed(const Duration(seconds: 2));

    // 第三步：确认结果
    ComToast.loading(message: '确认支付结果...');
    await Future.delayed(const Duration(seconds: 1));

    ComToast.hideLoading();

    // 随机支付结果
    if (DateTime.now().millisecond % 2 == 0) {
      ComToast.success('支付成功！订单已确认');
    } else {
      ComToast.error('支付失败，请重试');
    }
  }

  // 辅助方法
  Future<String> _mockAsyncOperation() async {
    await Future.delayed(const Duration(seconds: 2));
    return '异步操作结果';
  }

  Future<String> _mockNetworkCall() async {
    await Future.delayed(const Duration(seconds: 2));

    // 随机成功或失败
    if (DateTime.now().millisecond % 4 == 0) {
      throw Exception('网络连接超时');
    }

    return '数据加载成功';
  }

  @override
  void dispose() {
    // 页面销毁时确保关闭所有Loading
    ComToast.hideLoading();
    super.dispose();
  }
}
