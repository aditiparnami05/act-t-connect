import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../models/create_invoice_draft.dart';
import 'invoice_create_header.dart';
import 'invoice_section_card.dart';

class InvoiceSummaryCard extends StatelessWidget {
  const InvoiceSummaryCard({
    super.key,
    required this.draft,
    required this.onShippingChanged,
    required this.onRoundOffChanged,
  });

  final CreateInvoiceDraft draft;
  final ValueChanged<double> onShippingChanged;
  final ValueChanged<double> onRoundOffChanged;

  @override
  Widget build(BuildContext context) {
    return InvoiceSectionCard(
      title: 'Summary',
      icon: Symbols.calculate,
      child: GlassSummaryPanel(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppLabelValueRow(
                label: 'Subtotal',
                value: CurrencyFormatter.format(draft.itemsSubtotal),
              ),
              AppLabelValueRow(
                label: 'Discount',
                value: '-${CurrencyFormatter.format(draft.itemsDiscount)}',
              ),
              _EditableSummaryRow(
                label: 'Shipping',
                value: draft.shipping,
                onChanged: onShippingChanged,
              ),
              AppLabelValueRow(
                label: 'Tax (GST)',
                value: CurrencyFormatter.format(draft.tax),
              ),
              _EditableSummaryRow(
                label: 'Round Off',
                value: draft.roundOff,
                onChanged: onRoundOffChanged,
              ),
              const AppDivider(),
              InvoiceGrandTotalRow(amount: draft.grandTotal),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditableSummaryRow extends StatelessWidget {
  const _EditableSummaryRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.elementGapSm),
      child: Row(
        children: [
          Expanded(child: Text(label, style: context.captionStyle)),
          InvoiceNumericField(value: value, onChanged: onChanged, prefixText: '₹ '),
        ],
      ),
    );
  }
}
