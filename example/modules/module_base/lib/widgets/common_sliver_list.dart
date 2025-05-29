import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';

import 'keep_alive_wrapper.dart';

class CommonSliverList<T> extends StatelessWidget {
  final List<T> dataList;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final LayoutStatus status;
  final Widget? emptyBuilder;
  final Widget? loadingBuilder;
  final Widget? errorBuilder;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool keepAlive;
  final String? pageStorageKey;

  const CommonSliverList({
    super.key,
    required this.dataList,
    required this.itemBuilder,
    this.status = LayoutStatus.success,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.controller,
    this.physics = const ClampingScrollPhysics(),
    this.keepAlive = true,
    this.pageStorageKey,
  });

  @override
  Widget build(BuildContext context) {
    if (status == LayoutStatus.success && dataList.isNotEmpty) {
      return _buildDataList(context);
    } else if (dataList.isEmpty) {
      return _buildStatus(context, LayoutStatus.empty);
    }
    return _buildStatus(context, status);
  }

  Widget _buildDataList(BuildContext context) {
    return SliverList(
      key: pageStorageKey != null
          ? PageStorageKey<String>(pageStorageKey!)
          : null,
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (keepAlive) {
            return KeepAliveWrapper(
              child: itemBuilder(context, dataList[index], index),
            );
          }
          return itemBuilder(context, dataList[index], index);
        },
        childCount: dataList.length,
      ),
    );
  }

  Widget _buildStatus(BuildContext context, LayoutStatus status) {
    return SliverFillRemaining(
      hasScrollBody: false,
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
