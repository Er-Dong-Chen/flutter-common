import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
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
        return ComLoading(message: text);
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
    Widget? content,
    String contentText = "",
    String cancelText = "取消",
    String confirmText = "确定",
    Widget? cancel,
    Widget? confirm,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    List<CupertinoDialogAction>? actions,
    bool showCancel = true,
    bool barrierDismissible = false,
  }) {
    Widget baseAlertDialog;
    // 判断当前平台
    bool isIOS = Theme.of(Get.context!).platform == TargetPlatform.iOS ||
        Theme.of(Get.context!).platform == TargetPlatform.macOS;

    if (!isIOS) {
      baseAlertDialog = AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        title: Center(
          child: title ?? Text("温馨提示".tr),
        ),
        titleTextStyle: Theme.of(Get.context!).textTheme.titleMedium,
        // titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(CommonStyle.roundedMd)),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: content ??
                  Text(
                    contentText,
                    textAlign: TextAlign.center,
                  ),
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
                  Visibility(
                    visible: showCancel,
                    child: Expanded(
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          child: Container(
                            height: double.infinity,
                            alignment: Alignment.center,
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16)),
                            ),
                            child: cancel ?? Text(cancelText.tr),
                          ),
                          onTap: () =>
                              onCancel != null ? onCancel.call() : Get.back(),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showCancel,
                    child: VerticalDivider(
                      thickness: 0.5,
                      width: 0,
                      color: Get.isDarkMode ? Colors.white : Colors.black12,
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(16),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        child: Container(
                          height: double.infinity,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(16)),
                          ),
                          child: confirm ?? Text(confirmText.tr),
                        ),
                        onTap: () =>
                            onConfirm != null ? onConfirm.call() : Get.back(),
                      ),
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
              if (showCancel) ...[
                CupertinoDialogAction(
                  onPressed: () =>
                      onCancel != null ? onCancel.call() : Get.back(),
                  child: cancel ?? Text('取消'.tr),
                ),
              ],
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
    Widget? title,
    Widget? content,
    Widget? cancel,
    Widget? confirm,
    String titleText = "温馨提示",
    String cancelText = "取消",
    String confirmText = "确定",
    EdgeInsets? titlePadding,
    EdgeInsets? contentPadding,
    EdgeInsets? actionPadding,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showTitle = true,
    bool showCancel = true,
    List<Widget>? actions,
    Widget? foot,
    bool showClose = false,
    bool barrierDismissible = false,
    TextDirection? actionTextDirection,
    double actionSpacing = 12.0,
  }) {
    ThemeData themeData = Theme.of(Get.context!);
    DialogThemeData dialogTheme = themeData.dialogTheme;

    Get.dialog(
      barrierDismissible: barrierDismissible,
      PopScope(
        canPop: barrierDismissible,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(CommonStyle.roundedMd),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showTitle) ...[
                    Padding(
                      padding: titlePadding ??
                          EdgeInsets.only(
                            left: 24.0,
                            top: 24.0,
                            right: 24.0,
                            bottom: content == null ? 20.0 : 0.0,
                          ),
                      child: DefaultTextStyle(
                        style: dialogTheme.titleTextStyle ??
                            themeData.textTheme.titleLarge!,
                        textAlign: TextAlign.center,
                        child: title ?? Text(titleText),
                      ),
                    ),
                  ],
                  if (content != null) ...[
                    Padding(
                      padding: contentPadding ??
                          const EdgeInsets.only(
                            left: 24.0,
                            top: 16.0,
                            right: 24.0,
                            bottom: 24.0,
                          ),
                      child: DefaultTextStyle(
                        style: dialogTheme.contentTextStyle ??
                            themeData.textTheme.bodyMedium!,
                        textAlign: TextAlign.center,
                        child: content,
                      ),
                    ),
                  ],
                  Padding(
                    padding: actionPadding ??
                        const EdgeInsets.only(
                          left: 24.0,
                          top: 0.0,
                          right: 24.0,
                          bottom: 24.0,
                        ),
                    child: OverflowBar(
                      spacing: actionSpacing,
                      overflowSpacing: actionSpacing / 2,
                      textDirection: actionTextDirection,
                      children: actions ??
                          [
                            LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                return ComButton(
                                  width:
                                      actionTextDirection == TextDirection.rtl
                                          ? constraints.maxWidth / 2 -
                                              actionSpacing / 2
                                          : constraints.maxWidth,
                                  gradient: CommonColors.primaryGradient,
                                  child: confirm ??
                                      Text(
                                        confirmText.tr,
                                        style: TextStyle(
                                            color: CommonColors.theme.shade900),
                                      ),
                                  onPressed: () => onConfirm != null
                                      ? onConfirm.call()
                                      : Get.back(),
                                );
                              },
                            ),
                            if (showCancel) ...[
                              LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  return ComButton(
                                    width:
                                        actionTextDirection == TextDirection.rtl
                                            ? constraints.maxWidth / 2 -
                                                actionSpacing / 2
                                            : constraints.maxWidth,
                                    plain: true,
                                    color: CommonColors.theme.shade700,
                                    child: cancel ?? Text(cancelText.tr),
                                    onPressed: () => onCancel != null
                                        ? onCancel.call()
                                        : Get.back(),
                                  );
                                },
                              ),
                            ]
                          ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: showClose,
              child: foot ??
                  Container(
                    margin: const EdgeInsets.only(top: 12),
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
      ),
    );
  }

  static showDatePicker({
    Function(DateTime date)? onConfirm,
    Function()? onCancel,
    Widget? cancel,
    Widget? confirm,
    bool useSafeArea = false,
    CupertinoDatePickerMode? mode,
    DateTime? initialDateTime,
    DateTime? minimumDate,
    DateTime? maximumDate,
    bool showDayOfWeek = false,
    bool use24hFormat = false,
    double itemExtent = 32.0,
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
                    onTap: onCancel ?? () => Get.back(),
                    child: cancel ??
                        Text(
                          "取消".tr,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onConfirm?.call(date);
                      Get.back();
                    },
                    child: confirm ??
                        Text(
                          "确定".tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: CommonColors.theme),
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: CupertinoDatePicker(
                  mode: mode ?? CupertinoDatePickerMode.date,
                  initialDateTime: initialDateTime,
                  minimumDate: minimumDate,
                  maximumDate: maximumDate,
                  showDayOfWeek: showDayOfWeek,
                  use24hFormat: use24hFormat,
                  itemExtent: itemExtent,
                  onDateTimeChanged: (DateTime newDate) {
                    date = newDate;
                  }),
            )
          ],
        ),
      ),
    );
  }

  static showPicker(
      {required List<Widget> children,
      Function(int selectIndex)? onConfirm,
      Function()? onCancel,
      Widget? cancel,
      Widget? confirm,
      bool useSafeArea = false,
      double itemExtent = 30,
      int initialItem = 0,
      Widget selectionOverlay =
          const CupertinoPickerDefaultSelectionOverlay()}) {
    int selectIndex = initialItem;
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
                    onTap: onCancel ?? () => Get.back(),
                    child: cancel ??
                        Text(
                          "取消".tr,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onConfirm?.call(selectIndex);
                      Get.back();
                    },
                    child: confirm ??
                        Text(
                          "确定".tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: CommonColors.theme),
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: CupertinoPicker(
                backgroundColor: Colors.transparent,
                itemExtent: itemExtent,
                onSelectedItemChanged: (int index) {
                  selectIndex = index;
                },
                selectionOverlay: selectionOverlay,
                scrollController:
                    FixedExtentScrollController(initialItem: initialItem),
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showModal(Widget content) {
    BotToast.showWidget(
      toastBuilder: (_) {
        return Material(
          color: Colors.black.withValues(alpha: 0.0),
          child: content,
        );
      },
      groupKey: "modal",
    );
  }

  static void closeModal() {
    BotToast.removeAll("modal");
  }
}
