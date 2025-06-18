import 'package:flutter/material.dart';
import 'package:flutter_chen_common/widgets/marquee/com_marquee.dart';

/// 跑马灯演示页面
class MarqueePage extends StatefulWidget {
  const MarqueePage({super.key});

  @override
  State<MarqueePage> createState() => _MarqueePageState();
}

class _MarqueePageState extends State<MarqueePage> {
  // 示例数据
  final List<String> _newsItems = [
    '🔥 热点新闻：flutter_chen_common 2.0 版本正式发布，带来了性能提升和新功能',
    '📢 重要通知：系统将于今晚12点进行维护升级，预计持续2小时',
    '🎉 恭喜用户张三获得本月最佳贡献奖，感谢对社区的贡献',
    '💡 新功能上线：支持深色模式和多语言切换，提升用户体验',
    '📊 数据统计：本月活跃用户突破10万大关，再创历史新高',
    '🚀 产品更新：新增AI智能推荐功能，个性化体验全面升级',
    '🎯 活动预告：下周将举办开发者大会，欢迎报名参与',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('跑马灯组件演示'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('基础文本跑马灯'),
            _buildBasicTextMarquee(),
            const SizedBox(height: 24),
            _buildSectionTitle('长文本跑马灯测试'),
            _buildLongTextMarquee(),
            const SizedBox(height: 24),
            _buildSectionTitle('多方向滚动演示'),
            _buildDirectionDemo(),
            const SizedBox(height: 24),
            _buildSectionTitle('垂直列表滚动'),
            _buildVerticalListMarquee(),
            const SizedBox(height: 24),
            _buildSectionTitle('单项显示滚动演示'),
            _buildSingleItemScrollMarquee(),
            const SizedBox(height: 24),
            _buildSectionTitle('水平列表滚动'),
            _buildHorizontalListMarquee(),
            const SizedBox(height: 24),
            _buildSectionTitle('新闻公告滚动'),
            _buildNewsMarquee(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildBasicTextMarquee() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: ComMarquee(
        direction: MarqueeDirection.left,
        speed: 60,
        pauseOnHover: true,
        child: Text(
          '这是一个简单的跑马灯文本演示，样式在外部Container中定义 🎪',
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLongTextMarquee() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: ComMarquee(
        direction: MarqueeDirection.left,
        speed: 80,
        pauseOnHover: true,
        child: Text(
          '这是一个超级长的文本跑马灯测试，用来验证组件能够正确处理任意长度的文本内容，确保不会出现截断、重叠或其他显示问题。组件能够完整显示所有内容，从容器的一端平滑滚动到另一端。🚀✨🎉📱💻🌟🔥💡🎯📊🎪🎨🛠️🔧⚡️🎊🎈🌈💫⭐️🌟',
          style: TextStyle(
            fontSize: 16,
            color: Colors.green.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionDemo() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDirectionItem('← 向左滚动测试', MarqueeDirection.left),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDirectionItem('向右滚动测试 →', MarqueeDirection.right),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: ComMarquee(
                  direction: MarqueeDirection.up,
                  speed: 30,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '向上滚动\n测试文本\n↑↑↑',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: ComMarquee(
                  direction: MarqueeDirection.down,
                  speed: 30,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '↓↓↓\n向下滚动\n测试文本',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDirectionItem(String text, MarqueeDirection direction) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: ComMarquee(
        direction: direction,
        speed: 50,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalListMarquee() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pink.shade200),
      ),
      child: ComMarqueeList(
        direction: MarqueeDirection.up,
        speed: 40,
        visibleItemCount: 3,
        itemSpacing: 12,
        pauseDuration: 2000,
        itemHeight: 60.0,
        children: _newsItems
            .take(5)
            .map(
              (item) => GestureDetector(
                onTap: () {
                  // 测试点击事件是否正常工作
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('点击成功！内容：${item.substring(0, 20)}...'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade200,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.pink.shade400,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.pink.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // 添加点击提示图标
                      Icon(
                        Icons.touch_app,
                        size: 16,
                        color: Colors.pink.shade300,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSingleItemScrollMarquee() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade200, width: 2),
      ),
      child: ComMarqueeList(
        direction: MarqueeDirection.up,
        speed: 25,
        visibleItemCount: 1,
        itemSpacing: 10,
        itemHeight: 70.0,
        children: [
          '✅ 完成Flutter项目重构',
          '📱 设计新的用户界面',
          '🔧 优化应用性能',
        ]
            .map(
              (task) => GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('点击了任务：$task')),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.deepPurple.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.shade100,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 3,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade400,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.deepPurple.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '#${[
                              '✅ 完成Flutter项目重构',
                              '📱 设计新的用户界面',
                              '🔧 优化应用性能',
                            ].indexOf(task) + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.deepPurple.shade400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildHorizontalListMarquee() {
    return Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyan.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.shade200),
      ),
      child: ComMarqueeList(
        direction: MarqueeDirection.left,
        speed: 30,
        visibleItemCount: 3,
        itemSpacing: 16,
        pauseDuration: 1500,
        itemWidth: 100.0,
        itemHeight: 80.0,
        children: ['科技', '财经', '体育', '娱乐', '游戏', '汽车', '房产']
            .map(
              (category) => GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('选择了分类：$category')),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.cyan.shade300),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.category,
                        color: Colors.cyan.shade700,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.cyan.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildNewsMarquee() {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: ComMarqueeList(
        direction: MarqueeDirection.up,
        speed: 25,
        visibleItemCount: 2,
        itemSpacing: 8,
        pauseDuration: 3000,
        itemHeight: 50.0,
        children: _newsItems
            .take(4)
            .map(
              (item) => GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('点击了新闻：${item.substring(0, 20)}...')),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.amber.shade600,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.amber.shade800,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
