import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/loading_widgets.dart';
import '../../../../shared/models/party.dart';
import '../../../../shared/models/purchase.dart';
import '../../../../shared/providers/data_providers.dart';

/// Supplier management with outstanding and purchase history.
class SuppliersScreen extends ConsumerWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliersAsync = ref.watch(suppliersProvider);
    final purchasesAsync = ref.watch(purchasesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: suppliersAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (suppliers) => ResponsiveContainer(
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SectionHeader(title: 'Suppliers'),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _SupplierCard(supplier: suppliers[index]),
                  childCount: suppliers.length,
                ),
              ),
              SliverToBoxAdapter(
                child: purchasesAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, e) => const SizedBox.shrink(),
                  data: (purchases) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const SectionHeader(title: 'Purchase History'),
                      ...purchases.map((p) => _PurchaseTile(purchase: p)),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupplierCard extends StatelessWidget {
  const _SupplierCard({required this.supplier});
  final Party supplier;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
          child: const Icon(Symbols.local_shipping, color: AppColors.secondary),
        ),
        title: Text(supplier.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${supplier.city} • ${supplier.phone}'),
        trailing: Text(
          CurrencyFormatter.format(supplier.outstandingBalance),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: supplier.outstandingBalance > 0 ? AppColors.error : AppColors.success,
          ),
        ),
      ),
    );
  }
}

class _PurchaseTile extends StatelessWidget {
  const _PurchaseTile({required this.purchase});
  final Purchase purchase;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Symbols.shopping_cart, color: AppColors.secondary),
      title: Text(purchase.billNumber),
      subtitle: Text('${purchase.supplierName} • ${DateFormatter.display(purchase.date)}'),
      trailing: Text(
        CurrencyFormatter.format(purchase.grandTotal),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
