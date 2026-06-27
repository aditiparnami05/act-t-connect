import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../models/create_invoice_draft.dart';

class InvoiceProductLineCard extends StatelessWidget {
  const InvoiceProductLineCard({
    super.key,
    required this.line,
    required this.onEdit,
    required this.onDelete,
  });

  final InvoiceLineDraft line;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.elementGap),
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: const Icon(Symbols.inventory_2, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: AppDimensions.elementGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line.product.name,
                      style: context.bodyStyle.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppDimensions.elementGapSm),
                    Text(
                      'HSN: ${line.hsnCode} • ${line.product.category}',
                      style: context.captionStyle,
                    ),
                  ],
                ),
              ),
              _IconBtn(icon: Symbols.edit, color: AppColors.primary, onTap: onEdit),
              const SizedBox(width: AppDimensions.elementGapSm),
              _IconBtn(icon: Symbols.delete_outline, color: AppColors.error, onTap: onDelete),
            ],
          ),
          const SizedBox(height: AppDimensions.elementGap),
          LayoutBuilder(
            builder: (context, constraints) {
              final chipWidth = (constraints.maxWidth - AppDimensions.space2) / 3;
              return Wrap(
                spacing: AppDimensions.elementGapSm,
                runSpacing: AppDimensions.elementGapSm,
                children: [
                  _DetailChip(label: 'Qty', value: '${line.quantity}', width: chipWidth),
                  _DetailChip(label: 'Unit', value: line.product.unit, width: chipWidth),
                  _DetailChip(label: 'Price', value: CurrencyFormatter.format(line.rate), width: chipWidth),
                  _DetailChip(label: 'Disc.', value: '${line.discount.toStringAsFixed(0)}%', width: chipWidth),
                  _DetailChip(label: 'GST', value: '${line.product.gstRate.toStringAsFixed(0)}%', width: chipWidth),
                  _DetailChip(
                    label: 'Total',
                    value: CurrencyFormatter.format(line.lineTotal),
                    width: chipWidth,
                    highlight: true,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.color, required this.onTap});

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        icon: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({
    required this.label,
    required this.value,
    required this.width,
    this.highlight = false,
  });

  final String label;
  final String value;
  final double width;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.elementGap,
          vertical: AppDimensions.elementGapSm,
        ),
        decoration: BoxDecoration(
          color: highlight ? AppColors.primary.withValues(alpha: 0.08) : AppColors.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: Border.all(
            color: highlight ? AppColors.primary.withValues(alpha: 0.2) : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.label(AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption(
                highlight ? AppColors.primary : AppColors.textPrimary,
              ).copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
