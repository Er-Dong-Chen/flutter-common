import 'package:flutter/services.dart';

/// 键盘相关操作工具类
class KeyboardUtils {
  /// 隐藏键盘
  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// 显示键盘
  static void showKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  /// 切换键盘显示状态
  static void toggleKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  /// 检查键盘是否可见
  static Future<bool> isKeyboardVisible() async {
    final bool isKeyboardVisible =
        await SystemChannels.textInput.invokeMethod('TextInput.hide');
    return isKeyboardVisible;
  }

  /// 清除数据
  static void clearClientKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.clearClient');
  }
}
