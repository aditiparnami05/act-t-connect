import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_typography.dart';

/// Status badge chip for invoices, stock, payments.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.elementGap,
        vertical: AppDimensions.elementGapSm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Text(
        label,
        style: AppTypography.label(color).copyWith(fontSize: AppDimensions.fontLabel),
      ),
    );
  }
}

/// Section header with optional action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.elementGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(title, style: context.sectionTitleStyle),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space1),
                minimumSize: const Size(0, AppDimensions.buttonHeight / 2),
              ),
              child: Text(
                actionLabel!,
                style: AppTypography.bodyMedium(AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}

/// Responsive content wrapper for tablet layouts.
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppDimensions.screenPaddingH,
      vertical: AppDimensions.space1,
    ),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Standard horizontal divider with section spacing.
class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.elementGap),
      child: Divider(height: 1),
    );
  }
}

/// Key-value row for summary tables and detail views.
class AppLabelValueRow extends StatelessWidget {
  const AppLabelValueRow({
    super.key,
    required this.label,
    required this.value,
    this.valueStyle,
    this.highlight = false,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.elementGapSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(label, style: context.captionStyle),
          ),
          Text(
            value,
            textAlign: TextAlign.end,
            style: valueStyle ??
                (highlight
                    ? context.sectionTitleStyle.copyWith(color: AppColors.primary)
                    : context.bodyStyle.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
