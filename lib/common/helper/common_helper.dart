import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:flutter_chen_common/widgets/base/base_widget.dart';
import 'package:get/get.dart';

class CommonHelper {
  static showToast(text) {
    if (text == null || text.toString().isEmpty) return;
    BotToast.showText(
      text: text.toString(),
      align: Alignment.center,
      contentColor: Get.isDarkMode ? Colors.white : Colors.black54,
      textStyle:
          TextStyle(color: !Get.isDarkMode ? Colors.white : Colors.black54),
    );
  }

  static void showLoading({String? text}) {
    hideLoading();
    BotToast.showCustomLoading(toastBuilder: (context) {
      if (BaseWidget.loadingWidget is ComLoading) {
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.white : Colors.black54,
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              const ComLoading(),
              const SizedBox(height: 12),
              Text(
                text ?? "加载中...".tr,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 14,
                    color: !Get.isDarkMode ? Colors.white54 : Colors.black54),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        );
      } else {
        return BaseWidget.loadingWidget;
      }
    });
  }

  static void hideLoading() {
    BotToast.closeAllLoading();
  }

  static void showAlertDialog({
    Widget? title,
    required Widget content,
    Widget? cancel,
    Widget? confirm,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    List<CupertinoDialogAction>? actions,
    bool barrierDismissible = true,
    bool? isIOSStyle,
  }) {
    Widget baseAlertDialog;
    if ((isIOSStyle == null && Platform.isAndroid) ||
        (isIOSStyle != null && !isIOSStyle)) {
      baseAlertDialog = AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        title: title ??
            Center(
              child: Text("温馨提示".tr),
            ),
        titleTextStyle: Theme.of(Get.context!).textTheme.titleMedium,
        titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(CommonStyle.roundedMd)),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: content,
            ),
            Divider(
              thickness: 0.5,
              height: 0,
              color: Get.isDarkMode ? Colors.white : Colors.black12,
            ),
            SizedBox(
              height: 46,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Container(
                        height: double.infinity,
                        alignment: Alignment.center,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16)),
                        ),
                        child: cancel ?? Text("取消".tr),
                      ),
                      onTap: () =>
                          onCancel != null ? onCancel.call() : Get.back(),
                    ),
                  ),
                  VerticalDivider(
                    thickness: 0.5,
                    width: 0,
                    color: Get.isDarkMode ? Colors.white : Colors.black12,
                  ),
                  Expanded(
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Container(
                        height: double.infinity,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(16)),
                        ),
                        child: confirm ?? Text("确定".tr),
                      ),
                      onTap: () => onConfirm?.call(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      baseAlertDialog = CupertinoAlertDialog(
        title: title ??
            Center(
              child: Text("温馨提示".tr),
            ),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: content,
        ),
        actions: actions ??
            <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () =>
                    onCancel != null ? onCancel.call() : Get.back(),
                child: cancel ?? Text('取消'.tr),
              ),
              CupertinoDialogAction(
                onPressed: () => onConfirm?.call(),
                child: confirm ?? Text('确定'.tr),
              ),
            ],
      );
    }

    Get.dialog(
      baseAlertDialog,
      barrierDismissible: barrierDismissible,
    );
  }

  static void showActionSheet({
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    Widget? cancel,
    VoidCallback? onCancel,
    ValueChanged<int>? onConfirm,
  }) {
    actions = actions ?? [];
    List<CupertinoActionSheetAction> actionsList = [];
    for (int i = 0; i < actions.length; i++) {
      actionsList.add(
        CupertinoActionSheetAction(
          onPressed: () => onConfirm?.call(i),
          child: actions[i],
        ),
      );
    }

    Get.bottomSheet(
      CupertinoActionSheet(
        title: title,
        message: content,
        actions: actionsList,
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => onCancel != null ? onCancel.call() : Get.back(),
          child: cancel ?? Text('取消'.tr),
        ),
      ),
    );
  }

  static void showDialog({
    required Widget content,
    Widget? title,
    List<Widget>? actions,
    String? cancelText,
    String? confirmText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    MainAxisAlignment? actionsAlignment,
    bool close = false,
    Widget? foot,
    bool barrierDismissible = true,
  }) {
    Get.dialog(
      barrierDismissible: close ? false : barrierDismissible,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlertDialog(
            title: Center(child: title),
            titleTextStyle: Theme.of(Get.context!).textTheme.titleMedium,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(CommonStyle.roundedMd)),
            ),
            content: content,
            actions: actions ??
                <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: ComButton(
                          plain: true,
                          child: Text(cancelText ?? '取消'.tr),
                          onPressed: () =>
                              onCancel != null ? onCancel.call() : Get.back(),
                        ),
                      ),
                      SizedBox(width: CommonStyle.spaceMd),
                      Expanded(
                        child: ComButton(
                          gradient: CommonColors.primaryGradient,
                          child: Text(confirmText ?? '确定'.tr),
                          onPressed: () => onConfirm?.call(),
                        ),
                      ),
                    ],
                  )
                ],
            actionsAlignment: actionsAlignment ?? MainAxisAlignment.spaceAround,
          ),
          Visibility(
            visible: close,
            child: foot ??
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white60, // 边框颜色
                      width: 1.0, // 边框宽度
                    ),
                    borderRadius: BorderRadius.circular(CommonStyle.rounded),
                  ),
                  child: GestureDetector(
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.white60,
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
          )
        ],
      ),
    );
  }

  static showDatePicker({
    Function(DateTime date)? onConfirm,
    String? cancelText,
    String? confirmText,
    bool useSafeArea = false,
  }) {
    DateTime date = DateTime.now();
    showModalBottomSheet(
      context: Get.context!,
      useSafeArea: useSafeArea,
      builder: (BuildContext context) => SizedBox(
        height: 300,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: CommonStyle.spaceMd,
                  left: CommonStyle.spaceLg,
                  right: CommonStyle.spaceLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      cancelText ?? "取消".tr,
                      style: CommonStyle.titleStyle,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onConfirm?.call(date);
                      Get.back();
                    },
                    child: Text(
                      confirmText ?? "确定".tr,
                      style: CommonStyle.titleStyle
                          .copyWith(color: CommonColors.theme),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDate) {
                    date = newDate;
                  }),
            )
          ],
        ),
      ),
    );
  }

  static void showModal(Widget content) {
    BotToast.showWidget(
      toastBuilder: (_) {
        return content;
      },
      groupKey: "modal",
    );
  }

  static void closeModal() {
    BotToast.removeAll("modal");
  }
}
