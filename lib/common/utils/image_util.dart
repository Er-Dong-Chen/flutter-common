import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ImageUtil {
  /// 判断图片地址是否为有效的图片
  static Future<bool> isImageUrl(String imageUrl) async {
    try {
      // 使用 Dio 下载图片头部数据
      final dio = Dio();
      final response = await dio.get(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 400,
        ),
      );

      // 检查下载的数据是否为有效的图片
      final bytes = response.data as Uint8List;
      return isImageFromBytes(bytes);
    } catch (e) {
      // 处理异常情况
      debugPrint('Error checking image URL: $e');
      return false;
    }
  }

  /// 判断文件是否为图片
  static Future<bool> isImage(File file) async {
    try {
      // 读取文件头部数据
      final bytes = await file.readAsBytes();
      return isImageFromBytes(bytes);
    } catch (_) {
      return false;
    }
  }

  /// 从字节数组判断是否为图片
  static bool isImageFromBytes(Uint8List bytes) {
    // 检查文件头部标识
    if (bytes.length >= 2 &&
        ((bytes[0] == 0xFF && bytes[1] == 0xD8) || // JPEG
            (bytes[0] == 0x89 && bytes[1] == 0x50))) {
      // PNG
      return true;
    }
    return false;
  }

  /// 压缩图片数据
  static Future<Uint8List> compressImageBytes(Uint8List bytes,
      {int quality = 80}) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    final width = frameInfo.image.width;
    final height = frameInfo.image.height;
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..filterQuality = FilterQuality.high;
    canvas.drawImage(frameInfo.image, Offset.zero, paint);
    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(width, height);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List() ?? Uint8List(0);
  }

  /// 获取图片宽高
  static Future<Size> getImageSize(Object image) async {
    final Completer<Size> completer = Completer();

    late ImageProvider imageProvider;
    if (image is String) {
      // 网络图片
      imageProvider = NetworkImage(image);
    } else if (image is File) {
      // 文件图片
      imageProvider = FileImage(image);
    } else if (image is AssetImage) {
      // Asset 图片
      imageProvider = image;
    } else {
      throw ArgumentError('Unsupported image type');
    }

    imageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble()));
      }),
    );

    return completer.future;
  }

  /// 截取小部件的图片
  static Future<Uint8List> captureWidget(GlobalKey key) async {
    try {
      // 获取 RenderRepaintBoundary 对象
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary;

      // 渲染并转换为 Uint8List 数据
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List() ?? Uint8List(0);
    } catch (e) {
      // 处理异常情况
      debugPrint('Error capturing widget: $e');
      return Uint8List(0);
    }
  }

  /// 给图片字节数据添加文字水印
  static Future<Uint8List> addTextWatermarkToBytes(Uint8List bytes, String text,
      {Color color = Colors.white,
      double fontSize = 18,
      Offset offset = const Offset(10, 10)}) async {
    // 解码图片数据
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frame = await codec.getNextFrame();

    // 创建 Canvas 并绘制水印
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    canvas.drawImage(frame.image, Offset.zero, Paint());

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset);

    // 将 Canvas 转换为图片数据
    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(frame.image.width, frame.image.height);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List() ?? Uint8List(0);
  }
}
