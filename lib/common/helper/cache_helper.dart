import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class CacheHelper {
  static Future<String> getCacheSize() async {
    final Directory tempDir = await getTemporaryDirectory();
    double size = 0.0;
    await for (final FileSystemEntity entity in tempDir.list()) {
      if (entity is File) {
        size += await entity.length();
      }
    }
    return formatFileSize(size);
  }

  static Future<void> clearCache() async {
    final Directory appDocDir = await getTemporaryDirectory();
    if (appDocDir.existsSync()) {
      await deleteDirectory(appDocDir);
    } else {
      debugPrint('Cache directory does not exist');
    }
  }

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

  static String formatFileSize(double size) {
    size = size / 1024;
    if (size > 1024) {
      size = size / 1024;
      return "${size.toStringAsFixed(2)}MB";
    } else {
      return "${size.toStringAsFixed(2)}KB";
    }
  }
}
