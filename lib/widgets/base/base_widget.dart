import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'com_state_layout.dart';

class BaseWidget extends StatelessWidget {
  final String? title;
  final AppBar? appbar;
  final Widget content;
  final Widget? empty;
  final Widget? loading;
  final Widget? noNetwork;
  final Widget? error;
  final LayoutStatus? status;
  const BaseWidget({
    super.key,
    this.title,
    this.appbar,
    required this.content,
    this.status,
    this.empty,
    this.loading,
    this.noNetwork,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar ??
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Get.back(),
            ),
            title: Text('$title'),
          ),
      body: ComStateLayout(
        content: content,
        status: status,
        loading: loading,
        empty: empty,
        error: error,
        noNetwork: noNetwork,
      ), // 页面内容
    );
  }
}
