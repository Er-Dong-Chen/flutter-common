import 'package:flutter/material.dart';
import 'package:flutter_chen_common/extension/extension.dart';
import 'package:flutter_chen_common/utils/function_util.dart';

class ComButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool plain;
  final bool disabled;
  final Gradient? gradient;
  final double? radius;
  final double elevation;
  final Color? shadowColor;
  final Color? color;
  final EdgeInsets? padding;
  final bool loading;
  final double? width;
  final double? height;

  const ComButton({
    super.key,
    required this.child,
    this.gradient,
    this.onPressed,
    this.style,
    this.plain = false,
    this.disabled = false,
    this.radius,
    this.color,
    this.padding,
    this.loading = false,
    this.shadowColor,
    this.elevation = 0,
    this.width,
    this.height,
  }) : _minHeight = padding == null ? height ?? 40 : 0;

  final double _minHeight;

  @override
  Widget build(BuildContext context) {
    return gradient != null || elevation > 0
        ? _buildGradientButton(context)
        : Container(
            height: height,
            width: width,
            constraints: BoxConstraints(minHeight: _minHeight),
            child: _buildColoredButton(context),
          );
  }

  Widget _buildGradientButton(BuildContext context) {
    return Container(
      height: height ?? 40,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(
            radius ?? context.comTheme.shapes.circularRadius),
        boxShadow: _buildButtonShadow(context),
      ),
      child: _buildButtonContent(context, _getGradientButtonStyle(context)),
    );
  }

  Widget _buildColoredButton(BuildContext context) {
    final buttonTheme = plain
        ? _getOutlinedButtonStyle(context)
        : _getFilledButtonStyle(context);
    final effectiveStyle = style?.merge(buttonTheme) ?? buttonTheme;

    return _buildButtonContent(context, effectiveStyle);
  }

  Widget _buildButtonContent(BuildContext context, ButtonStyle effectiveStyle) {
    return (plain
        ? OutlinedButton(
            style: effectiveStyle,
            onPressed: _getOnPressed(),
            child: child,
          )
        : FilledButton(
            style: effectiveStyle,
            onPressed: _getOnPressed(),
            child: child,
          ));
  }

  ButtonStyle _getGradientButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      padding: padding,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            radius ?? context.comTheme.shapes.circularRadius),
      ),
      minimumSize: Size(_minHeight, 0),
    );
  }

  ButtonStyle _getOutlinedButtonStyle(BuildContext context) {
    return OutlinedButton.styleFrom(
      padding: padding,
      foregroundColor:
          _getButtonColor(context).withValues(alpha: loading ? 0.5 : 1),
      disabledForegroundColor: _getButtonColor(context).withValues(alpha: 0.5),
      side: BorderSide(
        color: _getButtonColor(context)
            .withValues(alpha: loading || disabled ? 0.5 : 1),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            radius ?? context.comTheme.shapes.circularRadius),
      ),
      minimumSize: Size(_minHeight, 0),
    );
  }

  ButtonStyle _getFilledButtonStyle(BuildContext context) {
    return FilledButton.styleFrom(
      padding: padding,
      foregroundColor: Colors.black,
      backgroundColor:
          _getButtonColor(context).withValues(alpha: loading ? 0.5 : 1),
      disabledBackgroundColor: _getButtonColor(context).withValues(alpha: 0.5),
      disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            radius ?? context.comTheme.shapes.circularRadius),
      ),
      minimumSize: Size(_minHeight, 0),
    );
  }

  Color _getButtonColor(BuildContext context) {
    return color ?? Theme.of(context).colorScheme.primary;
  }

  List<BoxShadow> _buildButtonShadow(BuildContext context) {
    if (elevation > 0) {
      return [
        BoxShadow(
          color: shadowColor ?? Theme.of(context).colorScheme.shadow,
          blurRadius: elevation,
        ),
      ];
    }
    return [];
  }

  VoidCallback? _getOnPressed() {
    return disabled
        ? null
        : () {
            if (!loading) {
              onPressed?.call();
            }
          }.throttle();
  }
}
