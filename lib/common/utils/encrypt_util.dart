import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Encrypt Util.
class EncryptUtil {
  /// sha256 加密
  static String encodeSha256(String data) {
    var bytes = utf8.encode(data);
    var encodeStr = sha256.convert(bytes);
    return encodeStr.toString();
  }

  /// Base64加密
  static String encodeBase64(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  /// Base64解密
  static String decodeBase64(String data) {
    List<int> bytes = base64Decode(data);
    String result = utf8.decode(bytes);
    return result;
  }

  /// 异或对称加密
  static String xorCode(String res, String key) {
    List<String> keyList = key.split(",");
    List<int> codeUnits = res.codeUnits;
    List<int> codes = [];
    for (int i = 0, length = codeUnits.length; i < length; i++) {
      int code = codeUnits[i] ^ int.parse(keyList[i % keyList.length]);
      codes.add(code);
    }
    return String.fromCharCodes(codes);
  }

  /// 异或对称 Base64 加密
  static String xorBase64EnCode(String res, String key) {
    String encode = xorCode(res, key);
    encode = encodeBase64(encode);
    return encode;
  }

  /// 异或对称 Base64 解密
  static String xorBase64Decode(String res, String key) {
    String encode = decodeBase64(res);
    encode = xorCode(encode, key);
    return encode;
  }
}
