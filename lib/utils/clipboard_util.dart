import 'dart:async';

import 'package:flutter/services.dart';

class ClipboardUtil {
  /// 从剪贴板获取文本内容
  static Future<String> getClipboardData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text ?? '';
  }

  /// 将文本内容复制到剪贴板
  static Future<void> setClipboardData(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
