import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';

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

  factory ComConfig.defaults() => ComConfig(
        loadingWidget: const ComLoading(),
        emptyWidget: const ComEmpty(),
        errorWidget: const ComErrorWidget(),
        noNetworkWidget: (VoidCallback? onReconnect) =>
            ComNoNetworkWidget(onReconnect: onReconnect),
      );
}
