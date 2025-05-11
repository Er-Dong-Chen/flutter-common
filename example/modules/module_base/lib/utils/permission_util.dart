import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  /// 检查并请求权限（组合操作）
  /// [permissions] 需要检查的权限列表
  /// [openSettingsWhenPermanentDenied] 是否自动跳转设置
  /// 返回：是否全部权限已授权
  static Future<bool> checkAndRequest({
    required List<Permission> permissions,
    bool openSettingsWhenPermanentDenied = true,
  }) async {
    try {
      // 1. 检查当前权限状态
      final deniedPermissions = await _getDeniedPermissions(permissions);

      if (deniedPermissions.isEmpty) return true;

      // 2. 请求未授权权限
      final results = await deniedPermissions.request();

      // 3. 处理请求结果
      return _handleRequestResults(
        results,
        openSettingsWhenPermanentDenied,
      );
    } catch (e) {
      throw PermissionException('权限处理异常: ${e.toString()}');
    }
  }

  /// 获取未授权的权限列表
  static Future<List<Permission>> _getDeniedPermissions(
    List<Permission> permissions,
  ) async {
    final deniedPermissions = <Permission>[];

    for (final permission in permissions) {
      final status = await permission.status;
      if (!status.isGranted) {
        deniedPermissions.add(permission);
      }
    }
    return deniedPermissions;
  }

  /// 处理权限请求结果
  static bool _handleRequestResults(
    Map<Permission, PermissionStatus> results,
    bool shouldOpenSettings,
  ) {
    bool allGranted = true;

    results.forEach((permission, status) {
      if (!status.isGranted) {
        allGranted = false;
        _handleDeniedPermission(permission, status, shouldOpenSettings);
      }
    });

    return allGranted;
  }

  /// 处理未授权权限
  static void _handleDeniedPermission(
    Permission permission,
    PermissionStatus status,
    bool shouldOpenSettings,
  ) {
    switch (status) {
      case PermissionStatus.denied:
        throw PermissionDeniedException(permission);
      case PermissionStatus.permanentlyDenied:
        if (shouldOpenSettings) openAppSettings();
        throw PermissionPermanentlyDeniedException(permission);
      case PermissionStatus.restricted:
        throw PermissionRestrictedException(permission);
      case PermissionStatus.limited:
        throw PermissionLimitedException(permission);
      case PermissionStatus.provisional:
      case PermissionStatus.granted:
        break;
    }
  }
}

/// 自定义权限异常体系
class PermissionException implements Exception {
  final String message;
  PermissionException(this.message);
}

class PermissionDeniedException extends PermissionException {
  final Permission permission;
  PermissionDeniedException(this.permission)
      : super('${permission.toString()} 权限被拒绝');
}

class PermissionPermanentlyDeniedException extends PermissionException {
  final Permission permission;
  PermissionPermanentlyDeniedException(this.permission)
      : super('${permission.toString()} 权限被永久拒绝');
}

class PermissionRestrictedException extends PermissionException {
  final Permission permission;
  PermissionRestrictedException(this.permission)
      : super('${permission.toString()} 权限受限');
}

class PermissionLimitedException extends PermissionException {
  final Permission permission;
  PermissionLimitedException(this.permission)
      : super('${permission.toString()} 权限被限制');
}

///```dart
/// Future<void> startCamera() async {
///  try {
///    final hasPermission = await PermissionUtil.checkAndRequest(
///      permissions: [Permission.camera],
///    );
///
///    if (hasPermission) {
///      // 执行相机操作
///    }
///  } on PermissionDeniedException catch (e) {
///    // 处理普通拒绝
///    showPermissionDeniedDialog(e.permission);
///  } on PermissionPermanentlyDeniedException catch (e) {
///    // 处理永久拒绝（已自动跳转设置）
///    showPermanentDeniedGuide(e.permission);
///  }
/// }
///```
