import 'package:flutter/material.dart';

import 'date_formats.dart';
import 'datetime_formatter_delegate.dart';
import 'default_formatter.dart';

class DateTimeFormatter {
  static DateTimeFormatterDelegate _delegate = DefaultDateTimeFormatter();

  /// 注入自定义代理（可选）
  static void setDelegate(DateTimeFormatterDelegate delegate) {
    _delegate = delegate;
  }

  //---------------- 核心方法 ----------------
  static String formatDate(DateTime? date,
      {String? pattern = DateFormats.dateTime, Locale? locale}) {
    return _delegate.format(
      date,
      pattern: pattern,
      locale: locale,
    );
  }

  static String getTimeAgo(DateTime? date, {Locale? locale}) {
    return _delegate.timeAgo(
      date,
      locale: locale,
    );
  }

  static String getTimeAgoForChat(DateTime? date, {Locale? locale}) {
    return _delegate.timeAgo(
      date,
      locale: locale,
    );
  }

  static String getWeekDay(DateTime? date, {Locale? locale}) {
    return _delegate.weekDay(
      date,
      locale: locale,
    );
  }
}
