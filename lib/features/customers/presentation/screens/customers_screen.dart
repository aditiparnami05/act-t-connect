import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_widgets.dart';
import '../../../../core/widgets/search_bar_widget.dart';
import '../../../../shared/models/party.dart';
import '../../../../shared/providers/data_providers.dart';

/// Customer list with search and filters.
class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: customersAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (customers) {
          final filtered = customers.where((c) {
            final q = _searchController.text.toLowerCase();
            return q.isEmpty ||
                c.name.toLowerCase().contains(q) ||
                c.phone.contains(q);
          }).toList();

          return ResponsiveContainer(
            child: Column(
              children: [
                SearchBarWidget(
                  controller: _searchController,
                  hint: 'Search customers...',
                  onChanged: (_) => setState(() {}),
                  showFilter: false,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filtered.isEmpty
                      ? const EmptyStateWidget(
                          title: 'No customers found',
                          icon: Symbols.person,
                        )
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (_, i) => _CustomerCard(
                            customer: filtered[i],
                            onTap: () => context.push('/customers/${filtered[i].id}'),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/customers/add'),
        icon: const Icon(Symbols.person_add),
        label: const Text('Add Customer'),
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.customer, required this.onTap});

  final Party customer;
  final VoidCallback onTap;

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
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  customer.name[0],
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(customer.phone, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(customer.outstandingBalance),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: customer.outstandingBalance > 0
                          ? AppColors.error
                          : AppColors.success,
                    ),
                  ),
                  const Text('Outstanding', style: TextStyle(fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
