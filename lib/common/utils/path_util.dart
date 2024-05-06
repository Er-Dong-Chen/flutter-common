import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathUtil {
  /// 获取临时目录路径
  static Future<String> getTemporaryDirectoryPath() async {
    final Directory tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }

  /// 获取应用程序文档目录路径
  static Future<String> getApplicationDocumentsDirectoryPath() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  /// 获取应用程序支持目录路径
  static Future<String> getApplicationSupportDirectoryPath() async {
    if (Platform.isIOS || Platform.isMacOS) {
      final Directory appSupportDir = await getLibraryDirectory();
      return appSupportDir.path;
    } else {
      final Directory appSupportDir = await getApplicationSupportDirectory();
      return appSupportDir.path;
    }
  }

  /// 获取下载目录路径
  static Future<String> getDownloadsDirectoryPath() async {
    if (Platform.isAndroid) {
      final Directory? downloadsDir = await getExternalStorageDirectory();
      return downloadsDir!.path;
    } else {
      final Directory? downloadsDir = await getDownloadsDirectory();
      return downloadsDir!.path;
    }
  }

  /// 获取缓存目录路径
  static Future<String> getCacheDirectoryPath() async {
    final Directory cacheDir = await getTemporaryDirectory();
    return cacheDir.path;
  }

  /// 获取应用程序程序包目录路径
  static Future<String> getApplicationSupportPackageDirectoryPath() async {
    final Directory appDir = await getApplicationSupportDirectory();
    return appDir.path;
  }

  /// 获取应用程序程序包临时目录路径
  static Future<String>
      getApplicationSupportPackageTemporaryDirectoryPath() async {
    final Directory appTempDir = await getTemporaryDirectory();
    return appTempDir.path;
  }

  /// 获取应用程序程序包文档目录路径
  static Future<String>
      getApplicationSupportPackageDocumentsDirectoryPath() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }
}
