import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';

import 'keep_alive_wrapper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonListView<T> extends StatelessWidget {
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
  final EdgeInsetsGeometry? padding;

  const CommonListView({
    super.key,
    required this.dataList,
    required this.itemBuilder,
    this.status = LayoutStatus.success,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.controller,
    this.physics,
    this.keepAlive = true,
    this.pageStorageKey,
    this.padding,
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
    return ListView.builder(
      key: pageStorageKey != null
          ? PageStorageKey<String>(pageStorageKey!)
          : null,
      controller: controller,
      physics: physics,
      padding: padding,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        if (keepAlive) {
          return KeepAliveWrapper(
            child: itemBuilder(context, dataList[index], index),
          );
        }
        return itemBuilder(context, dataList[index], index);
      },
    );
  }

  Widget _buildStatus(BuildContext context, LayoutStatus status) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.h),
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
