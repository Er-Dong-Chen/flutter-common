import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';

/// Overlay管理器基类
/// 提供Toast和Loading的共用Overlay管理功能
class ComOverlayManager {
  static final ComOverlayManager _instance = ComOverlayManager._internal();
  factory ComOverlayManager() => _instance;
  ComOverlayManager._internal();

  // Toast相关
  OverlayEntry? _toastEntry;
  bool _isToastShowing = false;

  // Loading相关
  OverlayEntry? _loadingEntry;
  bool _isLoadingShowing = false;

  /// 获取可用的OverlayState
  OverlayState? _getOverlay() {
    final context = ComContext.context;
    return Overlay.maybeOf(context, rootOverlay: true);
  }

  /// 显示Toast Entry
  void showToastEntry(OverlayEntry entry) {
    final overlay = _getOverlay();
    if (overlay == null) {
      Log.console('ComToast: 无法找到可用的Overlay');
      return;
    }

    // 如果有正在显示的Toast，先移除
    if (_isToastShowing) {
      hideToastEntry();
    }

    _isToastShowing = true;
    _toastEntry = entry;
    overlay.insert(entry);
  }

  /// 隐藏Toast Entry
  void hideToastEntry() {
    if (!_isToastShowing) return;

    _isToastShowing = false;
    try {
      _toastEntry?.remove();
    } catch (e) {
      // 忽略移除失败的错误
    }
    _toastEntry = null;
  }

  /// 显示Loading Entry
  void showLoadingEntry(OverlayEntry entry) {
    final overlay = _getOverlay();
    if (overlay == null) {
      Log.console('ComLoading: 无法找到可用的Overlay');
      return;
    }

    // 如果已经有Loading在显示，直接返回
    if (_isLoadingShowing) return;

    _isLoadingShowing = true;
    _loadingEntry = entry;
    overlay.insert(entry);
  }

  /// 隐藏Loading Entry
  void hideLoadingEntry() {
    if (!_isLoadingShowing) return;

    _isLoadingShowing = false;
    try {
      _loadingEntry?.remove();
    } catch (e) {
      // 忽略移除失败的错误
    }
    _loadingEntry = null;
  }

  /// 获取Toast状态
  bool get isToastShowing => _isToastShowing;

  /// 获取Loading状态
  bool get isLoadingShowing => _isLoadingShowing;

  /// 清理所有Overlay
  void clearAll() {
    hideToastEntry();
    hideLoadingEntry();
  }
}
