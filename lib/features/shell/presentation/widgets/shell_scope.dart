import 'package:flutter/material.dart';

/// Provides shell-level actions (e.g. open drawer) to nested child screens.
class ShellScope extends InheritedWidget {
  const ShellScope({
    super.key,
    required this.openDrawer,
    required super.child,
  });

  final VoidCallback openDrawer;

  static ShellScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShellScope>();
  }

  @override
  bool updateShouldNotify(ShellScope oldWidget) {
    return openDrawer != oldWidget.openDrawer;
  }
}
