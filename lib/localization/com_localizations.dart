import 'package:flutter/material.dart';

import 'com_intl.dart';
import 'com_localizations_delegate.dart';
import 'intl_en.dart';
import 'intl_zh.dart';

class ComLocalizations {
  static final Map<String, ComIntl> localizedValues = {
    'zh': ZhCnIntl(),
    'en': EnIntl(),
  };

  static void addLocalization(String localeCode, ComIntl intl) {
    localizedValues[localeCode] = intl;
  }

  static ComIntl of(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return localizedValues[locale] ?? localizedValues['zh']!;
  }

  static const ComLocalizationsDelegate delegate = ComLocalizationsDelegate();
}
