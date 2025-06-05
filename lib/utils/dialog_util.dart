import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material show showDialog;
import 'package:flutter/material.dart' hide showDialog;
import 'package:flutter_chen_common/flutter_chen_common.dart';

/// 弹窗工具类
class DialogUtil {
  /// 常量定义
  static const double _defaultItemExtent = 36.0;
  static const double _defaultActionSpacing = 12.0;
  static const double _defaultDialogHeight = 300.0;
  static const double _defaultPickerHeight = 250.0;
  static const double _defaultModalHeight = 0.8;

  /// 显示Toast提示
  static void showToast(dynamic text) {
    if (text == null || text.toString().isEmpty) return;
    BotToast.showText(
      text: text.toString(),
      align: Alignment.center,
      contentColor: Theme.of(ComContext.context).colorScheme.inverseSurface,
      textStyle: TextStyle(
        color: Theme.of(ComContext.context).colorScheme.surfaceContainerHighest,
      ),
    );
  }

  /// 显示加载对话框
  static void showLoading({String? text}) {
    hideLoading();
    BotToast.showCustomLoading(
      toastBuilder: (context) {
        if (BaseWidget.loadingWidget is ComLoading) {
          return ComLoading(message: text);
        }
        return BaseWidget.loadingWidget(ComContext.context);
      },
    );
  }

  /// 隐藏加载对话框
  static void hideLoading() {
    BotToast.closeAllLoading();
  }

  /// 显示警告对话框
  static Future<T?> showAlertDialog<T>({
    Widget? title,
    Widget? content,
    String? cancelText,
    String? confirmText,
    Widget? cancel,
    Widget? confirm,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    List<CupertinoDialogAction>? actions,
    bool showCancel = true,
    bool barrierDismissible = false,
    bool? showIOS,
  }) async {
    final context = ComContext.context;
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS;

    final baseAlertDialog = isIOS || showIOS == true
        ? _buildIOSAlertDialog(
            context: context,
            title: title,
            content: content,
            cancel: cancel,
            confirm: confirm,
            onCancel: onCancel,
            onConfirm: onConfirm,
            actions: actions,
            showCancel: showCancel,
          )
        : _buildMaterialAlertDialog(
            context: context,
            title: title,
            content: content,
            cancel: cancel,
            confirm: confirm,
            onCancel: onCancel,
            onConfirm: onConfirm,
            showCancel: showCancel,
          );

    return await material.showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => baseAlertDialog,
    );
  }

  /// 构建iOS风格的警告对话框
  static Widget _buildIOSAlertDialog({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget? cancel,
    Widget? confirm,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    List<CupertinoDialogAction>? actions,
    bool showCancel = true,
  }) {
    return CupertinoAlertDialog(
      title: title ??
          Center(
            child: Text(ComLocalizations.of(context).warmTips),
          ),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: content,
      ),
      actions: actions ??
          <CupertinoDialogAction>[
            if (showCancel) ...[
              CupertinoDialogAction(
                onPressed: () {
                  if (onCancel != null) {
                    onCancel();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: cancel ?? Text(ComLocalizations.of(context).cancel),
              ),
            ],
            CupertinoDialogAction(
              onPressed: () {
                if (onConfirm != null) {
                  onConfirm();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: confirm ?? Text(ComLocalizations.of(context).confirm),
            ),
          ],
    );
  }

  /// 构建Material风格的警告对话框
  static Widget _buildMaterialAlertDialog({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget? cancel,
    Widget? confirm,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    bool showCancel = true,
  }) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: Center(
        child: title ?? Text(ComLocalizations.of(context).warmTips),
      ),
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.comTheme.shapes.resolvedDialogRadius),
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
            child: content,
          ),
          Divider(
            thickness: 0.5,
            height: 0,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black12,
          ),
          _buildDialogActions(
            context: context,
            cancel: cancel,
            confirm: confirm,
            onCancel: onCancel,
            onConfirm: onConfirm,
            showCancel: showCancel,
          ),
        ],
      ),
    );
  }

  /// 构建对话框操作按钮
  static Widget _buildDialogActions({
    required BuildContext context,
    Widget? cancel,
    Widget? confirm,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    bool showCancel = true,
  }) {
    return SizedBox(
      height: 46,
      width: double.infinity,
      child: Row(
        children: [
          if (showCancel) ...[
            Expanded(
              child: _buildActionButton(
                context: context,
                child: cancel ?? Text(ComLocalizations.of(context).cancel),
                onTap: () {
                  if (onCancel != null) {
                    onCancel();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                isLeft: true,
              ),
            ),
            VerticalDivider(
              thickness: 0.5,
              width: 0,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black12,
            ),
          ],
          Expanded(
            child: _buildActionButton(
              context: context,
              child: confirm ?? Text(ComLocalizations.of(context).confirm),
              onTap: () {
                if (onConfirm != null) {
                  onConfirm();
                } else {
                  Navigator.of(context).pop();
                }
              },
              isLeft: false,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  static Widget _buildActionButton({
    required BuildContext context,
    required Widget child,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.only(
        bottomLeft: isLeft ? const Radius.circular(16) : Radius.zero,
        bottomRight: !isLeft ? const Radius.circular(16) : Radius.zero,
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: isLeft ? const Radius.circular(16) : Radius.zero,
              bottomRight: !isLeft ? const Radius.circular(16) : Radius.zero,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  /// 显示底部操作表
  static Future<T?> showActionSheet<T>({
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    Widget? cancel,
    VoidCallback? onCancel,
    ValueChanged<int>? onConfirm,
  }) async {
    final context = ComContext.context;
    final actionsList = (actions ?? []).asMap().entries.map((entry) {
      return CupertinoActionSheetAction(
        onPressed: () {
          if (onConfirm != null) {
            onConfirm(entry.key);
          }
          Navigator.of(context).pop();
        },
        child: entry.value,
      );
    }).toList();

    return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CupertinoActionSheet(
        title: title,
        message: content,
        actions: actionsList,
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            if (onCancel != null) {
              onCancel();
            }
            Navigator.of(context).pop();
          },
          child: cancel ?? Text(ComLocalizations.of(context).cancel),
        ),
      ),
    );
  }

  /// 显示对话框
  static Future<T?> showDialog<T>({
    Widget? title,
    Widget? content,
    Widget? cancel,
    Widget? confirm,
    String? titleText,
    String? cancelText,
    String? confirmText,
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
    double actionSpacing = _defaultActionSpacing,
  }) async {
    final context = ComContext.context;
    final themeData = Theme.of(context);
    final dialogTheme = themeData.dialogTheme;

    return await material.showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => PopScope(
        canPop: barrierDismissible,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(context.comTheme.shapes.resolvedDialogRadius),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showTitle) ...[
                    _buildDialogTitle(
                      context: context,
                      title: title,
                      titleText: titleText,
                      titlePadding: titlePadding,
                      content: content,
                      dialogTheme: dialogTheme,
                      themeData: themeData,
                    ),
                  ],
                  if (content != null) ...[
                    _buildDialogContent(
                      context: context,
                      content: content,
                      contentPadding: contentPadding,
                      dialogTheme: dialogTheme,
                      themeData: themeData,
                    ),
                  ],
                  _buildDialogFooter(
                    context: context,
                    cancel: cancel,
                    confirm: confirm,
                    onConfirm: onConfirm,
                    onCancel: onCancel,
                    showCancel: showCancel,
                    actions: actions,
                    actionPadding: actionPadding,
                    actionTextDirection: actionTextDirection,
                    actionSpacing: actionSpacing,
                  ),
                ],
              ),
            ),
            if (showClose) ...[
              _buildCloseButton(context: context, foot: foot),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建对话框标题
  static Widget _buildDialogTitle({
    required BuildContext context,
    Widget? title,
    String? titleText,
    EdgeInsets? titlePadding,
    Widget? content,
    required DialogThemeData dialogTheme,
    required ThemeData themeData,
  }) {
    return Padding(
      padding: titlePadding ??
          EdgeInsets.only(
            left: 24.0,
            top: 24.0,
            right: 24.0,
            bottom: content == null ? 20.0 : 0.0,
          ),
      child: DefaultTextStyle(
        style: dialogTheme.titleTextStyle ?? themeData.textTheme.titleLarge!,
        textAlign: TextAlign.center,
        child:
            title ?? Text(titleText ?? ComLocalizations.of(context).warmTips),
      ),
    );
  }

  /// 构建对话框内容
  static Widget _buildDialogContent({
    required BuildContext context,
    required Widget content,
    EdgeInsets? contentPadding,
    required DialogThemeData dialogTheme,
    required ThemeData themeData,
  }) {
    return Padding(
      padding: contentPadding ??
          const EdgeInsets.only(
            left: 24.0,
            top: 16.0,
            right: 24.0,
            bottom: 24.0,
          ),
      child: DefaultTextStyle(
        style: dialogTheme.contentTextStyle ?? themeData.textTheme.bodyMedium!,
        textAlign: TextAlign.center,
        child: content,
      ),
    );
  }

  /// 构建对话框底部
  static Widget _buildDialogFooter({
    required BuildContext context,
    Widget? cancel,
    Widget? confirm,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showCancel = true,
    List<Widget>? actions,
    EdgeInsets? actionPadding,
    TextDirection? actionTextDirection,
    double actionSpacing = _defaultActionSpacing,
  }) {
    return Padding(
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
              _buildFooterButton(
                context: context,
                isConfirm: true,
                child: confirm,
                onPressed: onConfirm,
              ),
              if (showCancel) ...[
                _buildFooterButton(
                  context: context,
                  isConfirm: false,
                  child: cancel,
                  onPressed: onCancel,
                ),
              ],
            ],
      ),
    );
  }

  /// 构建底部按钮
  static Widget _buildFooterButton({
    required BuildContext context,
    required bool isConfirm,
    Widget? child,
    VoidCallback? onPressed,
  }) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ComButton(
          width: constraints.maxWidth,
          plain: !isConfirm,
          color: isConfirm ? null : Theme.of(context).colorScheme.onSurface,
          child: child ??
              Text(
                isConfirm
                    ? ComLocalizations.of(context).confirm
                    : ComLocalizations.of(context).cancel,
              ),
          onPressed: () {
            if (onPressed != null) {
              onPressed();
            } else {
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  /// 构建关闭按钮
  static Widget _buildCloseButton({
    required BuildContext context,
    Widget? foot,
  }) {
    return foot ??
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white60,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(
              context.comTheme.shapes.circularRadius,
            ),
          ),
          child: GestureDetector(
            child: const Icon(
              Icons.close,
              size: 20,
              color: Colors.white60,
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
        );
  }

  /// 显示底部模态框
  static Future<T?> showModalBottom<T>({
    required Widget child,
    Widget? title,
    Widget? leading,
    List<Widget>? actions,
    Widget? bottom,
    EdgeInsetsGeometry? padding,
    double? minHeight,
    bool showTitle = true,
    bool isScrollControlled = true,
    bool useSafeArea = true,
  }) async {
    final context = ComContext.context;
    final boxConstraints =
        minHeight != null ? BoxConstraints(minHeight: minHeight) : null;

    return await showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      constraints: boxConstraints,
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showTitle)
              ComTitleBar(
                title: title,
                leading: leading,
                actions: actions,
              ),
            if (bottom != null) bottom,
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(context).size.height * _defaultModalHeight,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom +
                      MediaQuery.of(context).viewInsets.bottom,
                ),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }

  /// 显示日期选择器
  static Future<T?> showDatePicker<T>({
    ValueChanged<DateTime>? onConfirm,
    VoidCallback? onCancel,
    Widget? cancel,
    Widget? confirm,
    bool useSafeArea = false,
    CupertinoDatePickerMode? mode,
    DateTime? initialDateTime,
    DateTime? minimumDate,
    DateTime? maximumDate,
    bool showDayOfWeek = false,
    bool use24hFormat = false,
    double itemExtent = _defaultItemExtent,
  }) async {
    final context = ComContext.context;
    DateTime date = initialDateTime ?? DateTime.now();

    return await showModalBottomSheet(
      context: context,
      useSafeArea: useSafeArea,
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      builder: (BuildContext context) => SizedBox(
        height: _defaultDialogHeight,
        child: Column(
          children: [
            _buildPickerHeader(
              context: context,
              cancel: cancel,
              confirm: confirm,
              onCancel: onCancel,
              onConfirm: () {
                if (onConfirm != null) {
                  onConfirm.call(date);
                }
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              height: _defaultPickerHeight,
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示选择器
  static Future<T?> showPicker<T>({
    required List<Widget> children,
    ValueChanged<int>? onConfirm,
    VoidCallback? onCancel,
    Widget? cancel,
    Widget? confirm,
    bool useSafeArea = false,
    double itemExtent = _defaultItemExtent,
    int initialItem = 0,
    Widget selectionOverlay = const CupertinoPickerDefaultSelectionOverlay(),
  }) async {
    final context = ComContext.context;
    int selectIndex = initialItem;

    return await showModalBottomSheet(
      context: context,
      useSafeArea: useSafeArea,
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      builder: (BuildContext context) => SizedBox(
        height: _defaultDialogHeight,
        child: Column(
          children: [
            _buildPickerHeader(
              context: context,
              cancel: cancel,
              confirm: confirm,
              onCancel: onCancel,
              onConfirm: () {
                if (onConfirm != null) {
                  onConfirm(selectIndex);
                }
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              height: _defaultPickerHeight,
              child: CupertinoPicker(
                backgroundColor: Colors.transparent,
                itemExtent: itemExtent,
                onSelectedItemChanged: (int index) {
                  selectIndex = index;
                },
                selectionOverlay: selectionOverlay,
                scrollController: FixedExtentScrollController(
                  initialItem: initialItem,
                ),
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建选择器头部
  static Widget _buildPickerHeader({
    required BuildContext context,
    Widget? cancel,
    Widget? confirm,
    VoidCallback? onCancel,
    required VoidCallback onConfirm,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.comTheme.spacing.medium,
        left: context.comTheme.spacing.large,
        right: context.comTheme.spacing.large,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (onCancel != null) {
                onCancel();
              }
              Navigator.of(context).pop();
            },
            child: cancel ??
                Text(
                  ComLocalizations.of(context).cancel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
          ),
          GestureDetector(
            onTap: onConfirm,
            child: confirm ??
                Text(
                  ComLocalizations.of(context).confirm,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
          ),
        ],
      ),
    );
  }
}
