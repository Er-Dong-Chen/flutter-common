import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommonHelper {
  static showToast(text) {
    if (text == null || text.toString().isEmpty) return;
    BotToast.showText(
      text: text.toString(),
      align: Alignment.center,
    );
  }

  static void showLoading() {
    hideLoading();
    BotToast.showCustomLoading(toastBuilder: (context) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 4),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
            SizedBox(height: 12),
            Text(
              "Loading...",
              maxLines: 1,
              style: TextStyle(fontSize: 15, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      );
    });
  }

  static void hideLoading() {
    BotToast.closeAllLoading();
  }

  static void showAlertDialog({
    Widget? title,
    required Widget content,
    Widget? cancel,
    Widget? conform,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    Get.dialog(CupertinoAlertDialog(
      title: title ??
          const Center(
            child: Text("System Tips"),
          ),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: content,
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: () => onCancel != null ? onCancel.call() : Get.back(),
          child: cancel ?? const Text('Cancel'),
        ),
        CupertinoDialogAction(
          onPressed: () => onConfirm?.call(),
          child: conform ?? const Text('Conform'),
        ),
      ],
    ));
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
          child: cancel ?? const Text('Cancel'),
        ),
      ),
    );
  }

  static showDatePicker(
      {Function(DateTime date)? onConfirm,
      String? cancelText,
      String? confirmText,
      bool useSafeArea = false}) {
    DateTime date = DateTime.now();
    showModalBottomSheet(
      context: Get.context!,
      useSafeArea: useSafeArea,
      builder: (BuildContext context) => SizedBox(
        height: 300.h,
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
                      cancelText ?? "Cancel",
                      style: CommonStyle.titleStyle,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onConfirm?.call(date);
                      Get.back();
                    },
                    child: Text(
                      confirmText ?? "Confirm",
                      style: CommonStyle.titleStyle
                          .copyWith(color: CommonColors.theme),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250.h,
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
        groupKey: "modal");
  }

  static void closeModal() {
    BotToast.removeAll("modal");
  }
}
