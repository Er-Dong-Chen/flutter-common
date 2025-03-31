import 'package:flutter/material.dart';
import 'package:flutter_chen_common/localization/intl_zh.dart';

import 'com_intl.dart';
import 'com_localizations.dart';

class ComLocalizationsDelegate extends LocalizationsDelegate<ComIntl> {
  const ComLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<ComIntl> load(Locale locale) async {
    return ComLocalizations.localizedValues[locale.languageCode] ?? ZhCnIntl();
  }

  @override
  bool shouldReload(LocalizationsDelegate<ComIntl> old) => false;
}
