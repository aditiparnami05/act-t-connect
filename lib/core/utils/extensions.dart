import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';

/// Responsive layout helpers for phone and tablet.
extension ResponsiveContext on BuildContext {
  bool get isTablet => MediaQuery.sizeOf(this).shortestSide >= 600;
  bool get isDesktop => MediaQuery.sizeOf(this).width >= 900;
  double get contentWidth {
    final width = MediaQuery.sizeOf(this).width;
    return width > AppDimensions.maxContentWidth
        ? AppDimensions.maxContentWidth
        : width;
  }

  int gridColumns({int phone = 2, int tablet = 3, int desktop = 4}) {
    if (isDesktop) return desktop;
    if (isTablet) return tablet;
    return phone;
  }
}

extension StringExtension on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
