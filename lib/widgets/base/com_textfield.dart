import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:flutter_chen_common/common/utils/function_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final Function()? onEditingComplete;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final double? radius;
  final Color? color;
  final double? height;
  final EdgeInsets? padding;

  const ComTextField({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.onChanged,
    this.onEditingComplete,
    this.prefix,
    this.suffix,
    this.readOnly = false,
    this.radius,
    this.onTap,
    this.color,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 52.h,
      padding: padding ??
          EdgeInsets.only(
            top: 4.h,
            bottom: 4.h,
            left: radius != null ? 18.w : 24.w,
          ),
      decoration: BoxDecoration(
        color: color ?? CommonColors.theme.shade100,
        borderRadius: BorderRadius.circular(radius ?? CommonStyle.rounded),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
            hintText: hintText ?? "请输入",
            hintStyle: TextStyle(
              color: CommonColors.theme.shade200,
            ),
            border: InputBorder.none,
            prefixIcon: prefix,
            suffixIcon: suffix),
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        maxLines: maxLines,
        onChanged: (val) {
          onChanged?.call(val);
        }.debounce(),
        onEditingComplete: onEditingComplete,
        onTap: onTap,
      ),
    );
  }
}
