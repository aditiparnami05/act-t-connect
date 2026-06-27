import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/models/party.dart';
import 'invoice_section_card.dart';
import 'invoice_shared_widgets.dart';

class InvoiceCustomerCard extends StatelessWidget {
  const InvoiceCustomerCard({
    super.key,
    required this.customer,
    required this.onSelectCustomer,
  });

  final Party? customer;
  final VoidCallback onSelectCustomer;

  @override
  Widget build(BuildContext context) {
    return InvoiceSectionCard(
      title: 'Customer',
      icon: Symbols.person,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (customer != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'invoice-customer-${customer!.id}',
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: Text(
                      customer!.name.isNotEmpty ? customer!.name[0].toUpperCase() : '?',
                      style: AppTypography.heading(AppColors.primary).copyWith(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.elementGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customer!.name, style: context.bodyStyle.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: AppDimensions.elementGapSm),
                      _InfoRow(icon: Symbols.call, text: customer!.phone),
                      if (customer!.gstin != null && customer!.gstin!.isNotEmpty) ...[
                        const SizedBox(height: AppDimensions.elementGapSm),
                        _InfoRow(icon: Symbols.receipt_long, text: 'GST: ${customer!.gstin}'),
                      ],
                      if (customer!.address != null && customer!.address!.isNotEmpty) ...[
                        const SizedBox(height: AppDimensions.elementGapSm),
                        _InfoRow(icon: Symbols.location_on, text: customer!.address!),
                      ],
                    ],
                  ),
                ),
              ],
            )
          else
            InvoiceEmptyState(
              icon: Symbols.person_add,
              message: 'No customer selected',
            ),
          const SizedBox(height: AppDimensions.space2),
          InvoiceActionButtonRow(
            outlineLabel: 'Select',
            outlineIcon: Symbols.group,
            onOutline: onSelectCustomer,
            filledLabel: 'Add New',
            filledIcon: Symbols.add,
            onFilled: () => context.push('${AppRoutes.customers}/add'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 15, color: AppColors.textSecondary),
        ),
        const SizedBox(width: AppDimensions.elementGapSm),
        Expanded(child: Text(text, style: context.captionStyle)),
      ],
    );
  }
}
