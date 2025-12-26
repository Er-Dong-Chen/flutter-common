import 'package:flutter/material.dart';

import '../../config/com_configuration.dart';

enum LayoutStatus { loading, empty, noNetwork, success, error }

class BaseWidget extends StatelessWidget {
  final Widget child;
  final Widget? empty;
  final Widget? loading;
  final Widget? noNetwork;
  final Widget? error;
  final LayoutStatus? status;
  final bool isConnected;

  const BaseWidget({
    super.key,
    required this.child,
    this.status,
    this.empty,
    this.loading,
    this.noNetwork,
    this.error,
    this.isConnected = true,
  });

  static Widget loadingWidget(BuildContext context) =>
      ComConfiguration.of(context).loadingWidget;

  static Widget emptyWidget(BuildContext context) =>
      ComConfiguration.of(context).emptyWidget;

  static Widget errorWidget(BuildContext context) =>
      ComConfiguration.of(context).errorWidget;

  static Widget noNetworkWidget(BuildContext context) =>
      ComConfiguration.of(context).noNetworkWidget;

  @override
  Widget build(BuildContext context) {
    return buildContent(context);
  }

  Widget buildContent(BuildContext context) {
    final actualStatus = (!isConnected && status == LayoutStatus.loading)
        ? LayoutStatus.noNetwork
        : (status ?? LayoutStatus.success);

    switch (actualStatus) {
      case LayoutStatus.loading:
        return loading ?? loadingWidget(context);
      case LayoutStatus.empty:
        return empty ?? emptyWidget(context);
      case LayoutStatus.noNetwork:
        return noNetwork ?? noNetworkWidget(context);
      case LayoutStatus.error:
        return error ?? errorWidget(context);
      case LayoutStatus.success:
        return child;
    }
  }
}
