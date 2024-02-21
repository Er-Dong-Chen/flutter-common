import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:flutter_chen_common/common/utils/function_util.dart';

class ComSearch extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? placeholder;
  final bool autofocus;
  final bool enabled;
  final double? radius;
  final Color? background;
  final Widget prefix;
  final Icon suffix;
  final OverlayVisibilityMode? suffixMode;
  final VoidCallback? onSuffixTap;
  final EdgeInsets? padding;

  const ComSearch({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.placeholder,
    this.autofocus = false,
    this.enabled = true,
    this.radius,
    this.background,
    this.prefix = const Icon(CupertinoIcons.search),
    this.suffix = const Icon(CupertinoIcons.xmark_circle_fill),
    this.suffixMode = OverlayVisibilityMode.editing,
    this.onSuffixTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      controller: controller,
      onChanged: (val) {
        onChanged?.call(val);
      }.debounce(),
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize), //
      backgroundColor: background,
      borderRadius: BorderRadius.circular(radius ?? CommonStyle.rounded),
      padding: padding ?? EdgeInsets.symmetric(vertical: CommonStyle.spaceSm),
      prefixInsets: EdgeInsets.symmetric(horizontal: CommonStyle.spaceMd),
      suffixInsets: EdgeInsets.symmetric(horizontal: CommonStyle.spaceMd),
      prefixIcon: prefix,
      suffixIcon: suffix,
      onSuffixTap: onSuffixTap,
      placeholder: placeholder,
      autofocus: autofocus,
      enabled: enabled,
      onTap: onTap,
      onSubmitted: onSubmitted,
    );
  }
}
