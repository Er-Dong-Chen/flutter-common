import 'package:flutter/foundation.dart';

class PlatformUtil {
  static bool get isAndroid => false;
  static bool get isIOS => false;
  static bool get isFuchsia => false;
  static bool get isLinux => false;
  static bool get isMacOS => false;
  static bool get isOhos => false;
  static bool get isWindows => false;
  static bool get isWeb => kIsWeb;
}
