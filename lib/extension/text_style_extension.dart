import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

extension TextStylePlatformAdjustment on TextStyle {
  TextStyle get adjustFontWeight {
    if (kIsWeb) return this;
    if (Platform.isIOS && fontWeight == FontWeight.w500) {
      return copyWith(fontWeight: FontWeight.w600);
    }
    return this;
  }
}
