import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 全局禁止空格输入的格式化器
class NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String filteredText = newValue.text.replaceAll(' ', '');

    // 保持光标位置合理
    int selectionIndex = newValue.selection.end;
    final originalLength = newValue.text.length;
    final filteredLength = filteredText.length;
    final removedSpaces = originalLength - filteredLength;

    // 调整光标位置
    selectionIndex = (selectionIndex - removedSpaces).clamp(0, filteredLength);

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

/// 自定义文本输入框组件
///
/// 特性：
/// - 全局禁止空格输入
/// - 支持所有 TextField 属性
/// - 提供便捷的样式配置
/// - 内置常用验证和格式化
/// - 优雅的 API 设计
class ComTextField extends StatelessWidget {
  // ==================== 核心属性 ====================
  /// 文本控制器
  final TextEditingController? controller;

  /// 焦点节点
  final FocusNode? focusNode;

  /// 初始值（如果不使用 controller）
  final String? initialValue;

  // ==================== 输入配置 ====================
  /// 键盘类型
  final TextInputType? keyboardType;

  /// 文本输入动作
  final TextInputAction? textInputAction;

  /// 大小写模式
  final TextCapitalization textCapitalization;

  /// 是否自动获取焦点
  final bool autofocus;

  /// 是否只读
  final bool readOnly;

  /// 是否启用
  final bool? enabled;

  /// 是否密码输入
  final bool obscureText;

  /// 密码遮挡字符
  final String obscuringCharacter;

  /// 是否自动纠错
  final bool autocorrect;

  /// 是否启用建议
  final bool enableSuggestions;

  /// 智能破折号类型
  final SmartDashesType? smartDashesType;

  /// 智能引号类型
  final SmartQuotesType? smartQuotesType;

  // ==================== 文本样式 ====================
  /// 文本样式
  final TextStyle? style;

  /// 支撑样式
  final StrutStyle? strutStyle;

  /// 文本对齐方式
  final TextAlign textAlign;

  /// 垂直对齐方式
  final TextAlignVertical? textAlignVertical;

  /// 文本方向
  final TextDirection? textDirection;

  // ==================== 多行配置 ====================
  /// 最大行数
  final int? maxLines;

  /// 最小行数
  final int? minLines;

  /// 是否扩展填充
  final bool expands;

  /// 最大长度
  final int? maxLength;

  /// 长度限制策略
  final MaxLengthEnforcement? maxLengthEnforcement;

  // ==================== 光标样式 ====================
  /// 是否显示光标
  final bool? showCursor;

  /// 光标宽度
  final double cursorWidth;

  /// 光标高度
  final double? cursorHeight;

  /// 光标圆角
  final Radius? cursorRadius;

  /// 光标颜色
  final Color? cursorColor;

  /// 键盘外观
  final Brightness? keyboardAppearance;

  // ==================== 交互配置 ====================
  /// 滚动边距
  final EdgeInsets scrollPadding;

  /// 拖拽开始行为
  final DragStartBehavior dragStartBehavior;

  /// 是否启用交互式选择
  final bool? enableInteractiveSelection;

  /// 选择控件
  final TextSelectionControls? selectionControls;

  /// 鼠标光标
  final MouseCursor? mouseCursor;

  /// 滚动控制器
  final ScrollController? scrollController;

  /// 滚动物理效果
  final ScrollPhysics? scrollPhysics;

  /// 裁剪行为
  final Clip clipBehavior;

  /// 恢复ID
  final String? restorationId;

  /// 是否启用涂鸦
  final bool scribbleEnabled;

  /// 是否启用IME个性化学习
  final bool enableIMEPersonalizedLearning;

  // ==================== 自动填充 ====================
  /// 自动填充提示
  final Iterable<String>? autofillHints;

  // ==================== 格式化器 ====================
  /// 额外的输入格式化器（会在 NoSpaceFormatter 之后应用）
  final List<TextInputFormatter>? inputFormatters;

  /// 是否禁用全局的禁止空格功能
  final bool allowSpaces;

  // ==================== 回调函数 ====================
  /// 文本变化回调
  final ValueChanged<String>? onChanged;

  /// 编辑完成回调
  final VoidCallback? onEditingComplete;

  /// 提交回调
  final ValueChanged<String>? onSubmitted;

  /// 点击回调
  final GestureTapCallback? onTap;

  /// 长按回调
  final GestureLongPressCallback? onLongPress;

  /// 应用私有命令回调
  final AppPrivateCommandCallback? onAppPrivateCommand;

  // ==================== 装饰配置 ====================
  /// 输入装饰
  final InputDecoration? decoration;

  /// 计数器构建器
  final InputCounterWidgetBuilder? buildCounter;

  // ==================== 便捷装饰属性 ====================
  /// 提示文本
  final String? hintText;

  /// 标签文本
  final String? labelText;

  /// 错误文本
  final String? errorText;

  /// 帮助文本
  final String? helperText;

  /// 前缀图标
  final Widget? prefixIcon;

  /// 后缀图标
  final Widget? suffixIcon;

  /// 前缀组件
  final Widget? prefix;

  /// 后缀组件
  final Widget? suffix;

  /// 前缀文本
  final String? prefixText;

  /// 后缀文本
  final String? suffixText;

  /// 前缀文本样式
  final TextStyle? prefixStyle;

  /// 后缀文本样式
  final TextStyle? suffixStyle;

  /// 是否填充
  final bool? filled;

  /// 填充颜色
  final Color? fillColor;

  /// 内容边距
  final EdgeInsetsGeometry? contentPadding;

  /// 是否密集布局
  final bool? isDense;

  /// 边框
  final InputBorder? border;

  /// 启用时边框
  final InputBorder? enabledBorder;

  /// 聚焦时边框
  final InputBorder? focusedBorder;

  /// 错误时边框
  final InputBorder? errorBorder;

  /// 禁用时边框
  final InputBorder? disabledBorder;

  /// 聚焦错误时边框
  final InputBorder? focusedErrorBorder;

  /// 语义化计数器文本
  final String? semanticCounterText;

  /// 是否对齐标签与提示
  final bool? alignLabelWithHint;

  const ComTextField({
    super.key,
    // 核心属性
    this.controller,
    this.focusNode,
    this.initialValue,

    // 输入配置
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.readOnly = false,
    this.enabled,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.smartDashesType,
    this.smartQuotesType,

    // 文本样式
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,

    // 多行配置
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,

    // 光标样式
    this.showCursor,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,

    // 交互配置
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.mouseCursor,
    this.scrollController,
    this.scrollPhysics,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scribbleEnabled = true,
    this.enableIMEPersonalizedLearning = true,

    // 自动填充
    this.autofillHints,

    // 格式化器
    this.inputFormatters,
    this.allowSpaces = false,

    // 回调函数
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.onLongPress,
    this.onAppPrivateCommand,

    // 装饰配置
    this.decoration,
    this.buildCounter,

    // 便捷装饰属性
    this.hintText,
    this.labelText,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.prefixText,
    this.suffixText,
    this.prefixStyle,
    this.suffixStyle,
    this.filled,
    this.fillColor,
    this.contentPadding,
    this.isDense,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
    this.focusedErrorBorder,
    this.semanticCounterText,
    this.alignLabelWithHint,
  });

  @override
  Widget build(BuildContext context) {
    // 构建输入格式化器列表
    List<TextInputFormatter> formatters = [];

    // 如果不允许空格，添加 NoSpaceFormatter
    if (!allowSpaces) {
      formatters.add(NoSpaceFormatter());
    }

    // 添加额外的格式化器
    if (inputFormatters != null) {
      formatters.addAll(inputFormatters!);
    }

    // 构建输入装饰
    InputDecoration finalDecoration = decoration ??
        InputDecoration(
          hintText: hintText,
          labelText: labelText,
          errorText: errorText,
          helperText: helperText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          prefix: prefix,
          suffix: suffix,
          prefixText: prefixText,
          suffixText: suffixText,
          prefixStyle: prefixStyle,
          suffixStyle: suffixStyle,
          filled: filled,
          fillColor: fillColor,
          contentPadding: contentPadding,
          isDense: isDense,
          border: border,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          errorBorder: errorBorder,
          disabledBorder: disabledBorder,
          focusedErrorBorder: focusedErrorBorder,
          semanticCounterText: semanticCounterText,
          alignLabelWithHint: alignLabelWithHint,
        );

    return TextFormField(
      // 核心属性
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,

      // 输入配置
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      autofocus: autofocus,
      readOnly: readOnly,
      enabled: enabled,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,

      // 文本样式
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textDirection: textDirection,

      // 多行配置
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,

      // 光标样式
      showCursor: showCursor,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      keyboardAppearance: keyboardAppearance,

      // 交互配置
      scrollPadding: scrollPadding,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      mouseCursor: mouseCursor,
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      scribbleEnabled: scribbleEnabled,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,

      // 自动填充
      autofillHints: autofillHints,

      // 格式化器
      inputFormatters: formatters.isEmpty ? null : formatters,

      // 回调函数
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,

      // 装饰配置
      decoration: finalDecoration,
      buildCounter: buildCounter,
    );
  }
}

// ==================== 便捷工厂构造函数 ====================
extension ComTextFieldFactories on ComTextField {
  /// 创建用户名输入框
  static ComTextField username({
    TextEditingController? controller,
    String? hintText = '请输入用户名',
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return ComTextField(
      controller: controller,
      hintText: hintText,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
        LengthLimitingTextInputFormatter(20),
      ],
    );
  }

  /// 创建密码输入框
  static Widget password({
    TextEditingController? controller,
    String? hintText = '请输入密码',
    ValueChanged<String>? onChanged,
    bool showToggle = true,
  }) {
    return _PasswordTextField(
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      showToggle: showToggle,
    );
  }

  /// 创建手机号输入框
  static ComTextField phone({
    TextEditingController? controller,
    String? hintText = '请输入手机号',
    ValueChanged<String>? onChanged,
  }) {
    return ComTextField(
      controller: controller,
      hintText: hintText,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      maxLength: 11,
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  /// 创建邮箱输入框
  static ComTextField email({
    TextEditingController? controller,
    String? hintText = '请输入邮箱',
    ValueChanged<String>? onChanged,
  }) {
    return ComTextField(
      controller: controller,
      hintText: hintText,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      allowSpaces: false, // 邮箱不允许空格
    );
  }

  /// 创建数字输入框
  static ComTextField number({
    TextEditingController? controller,
    String? hintText = '请输入数字',
    ValueChanged<String>? onChanged,
    bool allowDecimal = false,
    int? maxLength,
  }) {
    return ComTextField(
      controller: controller,
      hintText: hintText,
      keyboardType: allowDecimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      textInputAction: TextInputAction.done,
      maxLength: maxLength,
      onChanged: onChanged,
      inputFormatters: [
        if (allowDecimal)
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  /// 创建搜索输入框
  static Widget search({
    TextEditingController? controller,
    String? hintText = '搜索...',
    ValueChanged<String>? onChanged,
    VoidCallback? onClear,
  }) {
    return _SearchTextField(
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      onClear: onClear,
    );
  }

  /// 创建多行文本输入框
  static ComTextField multiline({
    TextEditingController? controller,
    String? hintText = '请输入内容',
    ValueChanged<String>? onChanged,
    int maxLines = 3,
    int? maxLength,
  }) {
    return ComTextField(
      controller: controller,
      hintText: hintText,
      maxLines: maxLines,
      maxLength: maxLength,
      textInputAction: TextInputAction.newline,
      onChanged: onChanged,
      allowSpaces: true, // 多行文本允许空格
    );
  }
}

// ==================== 特殊组件实现 ====================

/// 密码输入框（带显示/隐藏切换）
class _PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool showToggle;

  const _PasswordTextField({
    this.controller,
    this.hintText,
    this.onChanged,
    this.showToggle = true,
  });

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return ComTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      onChanged: widget.onChanged,
      suffixIcon: widget.showToggle
          ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).hintColor,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
          : null,
    );
  }
}

/// 搜索输入框（带清除按钮）
class _SearchTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const _SearchTextField({
    this.controller,
    this.hintText,
    this.onChanged,
    this.onClear,
  });

  @override
  State<_SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<_SearchTextField> {
  late TextEditingController _controller;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _showClear = _controller.text.isNotEmpty;
  }

  void _onTextChanged() {
    setState(() {
      _showClear = _controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ComTextField(
      controller: _controller,
      hintText: widget.hintText,
      textInputAction: TextInputAction.search,
      onChanged: widget.onChanged,
      prefixIcon: const Icon(Icons.search),
      suffixIcon: _showClear
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                widget.onChanged?.call('');
                widget.onClear?.call();
              },
            )
          : null,
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}
