import 'package:package_info_plus/package_info_plus.dart';

/// 应用包信息工具类，提供获取应用包相关信息。
class PackageUtil {
  static PackageInfo? _packageInfo;

  /// 获取应用包信息。
  static Future<PackageInfo> getPackageInfo() async {
    if (_packageInfo != null) {
      return _packageInfo!;
    }

    try {
      // 从平台获取应用包信息
      _packageInfo = await PackageInfo.fromPlatform();
      return _packageInfo!;
    } catch (e) {
      rethrow;
    }
  }

  /// 获取应用名称。
  static Future<String> getAppName() async {
    try {
      final PackageInfo packageInfo = await getPackageInfo();
      return packageInfo.appName;
    } catch (e) {
      return '未知应用';
    }
  }

  /// 获取应用包名。
  static Future<String> getPackageName() async {
    try {
      final PackageInfo packageInfo = await getPackageInfo();
      return packageInfo.packageName;
    } catch (e) {
      return '未知包名';
    }
  }

  /// 获取应用版本号。
  static Future<String> getVersion() async {
    try {
      final PackageInfo packageInfo = await getPackageInfo();
      return packageInfo.version;
    } catch (e) {
      return '未知版本';
    }
  }

  /// 获取应用构建号。
  static Future<String> getBuildNumber() async {
    try {
      final PackageInfo packageInfo = await getPackageInfo();
      return packageInfo.buildNumber;
    } catch (e) {
      return '未知构建号';
    }
  }
}
