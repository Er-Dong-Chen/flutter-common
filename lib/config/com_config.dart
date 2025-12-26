import 'package:flutter/material.dart';

import '../widgets/base/com_loading.dart';

class ComConfig {
  final Widget loadingWidget;
  final Widget emptyWidget;
  final Widget errorWidget;
  final Widget noNetworkWidget;

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
    Widget? noNetworkWidget,
  }) {
    return ComConfig(
      loadingWidget: loadingWidget ?? this.loadingWidget,
      emptyWidget: emptyWidget ?? this.emptyWidget,
      errorWidget: errorWidget ?? this.errorWidget,
      noNetworkWidget: noNetworkWidget ?? this.noNetworkWidget,
    );
  }

  factory ComConfig.defaults() => const ComConfig(
        loadingWidget: ComLoading(),
        emptyWidget: SizedBox(),
        errorWidget: SizedBox(),
        noNetworkWidget: SizedBox(),
      );
}
