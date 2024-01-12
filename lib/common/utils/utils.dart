import 'package:flutter/services.dart';

export 'date_util.dart';
export 'encrypt_util.dart';
export 'function_util.dart';
export 'json_util.dart';
export 'log_util.dart';
export 'sp_util.dart';
export 'utils.dart';

class CommonUtils {
  static getClipboardData() async {
    var clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null) {
      return clipboardData;
    }
  }

  static setClipboardData(String text) async {
    ClipboardData data = ClipboardData(text: text);
    Clipboard.setData(data);
  }
}
