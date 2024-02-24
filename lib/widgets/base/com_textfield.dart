import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:flutter_chen_common/common/utils/function_util.dart';

class ComTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final int? maxLines;
  final int? minLines;
  final bool? expands;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final Function()? onEditingComplete;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final double? radius;
  final Color? color;
  final EdgeInsets? padding;
  final FocusNode? focusNode;
  final bool? autoFocus;
  final BoxDecoration? boxDecoration;
  final InputDecoration? inputDecoration;

  const ComTextField({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.onChanged,
    this.onEditingComplete,
    this.prefix,
    this.suffix,
    this.readOnly = false,
    this.radius,
    this.onTap,
    this.color,
    this.padding,
    this.focusNode,
    this.autoFocus = false,
    this.expands = false,
    this.boxDecoration,
    this.inputDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.only(
            left: 20,
          ),
      decoration: boxDecoration ??
          BoxDecoration(
            color: color ?? CommonColors.theme.shade100,
            borderRadius: BorderRadius.circular(radius ?? CommonStyle.rounded),
          ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        focusNode: focusNode,
        autofocus: autoFocus!,
        decoration: inputDecoration ??
            InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: CommonColors.theme.shade300,
                ),
                border: InputBorder.none,
                prefixIcon: prefix,
                suffixIcon: suffix),
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        maxLines: maxLines,
        minLines: minLines,
        expands: expands!,
        onChanged: (val) {
          onChanged?.call(val);
        }.debounce(),
        onEditingComplete: onEditingComplete,
        onTap: onTap,
      ),
    );
  }
}
