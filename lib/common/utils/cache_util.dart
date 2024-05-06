import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

/// 缓存工具类，提供临时缓存相关操作。
class CacheUtil {
  /// 获取当前缓存大小。
  static Future<String> getCacheSize() async {
    final Directory tempDir = await getTemporaryDirectory();
    double size = 0.0;
    await for (final FileSystemEntity entity in tempDir.list()) {
      if (entity is File) {
        size += await entity.length();
      }
    }
    return formatMemorySize(size);
  }

  /// 清除缓存。
  static Future<void> clearCache() async {
    final Directory appDocDir = await getTemporaryDirectory();
    if (appDocDir.existsSync()) {
      await deleteDirectory(appDocDir);
    } else {
      debugPrint('Cache directory does not exist');
    }
  }

  /// 递归删除目录。
  static Future<void> deleteDirectory(Directory dir) async {
    final List<FileSystemEntity> entities = await dir.list().toList();
    for (final FileSystemEntity entity in entities) {
      if (entity is File) {
        await entity.delete();
      } else if (entity is Directory) {
        await deleteDirectory(entity);
      }
    }
    await dir.delete();
  }

  /// 格式化内存大小。
  static String formatMemorySize(final double byteSize, {int precision = 2}) {
    if (byteSize < 0) {
      return '0B';
    } else if (byteSize < 1024) {
      return '${byteSize}B';
    } else if (byteSize < 1048576) {
      var size = (byteSize / 1024).toStringAsFixed(precision);
      return '${size}KB';
    } else if (byteSize < 1073741824) {
      var size = (byteSize / 1048576).toStringAsFixed(precision);
      return '${size}MB';
    } else {
      var size = (byteSize / 1073741824).toStringAsFixed(precision);
      return '${size}GB';
    }
  }
}
