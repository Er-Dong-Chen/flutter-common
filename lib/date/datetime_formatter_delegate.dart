import 'package:flutter/material.dart';

abstract class DateTimeFormatterDelegate {
  String format(DateTime? dateTime, {String? pattern, Locale? locale});
  String timeAgo(DateTime? dateTime, {Locale? locale});
  String timeAgoForChat(DateTime? dateTime, {Locale? locale});
  String weekDay(DateTime? dateTime, {Locale? locale});
}
