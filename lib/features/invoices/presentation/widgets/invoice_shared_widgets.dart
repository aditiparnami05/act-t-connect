import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

/// Shared form field for invoice notes and text areas.
class InvoiceFormField extends StatelessWidget {
  const InvoiceFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.maxLines = 2,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, size: AppDimensions.iconSizeSm, color: AppColors.primary),
            const SizedBox(width: AppDimensions.elementGapSm),
            Text(label, style: AppTypography.label(AppColors.textPrimary)),
          ],
        ),
        const SizedBox(height: AppDimensions.elementGapSm),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: AppTypography.body(AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(AppDimensions.elementGap),
          ),
        ),
      ],
    );
  }
}

/// Empty placeholder inside invoice cards.
class InvoiceEmptyState extends StatelessWidget {
  const InvoiceEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.space3,
        horizontal: AppDimensions.space2,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.primary.withValues(alpha: 0.35)),
          const SizedBox(height: AppDimensions.elementGap),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.caption(AppColors.textSecondary),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppDimensions.elementGap),
            TextButton.icon(
              onPressed: onAction,
              icon: const Icon(Symbols.add, size: 18),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Pair of outline + filled action buttons used in customer card etc.
class InvoiceActionButtonRow extends StatelessWidget {
  const InvoiceActionButtonRow({
    super.key,
    required this.outlineLabel,
    required this.outlineIcon,
    required this.onOutline,
    required this.filledLabel,
    required this.filledIcon,
    required this.onFilled,
  });

  final String outlineLabel;
  final IconData outlineIcon;
  final VoidCallback onOutline;
  final String filledLabel;
  final IconData filledIcon;
  final VoidCallback onFilled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onOutline,
            icon: Icon(outlineIcon, size: AppDimensions.iconSizeSm),
            label: Text(outlineLabel),
          ),
        ),
        const SizedBox(width: AppDimensions.elementGap),
        Expanded(
          child: FilledButton.icon(
            onPressed: onFilled,
            icon: Icon(filledIcon, size: AppDimensions.iconSizeSm),
            label: Text(filledLabel),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom sheet drag handle.
class InvoiceSheetHandle extends StatelessWidget {
  const InvoiceSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppDimensions.elementGap),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: AppDimensions.space2),
      ],
    );
  }
}

/// Standard bottom sheet container decoration.
BoxDecoration invoiceSheetDecoration() => const BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.radiusLg),
      ),
    );

/// Sheet title text.
class InvoiceSheetTitle extends StatelessWidget {
  const InvoiceSheetTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.cardPaddingLg,
        0,
        AppDimensions.cardPaddingLg,
        AppDimensions.elementGap,
      ),
      child: Text(title, style: context.sectionTitleStyle),
    );
  }
}
