import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';

import '../../request/request.dart';

class OssHelper {
  static String accessKeyId = 'ossAccessKeyId';
  static String accessKeySecret = 'ossAccessKeySecret';
  static String bucket = 'bucketName';

  /// 发送请求的url,根据你自己设置的是哪个城市的
  static String url = 'https://$bucket.oss-ap-southeast-1.aliyuncs.com';
  static String expiration = '2050-01-01T12:00:00.000Z';

  /// @params file 要上传的文件对象
  /// @param callback 回调函数用于传cancelToken，方便后期关闭请求
  /// @param onSendProgress 上传的进度事件
  static Future<String> upload(
      {required File file,
      Function? cancelToken,
      Function? onSendProgress}) async {
    final res = await ComConfig.getOssConfig();
    // String policyText = '{"expiration": "$expiration","conditions": [{"bucket": "$bucket" },["content-length-range", 0, 1048576000]]}';
    /// 获取签名
    // String signature = getSignature(policyText);

    /// 生成oss的路径和文件名目前设置的是images/20201229/test.mp4
    String pathName =
        '${res["dir"] ?? "images"}/${getDate()}/${getRandom(12)}.${getFileType(file.path)}';

    /// 请求参数的form对象
    FormData data = FormData.fromMap({
      'key': pathName,
      'policy': res["policy"],
      // 'policy': getPolicyBase64(policyText),
      'OSSAccessKeyId': res["accessKeyId"],
      // 'OSSAccessKeyId': accessKeyId,
      'success_action_status': '200', //让服务端返回200，不然，默认会返回204
      'signature': res["signature"],
      // 'signature': signature,
      'contentType': 'multipart/form-data',
      'file': MultipartFile.fromFileSync(file.path),
    });

    try {
      await RequestClient.instance.request(
        res["url"],
        baseUrl: "",
        method: HttpMethod.post.name,
        data: data,
        options: Options(
          extra: {
            "custom": true,
          },
        ),
      );

      return '${res["url"]}/$pathName';
    } catch (e) {
      throw (e.toString());
    }
  }

  /// 生成固定长度的随机字符串
  static String getRandom(int num) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < num; i++) {
      // right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  /// 根据图片本地路径获取图片名称
  static String? getImageNameByPath(String filePath) {
    /// ignore: null_aware_before_operator
    return filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
  }

  /// 获取文件类型
  static String getFileType(String path) {
    List<String> array = path.split('.');
    return array[array.length - 1];
  }

  /// 获取日期
  static String getDate() {
    DateTime now = DateTime.now();
    return '${now.year}${now.month}${now.day}/${now.millisecondsSinceEpoch}';
  }

  /// 获取police的base64
  static getPolicyBase64(String policyText) {
    //进行utf8编码
    List<int> policyUtf8 = utf8.encode(policyText);
    //进行base64编码
    String policyBase64 = base64.encode(policyUtf8);
    return policyBase64;
  }

  /// 获取签名
  static String getSignature(String policyText) {
    //进行utf8编码
    List<int> policyUtf8 = utf8.encode(policyText);
    //进行base64编码
    String policyBase64 = base64.encode(policyUtf8);
    //再次进行utf8编码
    List<int> policy = utf8.encode(policyBase64);
    //进行utf8 编码
    List<int> key = utf8.encode(accessKeySecret);
    //通过hmac,使用sha1进行加密
    List<int> signaturePre = Hmac(sha1, key).convert(policy).bytes;
    //最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signaturePre);
    return signature;
  }
}
