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
  final BorderRadius? borderRadius;
  @Deprecated(
      'Use borderRadius instead. This will be removed in a future version.')
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
    this.borderRadius,
    @Deprecated(
        'Use borderRadius instead. This will be removed in a future version.')
    this.radius,
    this.color,
    this.padding,
    this.loading = false,
    this.shadowColor,
    this.elevation = 0,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final minHeight =
        (padding == null ? height ?? Theme.of(context).buttonTheme.height : 0)
            .toDouble();

    return gradient != null || elevation > 0
        ? _buildGradientButton(context, minHeight)
        : Container(
            height: height,
            width: width,
            constraints: BoxConstraints(minHeight: minHeight),
            child: _buildColoredButton(context, minHeight),
          );
  }

  Widget _buildGradientButton(BuildContext context, double minHeight) {
    return Container(
      height: height ?? Theme.of(context).buttonTheme.height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius ??
            BorderRadius.circular(
                radius ?? context.comTheme.shapes.circularRadius),
        boxShadow: _buildButtonShadow(context),
      ),
      child: _buildButtonContent(
          context, _getGradientButtonStyle(context, minHeight)),
    );
  }

  Widget _buildColoredButton(BuildContext context, double minHeight) {
    final buttonTheme = plain
        ? _getOutlinedButtonStyle(context, minHeight)
        : _getFilledButtonStyle(context, minHeight);
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

  Color _getButtonColor(BuildContext context) {
    return color ?? Theme.of(context).colorScheme.primary;
  }

  Color _getForegroundColor(BuildContext context, Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  ButtonStyle _getGradientButtonStyle(BuildContext context, double minHeight) {
    final foregroundColor = _getForegroundColor(context, Colors.transparent);
    return ElevatedButton.styleFrom(
      padding: padding,
      backgroundColor: Colors.transparent,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: foregroundColor.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ??
            BorderRadius.circular(
                radius ?? context.comTheme.shapes.circularRadius),
      ),
      minimumSize: Size(minHeight, 0),
    );
  }

  ButtonStyle _getOutlinedButtonStyle(BuildContext context, double minHeight) {
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
        borderRadius: borderRadius ??
            BorderRadius.circular(
                radius ?? context.comTheme.shapes.circularRadius),
      ),
      minimumSize: Size(minHeight, 0),
    );
  }

  ButtonStyle _getFilledButtonStyle(BuildContext context, double minHeight) {
    final buttonColor = _getButtonColor(context);
    final foregroundColor = _getForegroundColor(context, buttonColor);

    return FilledButton.styleFrom(
      padding: padding,
      foregroundColor: foregroundColor,
      backgroundColor: buttonColor.withValues(alpha: loading ? 0.5 : 1),
      disabledBackgroundColor: buttonColor.withValues(alpha: 0.5),
      disabledForegroundColor: foregroundColor.withValues(alpha: 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ??
            BorderRadius.circular(
                radius ?? context.comTheme.shapes.circularRadius),
      ),
      minimumSize: Size(minHeight, 0),
    );
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
    return disabled || loading ? null : onPressed?.throttle();
  }
}
