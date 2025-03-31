import 'package:flutter/material.dart';

import 'com_config.dart';

class ComConfiguration extends InheritedWidget {
  final ComConfig config;

  const ComConfiguration({
    super.key,
    required this.config,
    required super.child,
  });

  static ComConfig of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<ComConfiguration>()
            ?.config ??
        ComConfig.defaults();
  }

  @override
  bool updateShouldNotify(ComConfiguration oldWidget) =>
      config != oldWidget.config;
}
