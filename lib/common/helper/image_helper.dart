import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/helper/oss_helper.dart';
import 'package:flutter_chen_common/common/helper/permission_helper.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'common_helper.dart';

class ImageHelper {
  // 选取多图
  static Future<List<String>?> pickMultiImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      List<String> images = [];
      for (var file in pickedFiles) {
        var img = await OssHelper.upload(file: File(file.path));
        images.add(img);
      }
      return images;
    }
    return null;
  }

  // 选取单图
  static Future<String> pickImage(
      {required ImageSource source, bool crop = false}) async {
    final ImagePicker picker = ImagePicker();
    var img = await picker.pickImage(
        source: source, maxWidth: 1080, imageQuality: 95);
    return await uploadImage(img, crop: crop);
  }

  // 多图上传
  static Future<List<String>> uploadMultiImage(pickedFiles) async {
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      List<String> images = [];
      for (var file in pickedFiles) {
        var img = await OssHelper.upload(file: File(file.path));
        images.add(img);
      }
      return images;
    }
    return [];
  }

  // 单图上传
  static Future<String> uploadImage(pickedFile, {bool crop = false}) async {
    if (pickedFile == null) {
      return '';
    }
    if (crop) {
      var cropImg = await cropImage(pickedFile);
      return cropImg;
    } else {
      var image = await OssHelper.upload(file: File(pickedFile.path));
      return image;
    }
  }

  // 保存图片
  static Future<bool> saveImage(filePath) async {
    final isPermission =
        await PermissionHelper.checkPermission([Permission.storage]);
    if (!isPermission) {
      CommonHelper.showToast("Please enable related permissions");
      return false;
    }
    final result = await ImageGallerySaver.saveFile(filePath);
    if (!result) {
      CommonHelper.showToast("Save fail");
      return false;
    }
    CommonHelper.showToast("Save success");
    return true;
  }

  // 选择图片Action
  static Future showActionSheet(ValueChanged<String> callBack,
      {bool crop = false, List<Widget>? actions, Widget? cancel}) async {
    CommonHelper.showActionSheet(
        actions: actions ?? [const Text("相册选择"), const Text("拍摄照片")],
        cancel: cancel,
        onConfirm: (val) async {
          List<Permission> permissionList = [
            Permission.storage,
            Permission.camera
          ];
          final permissions =
              await PermissionHelper.checkPermission([permissionList[val]]);
          if (!permissions) {
            return CommonHelper.showToast('Please enable related permissions');
          }
          dynamic img;
          if (val == 0) {
            img = await pickImage(source: ImageSource.gallery, crop: crop);
          } else {
            img = await pickImage(source: ImageSource.camera, crop: crop);
          }
          Get.back();
          if (img != null) {
            callBack.call(img);
          } else {
            CommonHelper.showToast("fail");
          }
        });
  }

  // 图片裁剪
  static Future cropImage(imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: CommonColors.theme,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        // WebUiSettings(
        //   context: context,
        // ),
      ],
    );
    var res = await OssHelper.upload(file: File(croppedFile!.path));
    return res;
  }
}
