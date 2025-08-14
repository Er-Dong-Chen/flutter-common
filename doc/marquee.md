# ComMarquee 跑马灯

## 🌟 核心特性

- 🚀 高性能渲染，流畅滚动
- 🌈 支持任意widget，满足所有场景
- 🎨 灵活样式，完全可控
- 📱 响应式布局及交互
- 🔄 无缝循环，视觉连续
- ⚡️ 轻量高效，按需渲染

## 效果展示

![ComMarquee 效果预览](https://er-dong-chen.github.io/images/demo/marquee.gif)

## 🚀 快速开始

### 🎪 基础文本跑马灯

创建一个简单的文本滚动效果：

```dart
Container(
  height: 50,
  decoration: BoxDecoration(
    color: Colors.blue.shade50,
    borderRadius: BorderRadius.circular(25),
    border: Border.all(color: Colors.blue.shade200),
  ),
  child: ComMarquee(
    direction: MarqueeDirection.left,
    speed: 60,
    pauseOnHover: true,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.campaign, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            '🎉 欢迎使用 ComMarquee 组件！功能强大、使用简单、效果炫酷',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  ),
)
```

### 📋 智能列表跑马灯

展示多个项目的连续滚动：

```dart
Container(
  height: 200,
  margin: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: ComMarqueeList(
    direction: MarqueeDirection.up,
    speed: 40,
    visibleItemCount: 3,
    itemSpacing: 12,
    pauseDuration: 2000,
    itemHeight: 60,
    pauseOnHover: true, // 支持鼠标悬停暂停
    children: [
      _buildNewsItem('🔥', '重大突破！flutter_chen_common 2.0 正式发布', '2小时前'),
      _buildNewsItem('📢', '系统维护通知：今晚12点开始', '4小时前'),
      _buildNewsItem('🎉', '恭喜张三获得月度最佳奖项', '6小时前'),
      _buildNewsItem('💡', '新功能上线：AI智能推荐', '8小时前'),
      _buildNewsItem('📊', '月活用户突破100万大关', '1天前'),
    ],
  ),
)

Widget _buildNewsItem(String icon, String title, String time) {
  return GestureDetector(
    onTap: () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('点击了：$title'),
          backgroundColor: Colors.green,
        ),
      );
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(icon, style: TextStyle(fontSize: 20)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
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
```

### 🎨 精美样式展示

创建具有渐变背景和阴影效果的跑马灯：

```dart
Container(
  height: 60,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.purple.shade400, Colors.blue.shade400],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: Colors.purple.shade200,
        blurRadius: 12,
        offset: Offset(0, 6),
      ),
    ],
  ),
  child: ComMarquee(
    direction: MarqueeDirection.left,
    speed: 80,
    pauseOnHover: true,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            '✨ 体验极致的滚动效果，ComMarquee 让您的应用更加生动',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 3,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.star, color: Colors.white, size: 20),
        ],
      ),
    ),
  ),
)
```

---

## 📚 API 文档

### 🎪 ComMarquee

单个内容的滚动组件，适用于文本、图片等单一元素。

#### 参数说明

| 参数 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `child` | `Widget` | **必需** | 要滚动的内容组件 |
| `direction` | `MarqueeDirection` | `left` | 滚动方向（left/right/up/down） |
| `speed` | `double` | `50.0` | 滚动速度（像素/秒） |
| `infinite` | `bool` | `true` | 是否无限循环滚动 |
| `autoStart` | `bool` | `true` | 是否自动开始滚动 |
| `pauseDuration` | `int` | `0` | 每轮滚动间隔（毫秒） |
| `pauseOnHover` | `bool` | `false` | 鼠标悬停时是否暂停 |
| `controller` | `MarqueeController?` | `null` | 控制器，用于编程控制滚动 |
| `minScrollDistance` | `double` | `0.0` | 最小滚动距离 |
| `scrollOnlyWhenOverflow` | `bool` | `false` | 是否只在内容超出容器时才滚动 |
| `onComplete` | `VoidCallback?` | `null` | 滚动完成回调 |

### 📋 ComMarqueeList

单个内容的滚动组件，适合多项目列表的多元素滚动组件。

#### 参数说明

| 参数 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `children` | `List<Widget>` | **必需** | 要滚动的Widget列表 |
| `direction` | `MarqueeDirection` | `up` | 滚动方向 |
| `speed` | `double` | `30.0` | 滚动速度（像素/秒） |
| `visibleItemCount` | `int` | `3` | 同时可见的项目数量 |
| `itemSpacing` | `double` | `8.0` | 项目之间的间距 |
| `infinite` | `bool` | `true` | 是否无限循环 |
| `autoStart` | `bool` | `true` | 是否自动开始 |
| `pauseDuration` | `int` | `0` | 每轮完成后停留时间（毫秒） |
| `itemHeight` | `double` | `60.0` | 项目高度（垂直滚动时） |
| `itemWidth` | `double` | `120.0` | 项目宽度（水平滚动时） |
| `controller` | `MarqueeController?` | `null` | 控制器，用于编程控制滚动 |
| `pauseOnHover` | `bool` | `false` | 鼠标悬停时是否暂停 |
| `onComplete` | `VoidCallback?` | `null` | 滚动完成回调 |

### 🎮 MarqueeController

跑马灯控制器，用于编程控制滚动状态。

#### 方法说明

| 方法 | 返回类型 | 描述 |
|------|--------|------|
| `start()` | `void` | 开始滚动 |
| `pause()` | `void` | 暂停滚动 |
| `resume()` | `void` | 恢复滚动 |
| `reset()` | `void` | 重置滚动到初始状态 |
| `isScrolling` | `bool` | 获取是否正在滚动 |
| `isPaused` | `bool` | 获取是否已暂停 |

### 🧭 MarqueeDirection

滚动方向枚举：

```dart
enum MarqueeDirection {
  left,   // 👈 向左滚动
  right,  // 👉 向右滚动  
  up,     // 👆 向上滚动
  down,   // 👇 向下滚动
}
```

---

## 🎯 高级用法

### 🎮 编程控制

通过MarqueeController控制跑马灯的播放状态：

```dart
class MarqueeControlPage extends StatefulWidget {
  @override
  _MarqueeControlPageState createState() => _MarqueeControlPageState();
}

class _MarqueeControlPageState extends State<MarqueeControlPage> {
  final MarqueeController _controller = MarqueeController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 基础跑马灯控制
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: ComMarquee(
            controller: _controller,
            autoStart: false,
            direction: MarqueeDirection.left,
            speed: 50,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '这是一个可以编程控制的跑马灯组件 🎮',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        
        SizedBox(height: 16),
        
        // 控制按钮组
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _controller.start(),
              icon: Icon(Icons.play_arrow),
              label: Text('开始'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _controller.pause(),
              icon: Icon(Icons.pause),
              label: Text('暂停'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _controller.resume(),
              icon: Icon(Icons.play_arrow),
              label: Text('继续'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _controller.reset(),
              icon: Icon(Icons.refresh),
              label: Text('重置'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16),
        
        // 状态显示
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _controller.isScrolling ? Icons.play_circle : Icons.pause_circle,
              color: _controller.isScrolling ? Colors.green : Colors.orange,
            ),
            SizedBox(width: 8),
            Text(
              _controller.isScrolling ? '正在滚动' : 
              _controller.isPaused ? '已暂停' : '已停止',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: _controller.isScrolling ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// 列表跑马灯控制示例
class MarqueeListControlExample extends StatefulWidget {
  @override
  _MarqueeListControlExampleState createState() => _MarqueeListControlExampleState();
}

class _MarqueeListControlExampleState extends State<MarqueeListControlExample> {
  final MarqueeController _listController = MarqueeController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        children: [
          // 列表跑马灯
          Expanded(
            child: ComMarqueeList(
              controller: _listController,
              direction: MarqueeDirection.up,
              speed: 30,
              visibleItemCount: 2,
              itemHeight: 50,
              autoStart: false,
              children: [
                '📱 移动应用开发',
                '🌐 Web前端开发', 
                '⚙️ 后端服务开发',
                '🎨 UI/UX设计',
                '📊 数据分析',
              ].map((text) => Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.purple.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )).toList(),
            ),
          ),
          
          // 控制区域
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => _listController.start(),
                  icon: Icon(Icons.play_arrow, color: Colors.green),
                  tooltip: '开始',
                ),
                IconButton(
                  onPressed: () => _listController.pause(),
                  icon: Icon(Icons.pause, color: Colors.orange),
                  tooltip: '暂停',
                ),
                IconButton(
                  onPressed: () => _listController.resume(),
                  icon: Icon(Icons.play_arrow, color: Colors.blue),
                  tooltip: '继续',
                ),
                IconButton(
                  onPressed: () => _listController.reset(),
                  icon: Icon(Icons.refresh, color: Colors.grey),
                  tooltip: '重置',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### 🎨 主题适配

与应用主题完美集成：

```dart
Widget _buildThemedMarquee(BuildContext context) {
  final theme = Theme.of(context);
  
  return Container(
    decoration: BoxDecoration(
      color: theme.primaryColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
    ),
    child: ComMarquee(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          '自动适配应用主题的跑马灯',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  );
}
```

### 🔗 响应式布局

根据屏幕尺寸动态调整：

```dart
Widget _buildResponsiveMarquee(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isSmallScreen = constraints.maxWidth < 600;
      
      return ComMarqueeList(
        visibleItemCount: isSmallScreen ? 2 : 4,
        itemHeight: isSmallScreen ? 50 : 70,
        speed: isSmallScreen ? 20 : 40,
        children: _buildResponsiveItems(isSmallScreen),
      );
    },
  );
}
```