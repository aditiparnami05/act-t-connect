import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Application typography scale — use via [AppTypography] or Theme.of(context).
abstract final class AppTypography {
  static TextStyle heading(Color color) => GoogleFonts.inter(
        fontSize: AppDimensions.fontHeading,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: color,
      );

  static TextStyle sectionTitle(Color color) => GoogleFonts.inter(
        fontSize: AppDimensions.fontSectionTitle,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: color,
      );

  static TextStyle body(Color color) => GoogleFonts.inter(
        fontSize: AppDimensions.fontBody,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  static TextStyle bodyMedium(Color color) => GoogleFonts.inter(
        fontSize: AppDimensions.fontBody,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: color,
      );

  static TextStyle caption(Color color) => GoogleFonts.inter(
        fontSize: AppDimensions.fontCaption,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color,
      );

  static TextStyle label(Color color) => GoogleFonts.inter(
        fontSize: AppDimensions.fontLabel,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
      );

  static TextTheme textTheme({required Color primary, required Color secondary}) {
    return TextTheme(
      headlineMedium: heading(primary),
      titleLarge: sectionTitle(primary),
      titleMedium: bodyMedium(primary),
      bodyLarge: body(primary),
      bodyMedium: caption(secondary),
      bodySmall: label(secondary),
      labelLarge: GoogleFonts.inter(
        fontSize: AppDimensions.fontCaption,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelMedium: label(secondary),
      labelSmall: GoogleFonts.inter(
        fontSize: AppDimensions.fontLabel,
        fontWeight: FontWeight.w500,
        color: secondary,
      ),
    );
  }
}

/// Extension for quick access to design-system text styles.
extension AppTextTheme on BuildContext {
  TextStyle get headingStyle =>
      AppTypography.heading(AppColors.textPrimary);

  TextStyle get sectionTitleStyle =>
      AppTypography.sectionTitle(AppColors.textPrimary);

  TextStyle get bodyStyle => AppTypography.body(AppColors.textPrimary);

  TextStyle get captionStyle =>
      AppTypography.caption(AppColors.textSecondary);
}
