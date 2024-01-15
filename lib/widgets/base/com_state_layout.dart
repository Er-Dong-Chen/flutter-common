import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';

enum LayoutStatus { loading, empty, noNetwork, complete, error }

class ComStateLayout extends StatelessWidget {
  final Widget content;
  final Widget? empty;
  final Widget? loading;
  final Widget? noNetwork;
  final Widget? error;
  final LayoutStatus? status;

  const ComStateLayout({
    super.key,
    required this.content,
    this.empty,
    this.loading,
    this.noNetwork,
    this.error,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LayoutStatus.loading:
        return loading ?? const ComLoading();
      case LayoutStatus.empty:
        return empty ?? const ComEmpty();
      case LayoutStatus.noNetwork:
        return noNetwork ?? const ComEmpty();
      case LayoutStatus.error:
        return error ?? const ComEmpty();
      default:
        return content;
    }
  }
}
