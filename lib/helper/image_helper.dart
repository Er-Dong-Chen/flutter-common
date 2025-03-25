import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chen_common/extension/theme_context_extension.dart';
import 'package:flutter_chen_common/helper/oss_helper.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dialog_helper.dart';

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

  // 选择图片Action
  static Future showActionSheet(ValueChanged<String> callBack,
      {bool crop = false, List<Widget>? actions, Widget? cancel}) async {
    DialogHelper.showActionSheet(
        actions: actions ?? [Text("相册选择".tr), Text("拍摄照片".tr)],
        cancel: cancel,
        onConfirm: (val) async {
          Get.back();
          List<Permission> permissionList = [
            Permission.photos,
            Permission.camera
          ];

          dynamic img;
          try {
            if (val == 0) {
              img = await pickImage(source: ImageSource.gallery, crop: crop);
            } else {
              img = await pickImage(source: ImageSource.camera, crop: crop);
            }
          } catch (e) {
            await (permissionList[val]).status;
            DialogHelper.showAlertDialog(
                content: Text(
                  '请在App权限管理中开启${val == 0 ? '相册' : '相机'}权限\n以便上传头像'.tr,
                  textAlign: TextAlign.center,
                ),
                confirm: const Text('去开启'),
                cancel: const Text('暂不开启'),
                onConfirm: () {
                  openAppSettings();
                  Get.back();
                });
            return;
          }
          if (img != null) {
            callBack.call(img);
          } else {
            DialogHelper.showToast("上传失败".tr);
          }
        });
  }

  // 图片裁剪
  static Future cropImage(imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: '',
            // toolbarTitle: 'Cropper',
            toolbarColor: Get.context!.comTheme.theme,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            // aspectRatioPresets: [
            //   CropAspectRatioPreset.original,
            //   CropAspectRatioPreset.square,
            // ],
            lockAspectRatio: false),
        IOSUiSettings(
          title: '', doneButtonTitle: "确定", cancelButtonTitle: "取消",
          // title: 'Cropper',
          // aspectRatioPresets: [
          //   CropAspectRatioPreset.original,
          //   CropAspectRatioPreset.square,
          // ],
        ),
        WebUiSettings(
          context: Get.context!,
        ),
      ],
    );
    var res = await OssHelper.upload(file: File(croppedFile!.path));
    return res;
  }

// // 保存图片
// static Future<bool> saveImage(filePath) async {
//   final isPermission =
//       await PermissionUtil.checkPermission([Permission.storage]);
//   if (!isPermission) {
//     DialogHelper.showToast('请开启相关权限'.tr);
//     return false;
//   }
//   final result = await ImageGallerySaver.saveFile(filePath);
//   if (!result) {
//     DialogHelper.showToast("保存失败".tr);
//     return false;
//   }
//   DialogHelper.showToast("保存成功".tr);
//   return true;
// }
}
