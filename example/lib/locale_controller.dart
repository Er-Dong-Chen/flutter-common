import 'dart:ui';

import 'package:get/get.dart';

class LocaleController extends GetxController {
  final Rx<Locale> _currentLocale = Locale('en', 'US').obs;

  Locale get currentLocale => _currentLocale.value;

  Future<void> switchLocale(Locale newLocale) async {
    _currentLocale.value = newLocale;
    Get.updateLocale(newLocale);
  }
}
