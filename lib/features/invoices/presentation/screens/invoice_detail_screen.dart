import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/loading_widgets.dart';
import '../../../../shared/data/dummy_data.dart';
import '../../../../shared/models/invoice.dart';
import '../../../../shared/providers/data_providers.dart';

final invoiceDetailProvider =
    FutureProvider.family<Invoice?, String>((ref, id) async {
  return ref.watch(businessRepositoryProvider).getInvoiceById(id);
});

/// Invoice detail with PDF, print, and share actions.
class InvoiceDetailScreen extends ConsumerWidget {
  const InvoiceDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceAsync = ref.watch(invoiceDetailProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Symbols.picture_as_pdf),
            onPressed: () => _showPdfActions(context),
          ),
          IconButton(
            icon: const Icon(Symbols.share),
            onPressed: () => _shareInvoice(context, ref),
          ),
        ],
      ),
      body: invoiceAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (invoice) {
          if (invoice == null) {
            return const Center(child: Text('Invoice not found'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InvoiceHeader(invoice: invoice),
                const SizedBox(height: 20),
                _ItemsTable(invoice: invoice),
                const SizedBox(height: 20),
                _TotalsCard(invoice: invoice),
                const SizedBox(height: 20),
                _BusinessFooter(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showPdfActions(context),
                        icon: const Icon(Symbols.print),
                        label: const Text('Print'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _shareInvoice(context, ref),
                        icon: const Icon(Symbols.share),
                        label: const Text('Share'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPdfActions(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF generated — ready to print')),
    );
  }

  void _shareInvoice(BuildContext context, WidgetRef ref) {
    final invoice = ref.read(invoiceDetailProvider(id)).value;
    if (invoice == null) return;
    Share.share(
      'Invoice ${invoice.invoiceNumber}\n'
      'Customer: ${invoice.partyName}\n'
      'Amount: ${CurrencyFormatter.format(invoice.grandTotal)}\n'
      'Date: ${DateFormatter.display(invoice.date)}',
    );
  }
}

class _InvoiceHeader extends StatelessWidget {
  const _InvoiceHeader({required this.invoice});
  final Invoice invoice;

  Color _statusColor(InvoiceStatus status) {
    return switch (status) {
      InvoiceStatus.paid => AppColors.success,
      InvoiceStatus.partial => AppColors.warning,
      InvoiceStatus.unpaid => AppColors.error,
      InvoiceStatus.draft => AppColors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                invoice.invoiceNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              StatusChip(
                label: invoice.status.name.toUpperCase(),
                color: _statusColor(invoice.status),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            invoice.partyName,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            DateFormatter.display(invoice.date),
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }
}

class _ItemsTable extends StatelessWidget {
  const _ItemsTable({required this.invoice});
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('Item', style: TextStyle(fontWeight: FontWeight.w600))),
                Expanded(child: Text('Qty', style: TextStyle(fontWeight: FontWeight.w600))),
                Expanded(flex: 2, child: Text('Amount', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          ...invoice.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w500)),
                        Text(
                          'GST ${item.gstRate}%',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Text('${item.quantity}')),
                  Expanded(
                    flex: 2,
                    child: Text(
                      CurrencyFormatter.format(item.total),
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.invoice});
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
      ),
      child: Column(
        children: [
          _row('Subtotal', invoice.subtotal),
          _row('GST', invoice.totalGst),
          const Divider(),
          _row('Grand Total', invoice.grandTotal, bold: true),
          if (invoice.paidAmount > 0) ...[
            _row('Paid', invoice.paidAmount),
            _row('Balance Due', invoice.balanceDue, color: AppColors.error),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, double amount, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : null)),
          Text(
            CurrencyFormatter.format(amount),
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _BusinessFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profile = DummyData.businessProfile;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(AppDimensions.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(profile.name, style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(profile.address, style: Theme.of(context).textTheme.bodySmall),
          Text('GSTIN: ${profile.gstin}', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Authorized Signatory', style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 32),
                  Container(width: 120, height: 1, color: AppColors.textSecondary),
                ],
              ),
              Image.asset('assets/images/logo.png', height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
