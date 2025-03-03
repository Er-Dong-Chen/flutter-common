import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

/// Widget for displaying a back to top button.
class BackTopWidget extends StatefulWidget {
  final ScrollController scrollController; // 滚动控制器，用于监听滚动事件

  /// Constructor for BackTopWidget.
  ///
  /// [scrollController]: The scroll controller to listen to scroll events.
  /// [key]: Optional key to use for this widget.
  const BackTopWidget(this.scrollController, {super.key});

  @override
  State<StatefulWidget> createState() => BackTopState(); // 创建状态类的实例
}

/// State class for the BackTopWidget.
class BackTopState extends State<BackTopWidget> {
  bool _showBackTop = false; // 是否显示返回顶部按钮，默认为false

  @override
  void initState() {
    super.initState();

    /// Scroll listener to control the visibility of the back to top button.
    widget.scrollController.addListener(() {
      // Scroll listener, shows/hides the back to top button based on scroll direction and position
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        isShow(false); // If scrolling downwards, hide the back to top button
      } else {
        isShow(widget.scrollController.position.pixels >
            Get.height); // If scroll position is greater than screen height, show the back to top button
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Builds the widget
    return Positioned(
      bottom: 40,
      right: 20,
      child: GestureDetector(
        onTap: () {
          // Tap event, scrolls to the top
          widget.scrollController.animateTo(0.0,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        },
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _showBackTop
              ? 1.0
              : 0.0, // Controls the visibility of the back to top button
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .3),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: const Icon(Icons.vertical_align_top,
                color: Colors.white), // Back to top icon
          ),
        ),
      ),
    );
  }

  // Controls the visibility of the back to top button
  void isShow(bool show) {
    if (mounted && show != _showBackTop) {
      setState(() => _showBackTop = show);
    }
  }
}
