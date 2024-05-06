import 'package:package_info_plus/package_info_plus.dart';

/// 应用包信息工具类，提供获取应用包相关信息。
class PackageUtil {
  /// 获取应用包信息。
  static Future<PackageInfo> getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  /// 获取应用名称。
  static Future<String> getAppName() async {
    final PackageInfo packageInfo = await getPackageInfo();
    return packageInfo.appName;
  }

  /// 获取应用包名。
  static Future<String> getPackageName() async {
    final PackageInfo packageInfo = await getPackageInfo();
    return packageInfo.packageName;
  }

  /// 获取应用版本号。
  static Future<String> getVersion() async {
    final PackageInfo packageInfo = await getPackageInfo();
    return packageInfo.version;
  }

  /// 获取应用构建号。
  static Future<String> getBuildNumber() async {
    final PackageInfo packageInfo = await getPackageInfo();
    return packageInfo.buildNumber;
  }
}
