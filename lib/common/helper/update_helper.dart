import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/helper/common_helper.dart';
import 'package:flutter_chen_common/common/helper/permission_helper.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateHelper {
  static String apkName = 'flutterApp.apk';
  static dynamic taskId;

  static getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  static Future download(String url) async {
    // 初始化 FlutterDownloader
    await FlutterDownloader.initialize();

    final per = await PermissionHelper.checkPermission([Permission.storage]);
    if (!per) {
      CommonHelper.showToast("下载失败，请开启相关权限后再操作");
    }

    final path = await _apkLocalPath;
    File file = File(path + '/' + apkName);
    if (await file.exists()) await file.delete();

    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize();

    CommonHelper.showToast("开始下载");
    taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: path,
        fileName: apkName,
        showNotification: true,
        openFileFromNotification: true);

    FlutterDownloader.registerCallback((id, status, progress) {
      DownloadTaskStatus downloadTaskStatus = DownloadTaskStatus.values[status];
      if (downloadTaskStatus == DownloadTaskStatus.failed) {
        CommonHelper.showToast("下载失败");
      }
      if (taskId == id && downloadTaskStatus == DownloadTaskStatus.complete) {
        CommonHelper.showToast("下载完成");
        _installApk();
      }
    });
  }

  static Future _installApk() async {
    String path = await _apkLocalPath;
    await OpenFile.open('$path/$apkName');
  }

  static get _apkLocalPath async {
    final directory = await getExternalStorageDirectory();
    return directory?.path;
  }
}
