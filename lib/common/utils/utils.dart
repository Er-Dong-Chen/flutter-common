import 'dart:math';

export 'cache_util.dart';
export 'clipboard_util.dart';
export 'clone_util.dart';
export 'color_util.dart';
export 'date_util.dart';
export 'device_util.dart';
export 'file_util.dart';
export 'function_util.dart';
export 'image_util.dart';
export 'json_util.dart';
export 'keyboard_util.dart';
export 'log_util.dart';
export 'permission_util.dart';
export 'sp_util.dart';
export 'text_util.dart';
export 'utils.dart';

class CommonUtils {
  static int randomNumber({int max = 999}) {
    return Random.secure().nextInt(max);
  }
}
