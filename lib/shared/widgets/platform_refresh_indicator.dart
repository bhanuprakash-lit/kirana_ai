import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;

  const PlatformRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // If the child is already a scrollable widget like ListView or CustomScrollView,
      // we can't easily inject CupertinoSliverRefreshControl unless we wrap it
      // in a CustomScrollView. But that can cause nested scrolling issues.
      //
      // For general cases, RefreshIndicator.adaptive is a good middle ground
      // as it uses CupertinoActivityIndicator on iOS.
      return RefreshIndicator.adaptive(
        onRefresh: onRefresh,
        color: color,
        child: child,
      );
    }

    return RefreshIndicator(onRefresh: onRefresh, color: color, child: child);
  }
}
