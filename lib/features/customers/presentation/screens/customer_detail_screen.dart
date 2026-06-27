import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/loading_widgets.dart';
import '../../../../shared/providers/data_providers.dart';
import '../../../../shared/models/party.dart';

final customerDetailProvider =
    FutureProvider.family<Party?, String>((ref, id) async {
  return ref.watch(businessRepositoryProvider).getPartyById(id);
});

/// Customer detail with contact actions and transactions.
class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNew = id == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? 'Add Customer' : 'Customer Details'),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: isNew
          ? const _AddCustomerForm()
          : ref.watch(customerDetailProvider(id!)).when(
              loading: () => const LoadingWidget(),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (party) {
                if (party == null) {
                  return const Center(child: Text('Customer not found'));
                }
                return _CustomerDetailBody(party: party);
              },
            ),
    );
  }
}

class _CustomerDetailBody extends StatelessWidget {
  const _CustomerDetailBody({required this.party});
  final Party party;

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.padding),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radius),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Text(
                    party.name[0],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  party.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  party.city ?? '',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _ContactButton(
                  icon: Symbols.call,
                  label: 'Call',
                  onTap: () => _launch(Uri.parse('tel:${party.phone}')),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ContactButton(
                  icon: Symbols.chat,
                  label: 'WhatsApp',
                  onTap: () => _launch(
                    Uri.parse(
                      'https://wa.me/${party.phone.replaceAll(RegExp(r'[^\d]'), '')}',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ContactButton(
                  icon: Symbols.mail,
                  label: 'Email',
                  onTap: () => _launch(Uri.parse('mailto:${party.email}')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _DetailCard(
            title: 'Outstanding Balance',
            value: CurrencyFormatter.format(party.outstandingBalance),
            color: party.outstandingBalance > 0 ? AppColors.error : AppColors.success,
          ),
          const SizedBox(height: 12),
          _DetailCard(title: 'Phone', value: party.phone),
          const SizedBox(height: 12),
          _DetailCard(title: 'Email', value: party.email),
          if (party.gstin != null) ...[
            const SizedBox(height: 12),
            _DetailCard(title: 'GSTIN', value: party.gstin!),
          ],
          const SizedBox(height: 24),
          const SectionHeader(title: 'Recent Transactions'),
          const SizedBox(height: 8),
          ...List.generate(
            3,
            (i) => ListTile(
              leading: const Icon(Symbols.receipt_long, color: AppColors.primary),
              title: Text('Invoice INV-2026-${140 - i}'),
              subtitle: const Text('2 days ago'),
              trailing: Text(
                CurrencyFormatter.format(15000 - i * 2000),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.value, this.color});

  final String title;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}

class _AddCustomerForm extends StatelessWidget {
  const _AddCustomerForm();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.padding),
      child: Column(
        children: [
          const TextField(decoration: InputDecoration(labelText: 'Customer Name')),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Phone')),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Email')),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'GSTIN (Optional)')),
          const Spacer(),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Customer saved successfully')),
              );
              context.pop();
            },
            child: const Text('Save Customer'),
          ),
        ],
      ),
    );
  }
}
