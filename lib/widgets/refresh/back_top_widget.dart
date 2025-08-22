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
  double _threshold = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _threshold = MediaQuery.of(context).size.height;
  }

  void _onScroll() {
    if (!mounted) return;

    final position = widget.scrollController.position;
    if (position.userScrollDirection == ScrollDirection.reverse) {
      isShow(false);
    } else {
      isShow(position.pixels > _threshold);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
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
