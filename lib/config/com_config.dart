import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:flutter_chen_common/widgets/base/base_widget.dart';

class ComConfig {
  static Future<Map<String, dynamic>> Function()? ossConfig;

  static void setOssConfig(Future<Map<String, dynamic>> Function() getter) {
    ossConfig = getter;
  }

  static Future<Map<String, dynamic>> getOssConfig() async {
    if (ossConfig != null) {
      return ossConfig!();
    } else {
      throw Exception("OSS配置获取函数未设置");
    }
  }

  static config({
    MaterialColor? theme,
    Gradient? primaryGradient,
    double? radius,
    Widget? loadingWidget,
    Widget? emptyWidget,
    Widget? errorWidget,
    Widget Function(VoidCallback? onReconnect)? noNetworkWidget,
  }) {
    /// 配置主题
    if (theme != null) {
      CommonColors.theme = theme;
    }
    if (primaryGradient != null) {
      CommonColors.primaryGradient = primaryGradient;
    }
    if (radius != null) {
      CommonStyle.roundedMd = radius;
    }
    if (loadingWidget != null) {
      BaseWidget.loadingWidget = loadingWidget;
    }
    if (emptyWidget != null) {
      BaseWidget.emptyWidget = emptyWidget;
    }
    if (errorWidget != null) {
      BaseWidget.errorWidget = errorWidget;
    }
    if (noNetworkWidget != null) {
      BaseWidget.noNetworkWidget = noNetworkWidget;
    }
  }
}
