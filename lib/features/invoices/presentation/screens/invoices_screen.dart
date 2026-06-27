import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_widgets.dart';
import '../../../../core/widgets/search_bar_widget.dart';
import '../../../../shared/models/invoice.dart';
import '../../../../shared/providers/data_providers.dart';
import '../../../shell/presentation/widgets/app_top_bar.dart';

/// Invoice list with search and status filters.
class InvoicesScreen extends ConsumerStatefulWidget {
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  final _searchController = TextEditingController();
  InvoiceStatus? _filter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(invoicesProvider);

    return Scaffold(
      appBar: const AppTopBar(title: 'Invoices', showDrawer: true),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(invoicesProvider),
        child: invoicesAsync.when(
          loading: () => const LoadingWidget(message: 'Loading invoices...'),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (invoices) {
            final filtered = _filterInvoices(invoices);
            return ResponsiveContainer(
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SearchBarWidget(
                          controller: _searchController,
                          hint: 'Search invoices...',
                          onChanged: (_) => setState(() {}),
                          onFilterTap: _showFilterSheet,
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _FilterChip(
                                label: 'All',
                                selected: _filter == null,
                                onTap: () => setState(() => _filter = null),
                              ),
                              ...InvoiceStatus.values.map(
                                (s) => _FilterChip(
                                  label: s.name.capitalize,
                                  selected: _filter == s,
                                  onTap: () => setState(() => _filter = s),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  if (filtered.isEmpty)
                    const SliverFillRemaining(
                      child: EmptyStateWidget(
                        title: 'No invoices found',
                        subtitle: 'Create your first invoice to get started',
                        icon: Symbols.receipt_long,
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _InvoiceCard(
                          invoice: filtered[index],
                          onTap: () => context.push(
                            '${AppRoutes.invoices}/${filtered[index].id}',
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
      ),
    );
  }

  List<Invoice> _filterInvoices(List<Invoice> invoices) {
    final query = _searchController.text.toLowerCase();
    return invoices.where((inv) {
      final matchesSearch = query.isEmpty ||
          inv.invoiceNumber.toLowerCase().contains(query) ||
          inv.partyName.toLowerCase().contains(query);
      final matchesFilter = _filter == null || inv.status == _filter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _showFilterSheet() {
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
            Text('Filter Invoices', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...InvoiceStatus.values.map(
              (s) => ListTile(
                title: Text(s.name.capitalize),
                trailing: _filter == s ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _filter = s);
                  Navigator.pop(ctx);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary.withValues(alpha: 0.15),
        checkmarkColor: AppColors.primary,
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({required this.invoice, required this.onTap});

  final Invoice invoice;
  final VoidCallback onTap;

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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Symbols.receipt_long, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.invoiceNumber,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(invoice.partyName, style: Theme.of(context).textTheme.bodySmall),
                    Text(
                      DateFormatter.display(invoice.date),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(invoice.grandTotal),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  StatusChip(
                    label: invoice.status.name.capitalize,
                    color: _statusColor(invoice.status),
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
