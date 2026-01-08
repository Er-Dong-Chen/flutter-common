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

  void throttle() {
    final key = _generateKey();
    if (_funcThrottle[key] ?? true) {
      _funcThrottle[key] = false;
      Timer(Duration(milliseconds: timeout), () => _funcThrottle.remove(key));
      target?.call();
    }
  }

  void debounce() {
    final key = _generateKey();
    _funcDebounce[key]?.cancel();
    _funcDebounce[key] = Timer(Duration(milliseconds: timeout), () {
      _funcDebounce.remove(key)?.cancel();
      target?.call();
    });
  }

  String _generateKey() => '${target.hashCode}-$hashCode';
}

extension FunctionValueExt<T> on ValueChanged<T> {
  ValueChanged<T> throttle({int? timeout}) {
    return FunctionValueProxy<T>(this, timeout: timeout).throttle;
  }

  ValueChanged<T> debounce({int? timeout}) {
    return FunctionValueProxy<T>(this, timeout: timeout).debounce;
  }
}

class FunctionValueProxy<T> {
  static final Map<String, bool> _funcThrottle = {};
  static final Map<String, Timer> _funcDebounce = {};
  final ValueChanged<T>? target;
  final int timeout;

  FunctionValueProxy(this.target, {int? timeout}) : timeout = timeout ?? 500;

  void throttle(T value) {
    final key = _generateKey();
    if (_funcThrottle[key] ?? true) {
      _funcThrottle[key] = false;
      Timer(Duration(milliseconds: timeout), () => _funcThrottle.remove(key));
      target?.call(value);
    }
  }

  void debounce(T value) {
    final key = _generateKey();
    _funcDebounce[key]?.cancel();
    _funcDebounce[key] = Timer(Duration(milliseconds: timeout), () {
      _funcDebounce.remove(key)?.cancel();
      target?.call(value);
    });
  }

  String _generateKey() => '${target.hashCode}-$hashCode';
}
