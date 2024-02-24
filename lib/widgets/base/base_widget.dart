import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:get/get.dart';

enum LayoutStatus { loading, empty, noNetwork, complete, error }

class BaseWidget extends StatelessWidget {
  final Widget? title;
  final AppBar? appBar;
  final Color? backgroundColor;
  final Widget body;
  final Widget? empty;
  final Widget? loading;
  final Widget? noNetwork;
  final Widget? error;
  final LayoutStatus? status;
  final VoidCallback? onReconnect;
  final bool isConnected;

  const BaseWidget({
    super.key,
    this.title,
    this.appBar,
    this.backgroundColor,
    required this.body,
    this.status,
    this.empty,
    this.loading,
    this.noNetwork,
    this.error,
    this.onReconnect,
    this.isConnected = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar ??
          AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () => Get.back(),
            ),
            centerTitle: true,
            title: title,
          ),
      body: buildContent(),
    );
  }

  Widget buildContent() {
    switch (!isConnected ? LayoutStatus.noNetwork : status) {
      case LayoutStatus.loading:
        return loading ?? const ComLoading();
      case LayoutStatus.empty:
        return empty ?? const ComEmpty();
      case LayoutStatus.noNetwork:
        return Center(
          child: noNetwork ??
              ComEmpty(
                image: Image.asset("assets/images/no_network.png"),
                message: Column(
                  children: [
                    Text(
                      '网络错误，请检查后重试',
                      style: CommonStyle.secondaryStyle,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ComButton(
                      onPressed: () => onReconnect?.call(),
                      child: const Text('点击重试'),
                    )
                  ],
                ),
              ),
        );
      case LayoutStatus.error:
        return error ??
            ComEmpty(
              message: Text(
                '加载错误',
                style: CommonStyle.secondaryStyle,
              ),
            );
      default:
        return body;
    }
  }
}
