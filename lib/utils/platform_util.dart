import 'dart:io';

import 'package:flutter/foundation.dart';

class PlatformUtil {
  // 私有构造函数,防止实例化
  PlatformUtil._();

  // ==================== 平台判断 ====================

  static bool get isAndroid {
    return !kIsWeb && Platform.isAndroid;
  }

  static bool get isIOS {
    return !kIsWeb && Platform.isIOS;
  }

  static bool get isFuchsia {
    return !kIsWeb && Platform.isFuchsia;
  }

  static bool get isLinux {
    return !kIsWeb && Platform.isLinux;
  }

  static bool get isMacOS {
    return !kIsWeb && Platform.isMacOS;
  }

  static bool get isOhos {
    return !kIsWeb && Platform.operatingSystem == 'ohos';
  }

  static bool get isWindows {
    return !kIsWeb && Platform.isWindows;
  }

  static bool get isWeb {
    return kIsWeb;
  }

  // ==================== 平台分组判断 ====================

  /// 是否为移动端平台 (Android/iOS)
  static bool get isMobile {
    return isAndroid || isIOS;
  }

  /// 是否为桌面端平台 (Windows/macOS/Linux)
  static bool get isDesktop {
    return isWindows || isMacOS || isLinux;
  }

  /// 是否为苹果平台 (iOS/macOS)
  static bool get isApple {
    return isIOS || isMacOS;
  }

  // ==================== 获取具体平台值 ====================

  /// 获取当前平台名称
  /// 返回: 'android', 'ios', 'windows', 'macos', 'linux', 'fuchsia', 'ohos', 'web'
  static String get platformName {
    if (kIsWeb) return 'web';
    return Platform.operatingSystem.toLowerCase();
  }

  /// 获取平台类型枚举
  static PlatformType get platformType {
    if (kIsWeb) return PlatformType.web;

    switch (Platform.operatingSystem.toLowerCase()) {
      case 'android':
        return PlatformType.android;
      case 'ios':
        return PlatformType.ios;
      case 'windows':
        return PlatformType.windows;
      case 'macos':
        return PlatformType.macos;
      case 'linux':
        return PlatformType.linux;
      case 'fuchsia':
        return PlatformType.fuchsia;
      case 'ohos':
        return PlatformType.ohos;
      default:
        return PlatformType.unknown;
    }
  }

  /// 获取操作系统版本号 (仅非Web平台)
  static String get osVersion {
    if (kIsWeb) return 'N/A';
    return Platform.operatingSystemVersion;
  }

  /// 获取本地主机名 (仅非Web平台)
  static String get localHostname {
    if (kIsWeb) return 'N/A';
    return Platform.localHostname;
  }

  /// 获取处理器数量 (仅非Web平台)
  static int get numberOfProcessors {
    if (kIsWeb) return 0;
    return Platform.numberOfProcessors;
  }

  /// 获取脚本路径 (仅非Web平台)
  static String get script {
    if (kIsWeb) return 'N/A';
    return Platform.script.toString();
  }
}

// ==================== 平台类型枚举 ====================

enum PlatformType {
  android,
  ios,
  windows,
  macos,
  linux,
  fuchsia,
  ohos,
  web,
  unknown;

  /// 是否为移动平台
  bool get isMobile => this == android || this == ios;

  /// 是否为桌面平台
  bool get isDesktop => this == windows || this == macos || this == linux;

  /// 是否为苹果平台
  bool get isApple => this == ios || this == macos;
}
