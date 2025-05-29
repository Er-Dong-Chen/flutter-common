import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';

import 'keep_alive_wrapper.dart';

class CommonListView<T> extends StatelessWidget {
  final int? itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final LayoutStatus status;
  final Widget? emptyBuilder;
  final Widget? loadingBuilder;
  final Widget? errorBuilder;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool keepAlive;
  final String? pageStorageKey;
  final EdgeInsetsGeometry? padding;

  const CommonListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.status = LayoutStatus.success,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.controller,
    this.physics,
    this.keepAlive = false,
    this.pageStorageKey,
    this.padding,
  }) : assert(itemCount == null || itemCount >= 0);

  @override
  Widget build(BuildContext context) {
    if (status == LayoutStatus.success && (itemCount ?? 0) > 0) {
      return _buildDataList(context);
    } else if (itemCount == 0) {
      return _buildStatus(context, LayoutStatus.empty);
    }
    return _buildStatus(context, status);
  }

  Widget _buildDataList(BuildContext context) {
    return ListView.builder(
      key: pageStorageKey != null
          ? PageStorageKey<String>(pageStorageKey!)
          : null,
      controller: controller,
      physics: physics,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (keepAlive) {
          return KeepAliveWrapper(
            child: itemBuilder(context, index),
          );
        }
        return itemBuilder(context, index);
      },
    );
  }

  Widget _buildStatus(BuildContext context, LayoutStatus status) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: BaseWidget(
          status: status,
          loading: loadingBuilder,
          empty: emptyBuilder,
          error: errorBuilder,
          child: const SizedBox(),
        ),
      ),
    );
  }
}
