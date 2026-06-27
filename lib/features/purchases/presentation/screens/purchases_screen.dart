import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/loading_widgets.dart';
import '../../../../shared/models/purchase.dart';
import '../../../../shared/providers/data_providers.dart';

/// Purchase bills management.
class PurchasesScreen extends ConsumerWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasesAsync = ref.watch(purchasesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchases'),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: purchasesAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (purchases) => ResponsiveContainer(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 16),
            itemCount: purchases.length,
            itemBuilder: (context, index) {
              final purchase = purchases[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            purchase.billNumber,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          StatusChip(
                            label: purchase.paymentStatus.name.toUpperCase(),
                            color: _paymentColor(purchase.paymentStatus),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Vendor: ${purchase.supplierName}'),
                      Text(DateFormatter.display(purchase.date)),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${purchase.items.length} items'),
                          Text(
                            CurrencyFormatter.format(purchase.grandTotal),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      if (purchase.balanceDue > 0)
                        Text(
                          'Balance: ${CurrencyFormatter.format(purchase.balanceDue)}',
                          style: const TextStyle(color: AppColors.error, fontSize: 13),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create purchase bill')),
          );
        },
        icon: const Icon(Symbols.add),
        label: const Text('New Purchase'),
      ),
    );
  }

  Color _paymentColor(PaymentStatus status) {
    return switch (status) {
      PaymentStatus.paid => AppColors.success,
      PaymentStatus.partial => AppColors.warning,
      PaymentStatus.unpaid => AppColors.error,
    };
  }
}
