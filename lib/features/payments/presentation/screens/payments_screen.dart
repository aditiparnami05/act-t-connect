import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/loading_widgets.dart';
import '../../../../shared/models/payment.dart';
import '../../../../shared/providers/data_providers.dart';

/// Payments — receive, make, history, and outstanding.
class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentsAsync = ref.watch(paymentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'History'),
            Tab(text: 'Receive'),
            Tab(text: 'Make Payment'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          paymentsAsync.when(
            loading: () => const LoadingWidget(),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (payments) => _PaymentHistory(payments: payments),
          ),
          _PaymentForm(type: PaymentType.received),
          _PaymentForm(type: PaymentType.made),
        ],
      ),
    );
  }
}

class _PaymentHistory extends StatelessWidget {
  const _PaymentHistory({required this.payments});
  final List<Payment> payments;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          final isReceived = payment.type == PaymentType.received;
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (isReceived ? AppColors.success : AppColors.error)
                    .withValues(alpha: 0.1),
                child: Icon(
                  isReceived ? Symbols.arrow_downward : Symbols.arrow_upward,
                  color: isReceived ? AppColors.success : AppColors.error,
                  size: 20,
                ),
              ),
              title: Text(payment.partyName),
              subtitle: Text(
                '${DateFormatter.display(payment.date)} • ${payment.mode.name.toUpperCase()}',
              ),
              trailing: Text(
                '${isReceived ? '+' : '-'}${CurrencyFormatter.format(payment.amount)}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isReceived ? AppColors.success : AppColors.error,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PaymentForm extends StatelessWidget {
  const _PaymentForm({required this.type});
  final PaymentType type;

  @override
  Widget build(BuildContext context) {
    final isReceive = type == PaymentType.received;
    return ResponsiveContainer(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isReceive ? 'Receive Payment' : 'Make Payment',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(labelText: 'Select Party')),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Payment Mode')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Reference / Notes')),
            const Spacer(),
            GradientButton(
              label: isReceive ? 'Record Receipt' : 'Record Payment',
              icon: isReceive ? Symbols.arrow_downward : Symbols.arrow_upward,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isReceive ? 'Payment received recorded' : 'Payment made recorded',
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
