import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';

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

  static config(
      {MaterialColor? theme, Gradient? primaryGradient, double? radius}) {
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
  }
}
