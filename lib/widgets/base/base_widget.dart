import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:get/get.dart';

enum LayoutStatus { loading, empty, noNetwork, complete, error }

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

  static Widget loadingWidget = const ComLoading();
  static Widget emptyWidget = const ComEmpty();
  static Widget errorWidget = ComEmpty(
    message: Text(
      '加载错误'.tr,
      style: Theme.of(Get.context!).textTheme.bodySmall,
    ),
  );
  static Widget Function(VoidCallback? onReconnect) noNetworkWidget =
      (onReconnect) => NoNetworkWidget(onReconnect: onReconnect);

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  Widget buildContent() {
    switch (!isConnected && status == LayoutStatus.loading
        ? LayoutStatus.noNetwork
        : status) {
      case LayoutStatus.loading:
        return loading ?? loadingWidget;
      case LayoutStatus.empty:
        return empty ?? emptyWidget;
      case LayoutStatus.noNetwork:
        return noNetwork ?? noNetworkWidget(onReconnect);
      case LayoutStatus.error:
        return error ?? errorWidget;
      case LayoutStatus.complete:
      default:
        return child;
    }
  }
}

class NoNetworkWidget extends StatelessWidget {
  final VoidCallback? onReconnect;

  const NoNetworkWidget({super.key, this.onReconnect});

  @override
  Widget build(BuildContext context) {
    return ComEmpty(
      image: Image.asset("assets/images/no_network.png"),
      message: Column(
        children: [
          Text(
            '网络错误，请检查后重试'.tr,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(
            height: 12,
          ),
          ComButton(
            onPressed: () => onReconnect?.call(),
            child: Text('点击重试'.tr),
          )
        ],
      ),
    );
  }
}
