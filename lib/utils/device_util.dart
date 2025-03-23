import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 包含了设备相关操作的通用类。
class DeviceUtils {
  /// 获取设备唯一标识符（需要在AndroidManifest.xml或Info.plist中添加权限）。
  static Future<String?> getDeviceId() async {
    try {
      return await const MethodChannel('device_utils')
          .invokeMethod('getDeviceId');
    } on PlatformException catch (e) {
      debugPrint("Failed to get device id: '${e.message}'.");
      return null;
    }
  }

  /// 检查当前设备是否为平板电脑。
  static Future<bool> isTablet() async {
    try {
      return await const MethodChannel('device_utils').invokeMethod('isTablet');
    } on PlatformException catch (e) {
      debugPrint("Failed to check if device is tablet: '${e.message}'.");
      return false;
    }
  }

  /// 获取当前设备的操作系统名称。
  static Future<String?> getPlatform() async {
    try {
      if (Platform.isAndroid) {
        return "Android";
      } else if (Platform.isIOS) {
        return "iOS";
      } else if (Platform.isMacOS) {
        return "macOS";
      } else if (Platform.isWindows) {
        return "Windows";
      } else if (Platform.isLinux) {
        return "Linux";
      } else {
        return "Unknown";
      }
    } catch (e) {
      debugPrint("Failed to get operating system: '${e.toString()}'.");
      return null;
    }
  }

  /// 获取当前设备的操作系统版本号。
  static Future<String?> getOperatingSystemVersion() async {
    try {
      return Platform.operatingSystemVersion;
    } catch (e) {
      debugPrint("Failed to get operating system version: '${e.toString()}'.");
      return null;
    }
  }

  /// 获取当前设备的名称。
  static Future<String?> getDeviceName() async {
    try {
      return Platform.localHostname;
    } catch (e) {
      debugPrint("Failed to get device name: '${e.toString()}'.");
      return null;
    }
  }

  /// 检查当前设备是否为iOS设备。
  static Future<bool> isIOS() async {
    return Platform.isIOS;
  }

  /// 检查当前设备是否为Android设备。
  static Future<bool> isAndroid() async {
    return Platform.isAndroid;
  }

  /// 检查当前设备是否为Mac设备。
  static Future<bool> isMacOS() async {
    return Platform.isMacOS;
  }

  /// 检查当前设备是否为Windows设备。
  static Future<bool> isWindows() async {
    return Platform.isWindows;
  }

  /// 检查当前设备是否为Linux设备。
  static Future<bool> isLinux() async {
    return Platform.isLinux;
  }
}
