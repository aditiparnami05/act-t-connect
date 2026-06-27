import 'package:flutter/material.dart';

/// Consistent spacing, sizing, and typography tokens (8px grid system).
abstract final class AppDimensions {
  // Spacing (8px system)
  static const double space1 = 8;
  static const double space2 = 16;
  static const double space3 = 24;
  static const double space4 = 32;

  // Layout
  static const double screenPaddingH = 16;
  static const double screenPaddingV = 16;
  static const double cardPadding = 16;
  static const double cardPaddingLg = 20;
  static const double sectionGap = 24;
  static const double elementGap = 12;
  static const double elementGapSm = 8;

  // Radius
  static const double radius = 20;
  static const double radiusSm = 12;
  static const double radiusLg = 24;
  static const double inputRadius = 16;

  // Component sizes
  static const double iconSize = 24;
  static const double iconSizeSm = 20;
  static const double buttonHeight = 52;
  static const double inputHeight = 52;
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 72;
  static const double maxContentWidth = 1200;

  // Typography sizes
  static const double fontHeading = 24;
  static const double fontSectionTitle = 18;
  static const double fontBody = 16;
  static const double fontCaption = 14;
  static const double fontLabel = 12;

  // Legacy aliases
  static const double padding = space2;
  static const double paddingLg = space3;
  static const double paddingSm = space1;

  // Shadows
  static const double shadowBlur = 16;
  static const double shadowOffsetY = 4;
  static const double shadowOpacity = 0.06;

  static List<BoxShadow> cardShadow({Color? color}) => [
        BoxShadow(
          color: (color ?? Colors.black).withValues(alpha: shadowOpacity),
          blurRadius: shadowBlur,
          offset: const Offset(0, shadowOffsetY),
        ),
      ];

  static EdgeInsets screenPadding(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return EdgeInsets.fromLTRB(screenPaddingH, screenPaddingV, screenPaddingH, bottom);
  }
}
