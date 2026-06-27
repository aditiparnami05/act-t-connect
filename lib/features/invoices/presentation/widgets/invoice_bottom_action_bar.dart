import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/gradient_button.dart';
import 'invoice_section_card.dart';

class InvoiceBottomActionBar extends StatelessWidget {
  const InvoiceBottomActionBar({
    super.key,
    required this.grandTotal,
    required this.canGenerate,
    required this.onSaveDraft,
    required this.onPreviewPdf,
    required this.onGenerate,
    required this.onPrint,
    required this.onSharePdf,
  });

  final double grandTotal;
  final bool canGenerate;
  final VoidCallback onSaveDraft;
  final VoidCallback onPreviewPdf;
  final VoidCallback onGenerate;
  final VoidCallback onPrint;
  final VoidCallback onSharePdf;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: AppDimensions.cardShadow(),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.cardPaddingLg,
                vertical: AppDimensions.elementGap,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.08),
                    AppColors.accent.withValues(alpha: 0.04),
                  ],
                ),
              ),
              child: InvoiceGrandTotalRow(amount: grandTotal),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenPaddingH,
                AppDimensions.elementGap,
                AppDimensions.screenPaddingH,
                AppDimensions.space2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(child: _ActionChip(label: 'Draft', icon: Symbols.save, onTap: onSaveDraft)),
                      const SizedBox(width: AppDimensions.elementGapSm),
                      Expanded(child: _ActionChip(label: 'Preview', icon: Symbols.picture_as_pdf, onTap: onPreviewPdf)),
                      const SizedBox(width: AppDimensions.elementGapSm),
                      Expanded(child: _ActionChip(label: 'Print', icon: Symbols.print, onTap: onPrint)),
                      const SizedBox(width: AppDimensions.elementGapSm),
                      Expanded(child: _ActionChip(label: 'Share', icon: Symbols.share, onTap: onSharePdf)),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.elementGap),
                  GradientButton(
                    label: 'Generate Invoice',
                    icon: Symbols.receipt_long,
                    onPressed: canGenerate ? onGenerate : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        child: SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppDimensions.iconSizeSm, color: AppColors.primary),
              const SizedBox(height: AppDimensions.elementGapSm),
              Text(
                label,
                style: AppTypography.label(AppColors.textSecondary),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
