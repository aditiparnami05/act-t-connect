import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/loading_widgets.dart';
import '../../../../shared/models/party.dart';
import '../../../../shared/providers/data_providers.dart';
import '../../../shell/presentation/widgets/shell_scope.dart';

/// Parties hub — customers and suppliers overview.
class PartiesScreen extends ConsumerWidget {
  const PartiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customersProvider);
    final suppliersAsync = ref.watch(suppliersProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Symbols.menu),
            onPressed: () => ShellScope.maybeOf(context)?.openDrawer(),
          ),
          title: const Text('Parties'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Customers', icon: Icon(Symbols.person, size: 20)),
              Tab(text: 'Suppliers', icon: Icon(Symbols.local_shipping, size: 20)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _PartyList(
              partiesAsync: customersAsync,
              emptyIcon: Symbols.person,
              onTap: (id) => context.push('${AppRoutes.customers}/$id'),
              onAdd: () => context.push('${AppRoutes.customers}/add'),
            ),
            _PartyList(
              partiesAsync: suppliersAsync,
              emptyIcon: Symbols.local_shipping,
              onTap: (_) => context.push(AppRoutes.suppliers),
              onAdd: () => context.push(AppRoutes.suppliers),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartyList extends StatelessWidget {
  const _PartyList({
    required this.partiesAsync,
    required this.emptyIcon,
    required this.onTap,
    required this.onAdd,
  });

  final AsyncValue<List<Party>> partiesAsync;
  final IconData emptyIcon;
  final ValueChanged<String> onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return partiesAsync.when(
      loading: () => const LoadingWidget(),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (parties) => ResponsiveContainer(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 16, bottom: 80),
          itemCount: parties.length,
          itemBuilder: (context, index) {
            final party = parties[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    party.name[0],
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(party.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${party.city ?? ''} • ${party.phone}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyFormatter.format(party.outstandingBalance),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: party.outstandingBalance > 0
                            ? AppColors.error
                            : AppColors.success,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      party.outstandingBalance > 0 ? 'Outstanding' : 'Clear',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                onTap: () => onTap(party.id),
              ),
            );
          },
        ),
      ),
    );
  }
}
