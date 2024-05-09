import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class BackTopWidget extends StatefulWidget {
  final ScrollController scrollController; // 接收滚动控制器

  // 构造函数，接收滚动控制器和可选的key
  const BackTopWidget(this.scrollController, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BackTopState(); // 创建状态类的实例
}

class BackTopState extends State<BackTopWidget> {
  bool _showBackTop = false; // 是否显示返回顶部按钮，默认为false

  @override
  void initState() {
    super.initState();

    /// 滑动监听
    widget.scrollController.addListener(() {
      // 滚动监听，根据滚动方向和位置显示/隐藏返回顶部按钮
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        isShow(false); // 如果是向下滚动，隐藏返回顶部按钮
      } else {
        isShow(widget.scrollController.position.pixels >
            Get.height); // 如果滚动位置超过屏幕高度，显示返回顶部按钮
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      right: 20,
      child: GestureDetector(
        onTap: () {
          // 点击事件，滚动到顶部
          widget.scrollController.animateTo(0.0,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        },
        child: Visibility(
          visible: _showBackTop, // 根据_showBackTop控制是否显示返回顶部按钮
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.3),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: const Icon(Icons.vertical_align_top,
                color: Colors.white), // 返回顶部图标
          ),
        ),
      ),
    );
  }

  // 控制是否显示返回顶部按钮
  void isShow(bool show) {
    if (mounted && show != _showBackTop) {
      setState(() => _showBackTop = show);
    }
  }
}
