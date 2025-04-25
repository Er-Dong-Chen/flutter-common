import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ComSliverPinnedHeader extends StatelessWidget {
  final Widget child;
  final Color? color;

  const ComSliverPinnedHeader({
    super.key,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _ComSliverPinnedHeaderDelegate(
          child: child, color: color ?? Colors.white),
    );
  }
}

class _ComSliverPinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Color color;

  _ComSliverPinnedHeaderDelegate({required this.child, required this.color});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ColoredBox(color: color, child: child);
  }

  @override
  double get maxExtent => (child is PreferredSizeWidget)
      ? (child as PreferredSizeWidget).preferredSize.height
      : kToolbarHeight; // 默认高度

  @override
  double get minExtent => maxExtent;

  @override
  bool shouldRebuild(covariant _ComSliverPinnedHeaderDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.color != color;
  }
}

class SliverSnapHeader extends StatefulWidget {
  final PreferredSizeWidget child;

  const SliverSnapHeader({
    super.key,
    required this.child,
  });

  @override
  State<SliverSnapHeader> createState() => _SliverSnapHeaderState();
}

class _SliverSnapHeaderState extends State<SliverSnapHeader>
    with TickerProviderStateMixin {
  FloatingHeaderSnapConfiguration? _snapConfiguration;
  PersistentHeaderShowOnScreenConfiguration? _showOnScreenConfiguration;

  void _initSnapConfiguration() {
    _snapConfiguration = FloatingHeaderSnapConfiguration(
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 200),
    );

    _showOnScreenConfiguration =
        const PersistentHeaderShowOnScreenConfiguration(
            minShowOnScreenExtent: double.infinity);
  }

  @override
  void initState() {
    super.initState();
    _initSnapConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      floating: true,
      pinned: false,
      delegate: _SliverSnapHeaderDelegate(
          vsync: this,
          child: widget.child,
          snapConfiguration: _snapConfiguration,
          showOnScreenConfiguration: _showOnScreenConfiguration),
    );
  }
}

class _SliverSnapHeaderDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;

  @override
  final TickerProvider vsync;

  _SliverSnapHeaderDelegate({
    required this.child,
    required this.snapConfiguration,
    required this.vsync,
    required this.showOnScreenConfiguration,
  });

  @override
  final FloatingHeaderSnapConfiguration? snapConfiguration;

  @override
  final PersistentHeaderShowOnScreenConfiguration? showOnScreenConfiguration;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant _SliverSnapHeaderDelegate oldDelegate) {
    return oldDelegate.child != child ||
        vsync != oldDelegate.vsync ||
        snapConfiguration != oldDelegate.snapConfiguration ||
        showOnScreenConfiguration != oldDelegate.showOnScreenConfiguration;
  }
}
