import 'package:flutter/material.dart';

import '../widgets/base/base_widget.dart';
import '../widgets/base/com_empty.dart';
import '../widgets/base/com_loading.dart';

class ComConfig {
  final Widget loadingWidget;
  final Widget emptyWidget;
  final Widget errorWidget;
  final Widget Function(VoidCallback? onReconnect) noNetworkWidget;

  const ComConfig({
    required this.loadingWidget,
    required this.emptyWidget,
    required this.errorWidget,
    required this.noNetworkWidget,
  });

  ComConfig copyWith({
    Widget? loadingWidget,
    Widget? emptyWidget,
    Widget? errorWidget,
    Widget Function(VoidCallback? onReconnect)? noNetworkWidget,
  }) {
    return ComConfig(
      loadingWidget: loadingWidget ?? this.loadingWidget,
      emptyWidget: emptyWidget ?? this.emptyWidget,
      errorWidget: errorWidget ?? this.errorWidget,
      noNetworkWidget: noNetworkWidget ?? this.noNetworkWidget,
    );
  }

  factory ComConfig.defaults() => ComConfig(
        loadingWidget: const ComLoading(),
        emptyWidget: const ComEmpty(),
        errorWidget: const ComErrorWidget(),
        noNetworkWidget: (VoidCallback? onReconnect) =>
            ComNoNetworkWidget(onReconnect: onReconnect),
      );
}
