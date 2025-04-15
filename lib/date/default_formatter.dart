import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chen_common/utils/date_util.dart';

import 'date_formats.dart';
import 'datetime_formatter_delegate.dart';

class DefaultDateTimeFormatter implements DateTimeFormatterDelegate {
  @override
  String format(DateTime? dateTime, {String? pattern, Locale? locale}) {
    if (dateTime == null) return '';
    pattern = pattern ?? DateFormats.dateTime;
    return pattern
        .replaceAll('yyyy', dateTime.year.toString().padLeft(4, '0'))
        .replaceAll('MM', dateTime.month.toString().padLeft(2, '0'))
        .replaceAll('dd', dateTime.day.toString().padLeft(2, '0'))
        .replaceAll('HH', dateTime.hour.toString().padLeft(2, '0'))
        .replaceAll('mm', dateTime.minute.toString().padLeft(2, '0'))
        .replaceAll('ss', dateTime.second.toString().padLeft(2, '0'));
  }

  @override
  String timeAgo(DateTime? dateTime, {Locale? locale}) {
    if (dateTime == null) return '';

    final difference = DateTime.now().difference(dateTime);
    String languageCode = locale?.languageCode ?? 'zh';
    if (difference.inMinutes < 3) {
      return languageCode == 'zh' ? '刚刚' : 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}${languageCode == 'zh' ? '分钟前' : 'minutes ago'}';
    } else if (difference.inHours < 24) {
      return '${(difference.inHours).toInt()}${languageCode == 'zh' ? '小时前' : 'hours ago'}';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays).toInt()}${languageCode == 'zh' ? '天前' : 'days ago'}';
    } else {
      return '${difference.inDays ~/ 365}${languageCode == 'zh' ? '年前' : 'years ago'}';
    }
  }

  @override
  String timeAgoForChat(DateTime? dateTime, {Locale? locale}) {
    if (dateTime == null) return '';

    String languageCode = locale?.languageCode ?? 'zh';
    final nowTime = DateTime.now();
    if (nowTime.year != dateTime.year) {
      return DateUtil.formatDate(dateTime,
          format:
              languageCode == 'zh' ? 'yyyy年MM月dd HH:mm' : 'yyyy-MM-dd HH:mm');
    } else if (nowTime.month != dateTime.month) {
      return DateUtil.formatDate(dateTime,
          format: languageCode == 'zh' ? 'M月dd HH:mm' : 'M-dd HH:mm');
    } else if (nowTime.day != dateTime.day) {
      if (DateUtil.isYesterday(dateTime, nowTime)) {
        return languageCode == 'zh' ? '昨天' : 'Yesterday';
      }
      if (DateUtil.isWeek(dateTime.millisecondsSinceEpoch)) {
        final weekday = weekDay(dateTime, locale: locale);
        return '$weekday ${DateUtil.formatDate(dateTime, format: 'HH:mm')}';
      }
      return DateUtil.formatDate(dateTime,
          format: languageCode == 'zh' ? 'M月dd HH:mm' : 'M-dd HH:mm');
    } else {
      final threeMinutesAgo = nowTime.subtract(const Duration(minutes: 3));
      if (dateTime.isAfter(threeMinutesAgo) && dateTime.isBefore(nowTime)) {
        return languageCode == 'zh' ? '刚刚' : 'just now';
      } else {
        return DateUtil.formatDate(dateTime, format: 'HH:mm');
      }
    }
  }

  @override
  String weekDay(DateTime? dateTime, {Locale? locale}) {
    if (dateTime == null) return '';

    String languageCode = locale?.languageCode ?? 'zh';
    String weekday = '';
    switch (dateTime.weekday) {
      case 1:
        weekday = languageCode == 'zh' ? '周一' : 'Monday';
        break;
      case 2:
        weekday = languageCode == 'zh' ? '周二' : 'Tuesday';
        break;
      case 3:
        weekday = languageCode == 'zh' ? '周三' : 'Wednesday';
        break;
      case 4:
        weekday = languageCode == 'zh' ? '周四' : 'Thursday';
        break;
      case 5:
        weekday = languageCode == 'zh' ? '周五' : 'Friday';
        break;
      case 6:
        weekday = languageCode == 'zh' ? '周六' : 'Saturday';
        break;
      case 7:
        weekday = languageCode == 'zh' ? '周日' : 'Sunday';
        break;
      default:
        break;
    }
    return weekday;
  }
}
