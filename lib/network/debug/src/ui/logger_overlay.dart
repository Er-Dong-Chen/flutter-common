import 'package:flutter/material.dart';
import 'package:flutter_chen_common/config/com_context.dart';

import 'log_pages.dart';

class ComNetworkLogger extends StatefulWidget {
  const ComNetworkLogger._({
    required this.right,
    required this.bottom,
    required this.draggable,
    super.key,
  });
  final double bottom;
  final double right;
  final bool draggable;
  static OverlayEntry show(
    BuildContext context, {
    bool rootOverlay = false,
    double bottom = 300,
    double right = 30,
    bool draggable = true,
  }) {
    if (_ComNetworkDebugEntry.inserted || _ComNetworkDebugEntry.scheduled) {
      return _ComNetworkDebugEntry.entry ??
          OverlayEntry(builder: (_) => const SizedBox());
    }
    final entry = OverlayEntry(
      builder: (context) => ComNetworkLogger._(
        bottom: bottom,
        right: right,
        draggable: draggable,
      ),
    );
    _ComNetworkDebugEntry.scheduled = true;
    _ComNetworkDebugEntry.entry = entry;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_ComNetworkDebugEntry.inserted) {
        _ComNetworkDebugEntry.scheduled = false;
        return;
      }
      final overlay = Overlay.maybeOf(context, rootOverlay: rootOverlay);
      if (overlay != null) {
        overlay.insert(entry);
        _ComNetworkDebugEntry.inserted = true;
        _ComNetworkDebugEntry.scheduled = false;
      } else {
        try {
          final ov = ComContext.navigator.overlay;
          if (ov != null) {
            ov.insert(entry);
            _ComNetworkDebugEntry.inserted = true;
            _ComNetworkDebugEntry.scheduled = false;
          }
        } catch (_) {}
      }
    });
    return entry;
  }

  @override
  State<ComNetworkLogger> createState() => _ComNetworkLoggerState();
}

class _ComNetworkLoggerState extends State<ComNetworkLogger> {
  static const Size buttonSize = Size(57, 57);
  late double bottom = widget.bottom;
  late double right = widget.right;
  late MediaQueryData screen;
  Offset? lastPosition;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screen = MediaQuery.of(context);
  }

  void onPanUpdate(LongPressMoveUpdateDetails details) {
    final delta = lastPosition! - details.localPosition;
    bottom += delta.dy;
    right += delta.dx;
    lastPosition = details.localPosition;
    if (bottom < 0) bottom = 0;
    if (right < 0) right = 0;
    if (bottom + buttonSize.height > screen.size.height) {
      bottom = screen.size.height - buttonSize.height;
    }
    if (right + buttonSize.width > screen.size.width) {
      right = screen.size.width - buttonSize.width;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.draggable) {
      return Positioned(
        right: right,
        bottom: bottom,
        child: GestureDetector(
          onLongPressMoveUpdate: onPanUpdate,
          onLongPressUp: () => setState(() => lastPosition = null),
          onLongPressDown: (d) =>
              setState(() => lastPosition = d.localPosition),
          child: Material(
            elevation: lastPosition == null ? 0 : 30,
            borderRadius: BorderRadius.all(Radius.circular(buttonSize.width)),
            child: _ComNetworkLoggerButton(),
          ),
        ),
      );
    }
    return Positioned(
      right: widget.right + screen.padding.right,
      bottom: widget.bottom + screen.padding.bottom,
      child: _ComNetworkLoggerButton(),
    );
  }
}

class _ComNetworkLoggerButton extends StatefulWidget {
  @override
  State<_ComNetworkLoggerButton> createState() =>
      _ComNetworkLoggerButtonState();
}

class _ComNetworkLoggerButtonState extends State<_ComNetworkLoggerButton> {
  bool _visible = true;
  Future<void> _press() async {
    setState(() => _visible = false);
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ComNetworkLogListPage()),
      );
    } finally {
      if (mounted) setState(() => _visible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox();
    return FloatingActionButton(
      onPressed: _press,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(Icons.cloud, color: Theme.of(context).colorScheme.onPrimary),
    );
  }
}

class _ComNetworkDebugEntry {
  static bool inserted = false;
  static bool scheduled = false;
  static OverlayEntry? entry;
}
