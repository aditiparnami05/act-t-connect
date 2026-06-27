import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../models/create_invoice_draft.dart';

/// Fixed gradient header for the create-invoice screen.
class InvoiceCreateHeader extends StatelessWidget {
  const InvoiceCreateHeader({
    super.key,
    required this.onBack,
    required this.onShare,
    required this.onPreview,
    required this.onMore,
  });

  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onPreview;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Material(
      elevation: 2,
      shadowColor: AppColors.primary.withValues(alpha: 0.25),
      child: Container(
        padding: EdgeInsets.only(top: topPadding),
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SizedBox(
          height: AppDimensions.appBarHeight,
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Symbols.arrow_back, color: Colors.white),
              ),
              Expanded(
                child: Text(
                  'Create Invoice',
                  textAlign: TextAlign.center,
                  style: AppTypography.sectionTitle(Colors.white),
                ),
              ),
              IconButton(
                onPressed: onShare,
                icon: const Icon(Symbols.share, color: Colors.white),
                tooltip: 'Share',
              ),
              IconButton(
                onPressed: onPreview,
                icon: const Icon(Symbols.visibility, color: Colors.white),
                tooltip: 'Preview',
              ),
              IconButton(
                onPressed: onMore,
                icon: const Icon(Symbols.more_vert, color: Colors.white),
                tooltip: 'More',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InvoiceMetaStrip extends StatelessWidget {
  const InvoiceMetaStrip({
    super.key,
    required this.draft,
    required this.onInvoiceDateTap,
    required this.onDueDateTap,
  });

  final CreateInvoiceDraft draft;
  final VoidCallback onInvoiceDateTap;
  final VoidCallback onDueDateTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenPaddingH,
        AppDimensions.space2,
        AppDimensions.screenPaddingH,
        AppDimensions.space1,
      ),
      child: AppCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _MetaTile(
                    icon: Symbols.tag,
                    label: 'Invoice No.',
                    value: draft.invoiceNumber,
                  ),
                ),
                const SizedBox(width: AppDimensions.elementGap),
                StatusChip(
                  label: _statusLabel(draft.status),
                  color: _statusColor(draft.status),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.elementGap),
            Row(
              children: [
                Expanded(
                  child: _MetaTile(
                    icon: Symbols.calendar_today,
                    label: 'Invoice Date',
                    value: DateFormatter.display(draft.invoiceDate),
                    onTap: onInvoiceDateTap,
                  ),
                ),
                const SizedBox(width: AppDimensions.elementGap),
                Expanded(
                  child: _MetaTile(
                    icon: Symbols.event,
                    label: 'Due Date',
                    value: DateFormatter.display(draft.dueDate),
                    onTap: onDueDateTap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(InvoiceDraftStatus status) {
    return switch (status) {
      InvoiceDraftStatus.draft => 'Draft',
      InvoiceDraftStatus.pending => 'Pending',
      InvoiceDraftStatus.sent => 'Sent',
    };
  }

  Color _statusColor(InvoiceDraftStatus status) {
    return switch (status) {
      InvoiceDraftStatus.draft => AppColors.textSecondary,
      InvoiceDraftStatus.pending => AppColors.warning,
      InvoiceDraftStatus.sent => AppColors.success,
    };
  }
}

class _MetaTile extends StatelessWidget {
  const _MetaTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.elementGap),
          child: Row(
            children: [
              Icon(icon, size: AppDimensions.iconSizeSm, color: AppColors.primary),
              const SizedBox(width: AppDimensions.elementGapSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTypography.label(AppColors.textSecondary)),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: AppTypography.caption(AppColors.textPrimary).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(Symbols.edit, size: 16, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Subtle panel for financial summary inside the Summary card.
class GlassSummaryPanel extends StatelessWidget {
  const GlassSummaryPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.card, AppColors.primary.withValues(alpha: 0.04)],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }
}
