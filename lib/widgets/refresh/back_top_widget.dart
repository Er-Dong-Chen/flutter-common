import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BackTopWidget extends StatefulWidget {
  final ScrollController scrollController;
  final Widget? childBuilder;

  const BackTopWidget(this.scrollController, {super.key, this.childBuilder});

  @override
  State<StatefulWidget> createState() => BackTopState();
}

class BackTopState extends State<BackTopWidget> {
  bool _showBackTop = false;

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        isShow(false);
      } else {
        isShow(widget.scrollController.position.pixels >
            MediaQuery.of(context).size.height);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.scrollController.animateTo(0.0,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _showBackTop ? 1.0 : 0.0,
        child: widget.childBuilder ??
            Container(
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
    );
  }

  void isShow(bool show) {
    if (mounted && show != _showBackTop) {
      setState(() => _showBackTop = show);
    }
  }
}
