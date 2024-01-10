import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  /// 检测是否有权限
  /// [permissionList] 权限申请列表
  static Future<bool> checkPermission(List<Permission> permissionList) async {
    ///一个新待申请权限列表
    List<Permission> newPermissionList = [];

    ///遍历当前权限申请列表
    for (Permission permission in permissionList) {
      PermissionStatus status = await permission.status;

      ///如果不是允许状态就添加到新的申请列表中
      if (!status.isGranted) {
        newPermissionList.add(permission);
      }
    }

    ///如果需要重新申请的列表不是空的
    if (newPermissionList.isNotEmpty) {
      PermissionStatus permissionStatus =
          await requestPermission(newPermissionList);
      bool result = false;

      switch (permissionStatus) {
        ///拒绝状态
        case PermissionStatus.denied:
          break;

        /// 永久拒绝  活动限制
        case PermissionStatus.restricted:
        case PermissionStatus.limited:
        case PermissionStatus.permanentlyDenied:
          openAppSettings();
          break;

        ///允许状态
        case PermissionStatus.provisional:
        case PermissionStatus.granted:
          result = true;
          break;
      }
      return result;
    } else {
      return true;
    }
  }

  /// 获取新列表中的权限 如果有一项不合格就返回false
  static requestPermission(List<Permission> permissionList) async {
    Map<Permission, PermissionStatus> statuses = await permissionList.request();
    PermissionStatus currentPermissionStatus = PermissionStatus.granted;
    statuses.forEach((key, value) {
      if (!value.isGranted) {
        currentPermissionStatus = value;
        return;
      }
    });
    return currentPermissionStatus;
  }
}
