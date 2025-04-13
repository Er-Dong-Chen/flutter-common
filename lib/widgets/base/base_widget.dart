import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:get/get.dart';

enum LayoutStatus { loading, empty, noNetwork, success, error }

class BaseWidget extends StatelessWidget {
  final Widget child;
  final Widget? empty;
  final Widget? loading;
  final Widget? noNetwork;
  final Widget? error;
  final LayoutStatus? status;
  final VoidCallback? onReconnect;
  final bool isConnected;

  const BaseWidget({
    super.key,
    required this.child,
    this.status,
    this.empty,
    this.loading,
    this.noNetwork,
    this.error,
    this.onReconnect,
    this.isConnected = true,
  });

  static Widget loadingWidget(BuildContext context) =>
      ComConfiguration.of(context).loadingWidget;

  static Widget emptyWidget(BuildContext context) =>
      ComConfiguration.of(context).emptyWidget;

  static Widget errorWidget(BuildContext context) =>
      ComConfiguration.of(context).errorWidget;

  static Widget noNetworkWidget(
    BuildContext context, {
    VoidCallback? onReconnect,
  }) =>
      ComConfiguration.of(context).noNetworkWidget(onReconnect);

  @override
  Widget build(BuildContext context) {
    return buildContent(context);
  }

  Widget buildContent(BuildContext context) {
    switch (!isConnected && status == LayoutStatus.loading
        ? LayoutStatus.noNetwork
        : status) {
      case LayoutStatus.loading:
        return loading ?? loadingWidget(context);
      case LayoutStatus.empty:
        return empty ?? emptyWidget(context);
      case LayoutStatus.noNetwork:
        return noNetwork ?? noNetworkWidget(context, onReconnect: onReconnect);
      case LayoutStatus.error:
        return error ?? errorWidget(context);
      case LayoutStatus.success:
      default:
        return child;
    }
  }
}

class ComNoNetworkWidget extends StatelessWidget {
  final VoidCallback? onReconnect;

  const ComNoNetworkWidget({super.key, this.onReconnect});

  @override
  Widget build(BuildContext context) {
    return ComEmpty(
      image: Image.asset("assets/images/no_network.png"),
      message: Column(
        children: [
          Text(
            ComLocalizations.of(context).networkError,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(
            height: 12,
          ),
          ComButton(
            onPressed: () => onReconnect?.call(),
            child: Text(ComLocalizations.of(context).retry),
          )
        ],
      ),
    );
  }
}

class ComErrorWidget extends StatelessWidget {
  const ComErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ComEmpty(
      image: Image.asset("assets/images/error.png"),
      message: Text(
        ComLocalizations.of(Get.context!).loadingFailed,
        style: Theme.of(Get.context!).textTheme.bodySmall,
      ),
    );
  }
}
