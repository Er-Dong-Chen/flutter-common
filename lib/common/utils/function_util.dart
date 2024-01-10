import 'dart:async';

import 'package:flutter/material.dart';

extension FunctionExt on Function {
  VoidCallback throttle({int? timeout}) {
    return FunctionProxy(this, timeout: timeout).throttle;
  }

  VoidCallback debounce({int? timeout}) {
    return FunctionProxy(this, timeout: timeout).debounce;
  }
}

class FunctionProxy {
  static final Map<String, bool> _funcThrottle = {};
  static final Map<String, Timer> _funcDebounce = {};
  final Function? target;

  final int timeout;

  FunctionProxy(this.target, {int? timeout}) : timeout = timeout ?? 500;

  void throttle() async {
    String key = hashCode.toString();
    bool enable = _funcThrottle[key] ?? true;
    if (enable) {
      _funcThrottle[key] = false;
      Timer(Duration(milliseconds: timeout), () {
        _funcThrottle.remove(key);
      });
      target?.call();
    }
  }

  void debounce() {
    String key = hashCode.toString();
    Timer? timer = _funcDebounce[key];
    timer?.cancel();
    timer = Timer(Duration(milliseconds: timeout), () {
      Timer? t = _funcDebounce.remove(key);
      t?.cancel();
      target?.call();
    });
    _funcDebounce[key] = timer;
  }
}

extension FunctionValueExt on ValueChanged {
  ValueChanged throttle({int? timeout}) {
    return FunctionValueProxy(this, timeout: timeout).throttle;
  }

  ValueChanged debounce({int? timeout}) {
    return FunctionValueProxy(this, timeout: timeout).debounce;
  }
}

class FunctionValueProxy<T> {
  static final Map<String, bool> _funcThrottle = {};
  static final Map<String, Timer> _funcDebounce = {};
  final ValueChanged<T>? target;

  final int timeout;

  FunctionValueProxy(this.target, {int? timeout}) : timeout = timeout ?? 500;

  void throttle(T value) async {
    String key = hashCode.toString();
    bool enable = _funcThrottle[key] ?? true;
    if (enable) {
      _funcThrottle[key] = false;
      Timer(Duration(milliseconds: timeout), () {
        _funcThrottle.remove(key);
      });
      target?.call(value);
    }
  }

  void debounce(T value) {
    String key = hashCode.toString();
    Timer? timer = _funcDebounce[key];
    timer?.cancel();
    timer = Timer(Duration(milliseconds: timeout), () {
      Timer? t = _funcDebounce.remove(key);
      t?.cancel();
      target?.call(value);
    });
    _funcDebounce[key] = timer;
  }
}
