import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';

class SliverPage extends StatelessWidget {
  const SliverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 默认 AppBar
          SliverAppBar(
            title: const Text('Sliver Header 演示'),
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('可展开的标题'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.landscape,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // 固定的自定义标题栏
          ComSliverPinnedHeader(
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    '固定标题栏',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // 列表内容
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text('${index + 1}'),
                  ),
                  title: Text('列表项 ${index + 1}'),
                  subtitle: Text('这是第 ${index + 1} 个列表项'),
                  trailing: const ComArrow(),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('点击了列表项 ${index + 1}')),
                    );
                  },
                );
              },
              childCount: 20,
            ),
          ),

          // 另一个固定标题栏
          ComSliverPinnedHeader(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.grid_view, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    '网格区域',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),

          // 网格内容
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ComContainer(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.apps,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text('网格 ${index + 1}'),
                    ],
                  ),
                );
              },
              childCount: 10,
            ),
          ),

          // 浮动标题栏演示
          SliverSnapHeader(
            child: AppBar(
              title: const Text('浮动标题栏'),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              automaticallyImplyLeading: false,
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // 更多列表内容
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ComContainer(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Icon(
                      Icons.article,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    title: Text('文章标题 ${index + 1}'),
                    subtitle: Text('这是一篇关于 Flutter 开发的文章 ${index + 1}'),
                    trailing: ComTag(
                      color: index % 3 == 0
                          ? Colors.red
                          : index % 2 == 0
                              ? Colors.orange
                              : Colors.green,
                      child: Text(index % 3 == 0
                          ? '推荐'
                          : index % 2 == 0
                              ? '热门'
                              : '最新'),
                    ),
                  ),
                );
              },
              childCount: 15,
            ),
          ),

          // 底部间距
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}
