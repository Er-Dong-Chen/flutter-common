import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:flutter_chen_common/widgets/base/com_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  static void showLoading({String text = "Loading..."}) {
    hideLoading();
    BotToast.showCustomLoading(toastBuilder: (context) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.white : Colors.black54,
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                  !Get.isDarkMode ? Colors.white : Colors.black54),
            ),
            const SizedBox(height: 12),
            Text(
              text,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 15,
                  color: !Get.isDarkMode ? Colors.white : Colors.black54),
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
    Widget? confirm,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    List<CupertinoDialogAction>? actions,
    bool barrierDismissible = true,
  }) {
    Widget baseAlertDialog = CupertinoAlertDialog(
      title: title ??
          const Center(
            child: Text("Tips"),
          ),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: content,
      ),
      actions: actions ??
          <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () => onCancel != null ? onCancel.call() : Get.back(),
              child: cancel ?? const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () => onConfirm?.call(),
              child: confirm ?? const Text('Confirm'),
            ),
          ],
    );

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
          child: cancel ?? const Text('Cancel'),
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
    MainAxisAlignment? actionsAlignment,
    bool close = false,
    bool barrierDismissible = true,
  }) {
    Get.dialog(
      barrierDismissible: barrierDismissible,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlertDialog(
            title: Center(child: title),
            titleTextStyle: Theme.of(Get.context!).textTheme.titleMedium,
            content: content,
            actions: actions ??
                <Widget>[
                  SizedBox(
                    width: 100.w,
                    child: ComButton(
                      plain: true,
                      child: Text(cancelText ?? 'Cancel'),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 100.w,
                    child: ComButton(
                      gradient: CommonColors.primaryGradient,
                      child: Text(cancelText ?? 'Confirm'),
                      onPressed: () {
                        onConfirm?.call();
                      },
                    ),
                  ),
                ],
            actionsAlignment: actionsAlignment ?? MainAxisAlignment.spaceAround,
          ),
          Visibility(
            visible: close,
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: const Icon(
                Icons.cancel_outlined,
                size: 36,
                color: Colors.white60,
              ),
              onPressed: () {
                Navigator.pop(Get.context!);
              },
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
      groupKey: "modal",
    );
  }

  static void closeModal() {
    BotToast.removeAll("modal");
  }
}
