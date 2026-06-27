import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/loading_widgets.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/providers/data_providers.dart';

final productDetailProvider =
    FutureProvider.family<Product?, String>((ref, id) async {
  return ref.watch(businessRepositoryProvider).getProductById(id);
});

/// Product detail with stock adjustment.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Symbols.edit), onPressed: () {}),
        ],
      ),
      body: productAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (product) {
          if (product == null) return const Center(child: Text('Product not found'));
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppDimensions.radius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${product.sku} • ${product.category}',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _InfoGrid(product: product),
                const SizedBox(height: 20),
                Text('Stock Adjustment', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                GradientButton(
                  label: 'Adjust Stock',
                  icon: Symbols.tune,
                  onPressed: () => _showStockAdjustment(context, product),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showStockAdjustment(BuildContext context, Product product) {
    final controller = TextEditingController(text: '${product.stock}');
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Adjust Stock', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'New Stock Quantity'),
            ),
            const SizedBox(height: 20),
            GradientButton(
              label: 'Save Adjustment',
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Stock updated successfully')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _InfoTile('Selling Price', CurrencyFormatter.format(product.sellingPrice)),
        _InfoTile('Purchase Price', CurrencyFormatter.format(product.purchasePrice)),
        _InfoTile('Stock', '${product.stock} ${product.unit}'),
        _InfoTile('Stock Value', CurrencyFormatter.format(product.stockValue)),
        _InfoTile('GST Rate', '${product.gstRate}%'),
        _InfoTile('Barcode', product.barcode ?? 'N/A'),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        ],
      ),
    );
  }
}
