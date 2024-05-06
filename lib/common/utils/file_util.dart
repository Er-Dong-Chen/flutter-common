import 'dart:convert';
import 'dart:io';

/// 文件操作工具类，提供文件相关操作。
class FileUtil {
  /// 将内容写入文件。
  static Future<File> writeFile(String path, String content) async {
    File file = File(path);
    return file.writeAsString(content);
  }

  /// 从文件中读取内容。
  static Future<String> readFile(String path) async {
    File file = File(path);
    return file.readAsString();
  }

  /// 判断文件是否存在。
  static Future<bool> exists(String path) async {
    File file = File(path);
    return file.exists();
  }

  /// 删除文件。
  static Future<void> deleteFile(String path) async {
    File file = File(path);
    await file.delete();
  }

  /// 以行为单位读取文件内容。
  static Future<List<String>> readLines(String path) async {
    File file = File(path);
    List<String> lines = await file.readAsLines();
    return lines;
  }

  /// 将字符串列表写入文件。
  static Future<void> writeLines(String path, List<String> lines) async {
    File file = File(path);
    await file.writeAsString(lines.join('\n'));
  }

  /// 向文件追加一行内容。
  static Future<void> appendLine(String path, String line) async {
    File file = File(path);
    IOSink sink = file.openWrite(mode: FileMode.append);
    sink.writeln(line);
    await sink.flush();
    await sink.close();
  }

  /// 从文件中读取JSON格式的数据。
  static Future<Map<String, dynamic>> readJson(String path) async {
    File file = File(path);
    String jsonString = await file.readAsString();
    return json.decode(jsonString);
  }

  /// 将JSON格式的数据写入文件。
  static Future<void> writeJson(
      String path, Map<String, dynamic> jsonMap) async {
    File file = File(path);
    String jsonString = json.encode(jsonMap);
    await file.writeAsString(jsonString);
  }

  /// 列出指定目录中的所有文件和子目录。
  static Future<List<FileSystemEntity>> listFiles(String directoryPath,
      {bool recursive = false}) async {
    Directory directory = Directory(directoryPath);
    List<FileSystemEntity> entities =
        await directory.list(recursive: recursive).toList();
    return entities;
  }

  /// 复制文件。
  static Future<void> copyFile(
      String sourcePath, String destinationPath) async {
    File sourceFile = File(sourcePath);
    await sourceFile.copy(destinationPath);
  }

  /// 移动文件。
  static Future<void> moveFile(
      String sourcePath, String destinationPath) async {
    File sourceFile = File(sourcePath);
    await sourceFile.rename(destinationPath);
  }

  /// 创建目录。
  static Future<void> createDirectory(String directoryPath) async {
    Directory directory = Directory(directoryPath);
    await directory.create(recursive: true);
  }

  /// 删除目录。
  static Future<void> deleteDirectory(String directoryPath) async {
    Directory directory = Directory(directoryPath);
    await directory.delete(recursive: true);
  }
}
