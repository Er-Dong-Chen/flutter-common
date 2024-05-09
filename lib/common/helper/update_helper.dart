import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_chen_common/common/helper/common_helper.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class UpdateHelper {
  static Future download(String url,
      {ValueChanged<OtaEvent>? downloadCallback}) async {
    try {
      OtaUpdate().execute(url).listen(
        (OtaEvent event) {
          switch (event.status) {
            case OtaStatus.DOWNLOADING: // 下载中
              if (downloadCallback != null) {
                downloadCallback.call(event);
                return;
              }
              // print('下载进度:${event.value}%');
              break;
            case OtaStatus.INSTALLING: //安装中
              debugPrint('-----安装中----');
              // 打开安装文件
              // Apk文件名可以写，也可以不写
              // 不写的话会出现让你选择用浏览器打开，点击取消就好了，写了后会直接打开当前目录下的Apk文件，名字随便定就可以
              _installApk();
              break;
            case OtaStatus.PERMISSION_NOT_GRANTED_ERROR: // 权限错误
              CommonHelper.showToast("更新失败，暂无相关权限".tr);
              break;
            default: // 其他问题
              CommonHelper.showToast("更新异常".tr);
              break;
          }
        },
      );
    } on Exception catch (e) {
      CommonHelper.showToast("下载失败".tr);
      debugPrint(e.toString());
    }
  }

  static Future _installApk() async {
    String path = await _apkLocalPath;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await OpenFile.open('$path/${packageInfo.appName}');
  }

  static get _apkLocalPath async {
    final directory = await getExternalStorageDirectory();
    return directory?.path;
  }
}
