import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../models/create_invoice_draft.dart';
import 'invoice_section_card.dart';

class InvoicePaymentSection extends StatelessWidget {
  const InvoicePaymentSection({
    super.key,
    required this.draft,
    required this.onMethodChanged,
    required this.onStatusChanged,
    required this.onAmountReceivedChanged,
  });

  final CreateInvoiceDraft draft;
  final ValueChanged<PaymentMethod> onMethodChanged;
  final ValueChanged<PaymentStatus> onStatusChanged;
  final ValueChanged<double> onAmountReceivedChanged;

  static const _methods = [
    (PaymentMethod.cash, 'Cash', Symbols.payments),
    (PaymentMethod.upi, 'UPI', Symbols.qr_code_2),
    (PaymentMethod.card, 'Card', Symbols.credit_card),
    (PaymentMethod.bank, 'Bank', Symbols.account_balance),
    (PaymentMethod.credit, 'Credit', Symbols.schedule),
  ];

  static const _statuses = [
    (PaymentStatus.paid, 'Paid'),
    (PaymentStatus.partial, 'Partial'),
    (PaymentStatus.pending, 'Pending'),
  ];

  @override
  Widget build(BuildContext context) {
    return InvoiceSectionCard(
      title: 'Payment',
      icon: Symbols.account_balance_wallet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Payment Method', style: AppTypography.label(AppColors.textPrimary)),
          const SizedBox(height: AppDimensions.elementGap),
          Wrap(
            spacing: AppDimensions.elementGapSm,
            runSpacing: AppDimensions.elementGapSm,
            children: _methods.map((m) {
              return InvoiceChoiceChip(
                label: m.$2,
                icon: m.$3,
                selected: draft.paymentMethod == m.$1,
                onTap: () => onMethodChanged(m.$1),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.space2),
          Text('Payment Status', style: AppTypography.label(AppColors.textPrimary)),
          const SizedBox(height: AppDimensions.elementGap),
          Wrap(
            spacing: AppDimensions.elementGapSm,
            runSpacing: AppDimensions.elementGapSm,
            children: _statuses.map((s) {
              return InvoiceChoiceChip(
                label: s.$2,
                selected: draft.paymentStatus == s.$1,
                onTap: () => onStatusChanged(s.$1),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.space2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _AmountField(
                  label: 'Amount Received',
                  value: draft.amountReceived,
                  onChanged: onAmountReceivedChanged,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppDimensions.elementGap),
              Expanded(
                child: _AmountDisplay(
                  label: 'Balance Due',
                  amount: draft.balanceDue,
                  color: draft.balanceDue > 0 ? AppColors.error : AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.color,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label(AppColors.textSecondary)),
          const SizedBox(height: AppDimensions.elementGapSm),
          InvoiceNumericField(
            value: value,
            onChanged: onChanged,
            width: double.infinity,
            prefixText: '₹ ',
            textStyle: AppTypography.heading(color).copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class _AmountDisplay extends StatelessWidget {
  const _AmountDisplay({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label(AppColors.textSecondary)),
          const SizedBox(height: AppDimensions.elementGapSm),
          AnimatedCurrencyText(
            amount: amount,
            formatter: CurrencyFormatter.format,
            style: AppTypography.heading(color).copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
