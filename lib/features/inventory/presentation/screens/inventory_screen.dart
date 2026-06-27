import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_widgets.dart';
import '../../../../core/widgets/search_bar_widget.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/providers/data_providers.dart';
import '../../../shell/presentation/widgets/app_top_bar.dart';

/// Inventory management with categories, stock status, and barcode search.
class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final _searchController = TextEditingController();
  String? _categoryFilter;
  StockStatus? _stockFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: 'Inventory',
        actions: [
          IconButton(
            icon: const Icon(Symbols.barcode_scanner),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Barcode scanner ready — camera integration pending')),
              );
            },
          ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const LoadingWidget(message: 'Loading inventory...'),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (products) {
          final filtered = _filterProducts(products);
          return ResponsiveContainer(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SearchBarWidget(
                        controller: _searchController,
                        hint: 'Search products, SKU, barcode...',
                        onChanged: (_) => setState(() {}),
                        onFilterTap: () => _showFilters(categoriesAsync.value ?? []),
                      ),
                      const SizedBox(height: 12),
                      _StockSummaryBar(products: products),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                if (filtered.isEmpty)
                  const SliverFillRemaining(
                    child: EmptyStateWidget(
                      title: 'No products found',
                      subtitle: 'Try adjusting your search or filters',
                      icon: Symbols.inventory_2,
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _ProductCard(
                        product: filtered[index],
                        onTap: () => context.push(
                          '${AppRoutes.inventory}/${filtered[index].id}',
                        ),
                      ),
                      childCount: filtered.length,
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductSheet(context),
        icon: const Icon(Symbols.add),
        label: const Text('Add Product'),
      ),
    );
  }

  List<Product> _filterProducts(List<Product> products) {
    final query = _searchController.text.toLowerCase();
    return products.where((p) {
      final matchesSearch = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.sku.toLowerCase().contains(query) ||
          (p.barcode?.contains(query) ?? false);
      final matchesCategory = _categoryFilter == null || p.category == _categoryFilter;
      final matchesStock = _stockFilter == null || p.stockStatus == _stockFilter;
      return matchesSearch && matchesCategory && matchesStock;
    }).toList();
  }

  void _showFilters(List<String> categories) {
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
            Text('Filters', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text('Category', style: Theme.of(ctx).textTheme.titleSmall),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _categoryFilter == null,
                  onSelected: (_) {
                    setState(() => _categoryFilter = null);
                    Navigator.pop(ctx);
                  },
                ),
                ...categories.map(
                  (c) => FilterChip(
                    label: Text(c),
                    selected: _categoryFilter == c,
                    onSelected: (_) {
                      setState(() => _categoryFilter = c);
                      Navigator.pop(ctx);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Stock Status', style: Theme.of(ctx).textTheme.titleSmall),
            Wrap(
              spacing: 8,
              children: StockStatus.values.map((s) {
                final label = switch (s) {
                  StockStatus.inStock => 'In Stock',
                  StockStatus.lowStock => 'Low Stock',
                  StockStatus.outOfStock => 'Out of Stock',
                };
                return FilterChip(
                  label: Text(label),
                  selected: _stockFilter == s,
                  onSelected: (_) {
                    setState(() => _stockFilter = s);
                    Navigator.pop(ctx);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductSheet(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add product form — connect to repository')),
    );
  }
}

class _StockSummaryBar extends StatelessWidget {
  const _StockSummaryBar({required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final inStock = products.where((p) => p.stockStatus == StockStatus.inStock).length;
    final low = products.where((p) => p.stockStatus == StockStatus.lowStock).length;
    final out = products.where((p) => p.stockStatus == StockStatus.outOfStock).length;
    final totalValue = products.fold<double>(0, (s, p) => s + p.stockValue);

    return Row(
      children: [
        Expanded(child: _MiniStat('In Stock', '$inStock', AppColors.success)),
        const SizedBox(width: 8),
        Expanded(child: _MiniStat('Low', '$low', AppColors.warning)),
        const SizedBox(width: 8),
        Expanded(child: _MiniStat('Out', '$out', AppColors.error)),
        const SizedBox(width: 8),
        Expanded(
          child: _MiniStat(
            'Value',
            CurrencyFormatter.formatCompact(totalValue),
            AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat(this.label, this.value, this.color);
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 14)),
          Text(label, style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  Color _stockColor(StockStatus status) {
    return switch (status) {
      StockStatus.inStock => AppColors.success,
      StockStatus.lowStock => AppColors.warning,
      StockStatus.outOfStock => AppColors.error,
    };
  }

  String _stockLabel(StockStatus status) {
    return switch (status) {
      StockStatus.inStock => 'In Stock',
      StockStatus.lowStock => 'Low Stock',
      StockStatus.outOfStock => 'Out of Stock',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.softGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Symbols.inventory_2, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      '${product.sku} • ${product.category}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      CurrencyFormatter.format(product.sellingPrice),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${product.stock} ${product.unit}', style: const TextStyle(fontWeight: FontWeight.w700)),
                  StatusChip(
                    label: _stockLabel(product.stockStatus),
                    color: _stockColor(product.stockStatus),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
