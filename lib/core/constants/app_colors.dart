import 'package:flutter/material.dart';

/// Brand color palette derived from Act-T Connect logo.
abstract final class AppColors {
  static const Color primary = Color(0xFF1976D2);
  static const Color secondary = Color(0xFF2196F3);
  static const Color accent = Color(0xFF42A5F5);
  static const Color background = Color(0xFFF5F9FF);
  static const Color card = Colors.white;
  static const Color textPrimary = Color(0xFF0D1B2A);
  static const Color textSecondary = Color(0xFF607D8B);
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFB300);
  static const Color error = Color(0xFFE53935);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary, accent],
  );

  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE3F2FD), Color(0xFFF5F9FF)],
  );

  // Dark mode
  static const Color darkBackground = Color(0xFF0D1B2A);
  static const Color darkSurface = Color(0xFF1B2838);
  static const Color darkCard = Color(0xFF243447);
}
