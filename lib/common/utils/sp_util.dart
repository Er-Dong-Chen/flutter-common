import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences Util.
class SpUtil {
  static late SharedPreferences _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// put object.
  static Future<bool> putObject(String key, Object value) {
    return _prefs.setString(key, value == false ? "" : json.encode(value));
  }

  /// get obj.
  static T getObj<T>(String key, T Function(Map<String, dynamic> v) f,
      {required T defValue}) {
    Map<String, dynamic>? map = getObject(key);
    return map.isEmpty ? defValue : f(map);
  }

  /// get object.
  static Map<String, dynamic> getObject(String key) {
    String? data = _prefs.getString(key);
    return (data == null || data.isEmpty) ? {} : json.decode(data);
  }

  /// put object list.
  static Future<bool> putObjectList(String key, List<Object> list) {
    List<String>? dataList = list.map((value) {
      return json.encode(value);
    }).toList();
    return _prefs.setStringList(key, dataList);
  }

  /// get obj list.
  static List<T> getObjList<T>(
      String key, T Function(Map<String, dynamic> v) f) {
    List<Map<String, dynamic>> dataList = getObjectList(key);
    return dataList.map((value) {
      return f(value);
    }).toList();
  }

  /// get object list.
  static List<Map<String, dynamic>> getObjectList(String key) {
    List<String>? dataList = _prefs.getStringList(key);
    return (dataList == null || dataList.isEmpty)
        ? []
        : dataList.map((value) {
      Map<String, dynamic> dataMap = json.decode(value);
      return dataMap;
    }).toList();
  }

  /// get string.
  static String getString(String key, {String defValue = ''}) {
    return _prefs.getString(key) ?? defValue;
  }

  /// put string.
  static Future<bool> putString(String key, String value) {
    return _prefs.setString(key, value);
  }

  /// get bool.
  static bool getBool(String key, {bool defValue = false}) {
    return _prefs.getBool(key) ?? defValue;
  }

  /// put bool.
  static Future<bool> putBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  /// get int.
  static int getInt(String key, {int defValue = 0}) {
    return _prefs.getInt(key) ?? defValue;
  }

  /// put int.
  static Future<bool> putInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  /// get double.
  static double getDouble(String key, {double defValue = 0.0}) {
    return _prefs.getDouble(key) ?? defValue;
  }

  /// put double.
  static Future<bool> putDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }

  /// get string list.
  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    return _prefs.getStringList(key) ?? defValue;
  }

  /// put string list.
  static Future<bool> putStringList(String key, List<String> value) {
    return _prefs.setStringList(key, value);
  }

  /// get dynamic.
  static dynamic getDynamic(String key, {required Object defValue}) {
    return _prefs.get(key) ?? defValue;
  }

  /// have key.
  static bool hasKey(String key) {
    return _prefs.getKeys().contains(key);
  }

  /// get keys.
  static Set<String> getKeys() {
    return _prefs.getKeys();
  }

  /// remove.
  static Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  /// clear.
  static Future<bool> clear() {
    return _prefs.clear();
  }
}
