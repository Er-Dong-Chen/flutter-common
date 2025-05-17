import 'package:flutter/widgets.dart';

class ComContext {
  static GlobalKey<NavigatorState>? _navigatorKey;

  static BuildContext get context {
    _validateState();
    return _navigatorKey!.currentContext!;
  }

  static NavigatorState get navigator {
    _validateState();
    return _navigatorKey!.currentState!;
  }

  static void init(GlobalKey<NavigatorState> key) {
    if (_navigatorKey != null) {
      throw StateError('ComContext has already been initialized.');
    }
    _navigatorKey = key;
  }

  static void _validateState() {
    if (_navigatorKey == null) {
      throw StateError(
        'ComContext not initialized. Call ComContext.init() with a valid '
        'GlobalKey<NavigatorState> before accessing context or navigator.',
      );
    }
    if (_navigatorKey!.currentState == null) {
      throw StateError(
        'Navigator key is not mounted. Ensure your Navigator widget with '
        'the provided key is present in the widget tree.',
      );
    }
  }
}
