import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:flutter_chen_common/common/utils/function_util.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return _buildButton(context);
  }

  Widget _buildButton(BuildContext context) {
    if (gradient != null) {
      return _buildGradientButton(context);
    } else {
      return Container(
        constraints: const BoxConstraints(minHeight: 40),
        child: _buildColoredButton(context),
      );
    }
  }

  Widget _buildGradientButton(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius ?? CommonStyle.rounded),
        boxShadow: [
          if (elevation > 0)
            BoxShadow(
              color: shadowColor ?? Theme.of(context).colorScheme.shadow,
              blurRadius: elevation,
            ),
        ],
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
    if (plain) {
      return OutlinedButton(
        style: effectiveStyle,
        onPressed: _getOnPressed(),
        child: child,
      );
    } else {
      return FilledButton(
        style: effectiveStyle,
        onPressed: _getOnPressed(),
        child: child,
      );
    }
  }

  ButtonStyle _getGradientButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      padding: padding,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: Colors.white.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? CommonStyle.rounded),
      ),
    );
  }

  ButtonStyle _getOutlinedButtonStyle(BuildContext context) {
    return OutlinedButton.styleFrom(
      padding: padding,
      foregroundColor: _getButtonColor(context).withOpacity(loading ? 0.5 : 1),
      disabledForegroundColor: _getButtonColor(context).withOpacity(0.5),
      side: BorderSide(
        color:
            _getButtonColor(context).withOpacity(loading || disabled ? 0.5 : 1),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? CommonStyle.rounded),
      ),
    );
  }

  ButtonStyle _getFilledButtonStyle(BuildContext context) {
    return FilledButton.styleFrom(
      padding: padding,
      backgroundColor: _getButtonColor(context).withOpacity(loading ? 0.5 : 1),
      disabledBackgroundColor: _getButtonColor(context).withOpacity(0.5),
      disabledForegroundColor: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? CommonStyle.rounded),
      ),
    );
  }

  Color _getButtonColor(BuildContext context) {
    return color ?? Theme.of(context).colorScheme.primary;
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
