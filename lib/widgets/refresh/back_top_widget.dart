import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class BackTopWidget extends StatefulWidget {
  final ScrollController scrollController;

  const BackTopWidget(this.scrollController, {super.key});

  @override
  State<StatefulWidget> createState() => BackTopState();
}

class BackTopState extends State<BackTopWidget> {
  bool _showBackTop = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// 滑动监听
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        isShow(false);
      } else {
        isShow(widget.scrollController.position.pixels > Get.height);
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
          widget.scrollController.animateTo(0.0,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        },
        child: Visibility(
            visible: _showBackTop,
            child: Container(
              width: 40,
              height: 40,
              decoration: (BoxDecoration(
                color: Colors.black.withOpacity(.3),
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              )),
              child: const Icon(Icons.vertical_align_top, color: Colors.white),
            )),
      ),
    );
  }

  void isShow(bool show) {
    if (mounted && show != _showBackTop) {
      setState(() => _showBackTop = show);
    }
  }
}
