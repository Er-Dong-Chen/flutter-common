import 'package:flutter/material.dart';

import '../../config/com_configuration.dart';
import '../../localization/com_localizations.dart';
import 'com_button.dart';
import 'com_empty.dart';

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
    // 确定实际状态
    final actualStatus = (!isConnected && status == LayoutStatus.loading)
        ? LayoutStatus.noNetwork
        : (status ?? LayoutStatus.success);

    switch (actualStatus) {
      case LayoutStatus.loading:
        return loading ?? loadingWidget(context);
      case LayoutStatus.empty:
        return empty ?? emptyWidget(context);
      case LayoutStatus.noNetwork:
        return noNetwork ?? noNetworkWidget(context, onReconnect: onReconnect);
      case LayoutStatus.error:
        return error ?? errorWidget(context);
      case LayoutStatus.success:
        return child;
    }
  }
}

class ComNoNetworkWidget extends StatelessWidget {
  final VoidCallback? onReconnect;

  const ComNoNetworkWidget({super.key, this.onReconnect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = ComLocalizations.of(context);

    return ComEmpty(
      image: Image.asset(
        "assets/images/no_network.png",
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.wifi_off,
            size: 64,
            color: theme.colorScheme.outline,
          );
        },
      ),
      message: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localizations.networkError,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          if (onReconnect != null) ...[
            ComButton(
              onPressed: onReconnect,
              child: Text(localizations.networkRetry),
            ),
          ],
        ],
      ),
    );
  }
}

class ComErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ComErrorWidget({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = ComLocalizations.of(context);

    return ComEmpty(
      image: Image.asset(
        "assets/images/error.png",
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          );
        },
      ),
      message: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message ?? localizations.loadingFailed,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            ComButton(
              onPressed: onRetry,
              plain: true,
              child: Text(localizations.networkRetry),
            ),
          ],
        ],
      ),
    );
  }
}
