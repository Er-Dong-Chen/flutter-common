import 'package:flutter/material.dart';

import '../../config/com_context.dart';
import '../../log/logger.dart';

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
    try {
      final context = ComContext.context;
      if (!context.mounted) return null;
      return Overlay.maybeOf(context, rootOverlay: true);
    } catch (e) {
      Log.console('获取Overlay失败: $e');
      return null;
    }
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
    if (!_isToastShowing || _toastEntry == null) return;

    _isToastShowing = false;
    try {
      if (_toastEntry!.mounted) {
        _toastEntry!.remove();
      }
    } catch (e) {
      Log.console('Toast移除失败: $e');
    } finally {
      _toastEntry = null;
    }
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
  Future<void> hideLoadingEntry() async {
    if (!_isLoadingShowing || _loadingEntry == null) return;

    _isLoadingShowing = false;

    try {
      // 如果是Loading组件，先执行动画
      final loadingWidget =
          _loadingEntry!.builder(ComContext.context) as Widget?;
      if (loadingWidget != null) {
        // 等待动画完成（可选）
        await Future.delayed(const Duration(milliseconds: 200));
      }

      if (_loadingEntry!.mounted) {
        _loadingEntry!.remove();
      }
    } catch (e) {
      Log.console('Loading移除失败: $e');
    } finally {
      _loadingEntry = null;
    }
  }

  /// 获取Toast状态
  bool get isToastShowing => _isToastShowing;

  /// 获取Loading状态
  bool get isLoadingShowing => _isLoadingShowing;

  /// 清理所有Overlay
  Future<void> clearAll() async {
    hideToastEntry();
    await hideLoadingEntry();
  }

  /// 检查是否有任何Overlay显示
  bool get hasAnyOverlay => _isToastShowing || _isLoadingShowing;

  /// 强制清理（用于应用退出时）
  void forceCleanup() {
    _isToastShowing = false;
    _isLoadingShowing = false;

    try {
      _toastEntry?.remove();
      _loadingEntry?.remove();
    } catch (e) {
      // 忽略清理错误
    } finally {
      _toastEntry = null;
      _loadingEntry = null;
    }
  }
}
