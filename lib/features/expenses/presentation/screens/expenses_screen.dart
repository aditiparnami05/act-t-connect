import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/common_widgets.dart';

/// Expense tracking screen.
class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  static final _expenses = [
    ('Office Rent', 25000, 'Monthly', Symbols.apartment),
    ('Electricity Bill', 4500, 'Utilities', Symbols.bolt),
    ('Internet & Phone', 3200, 'Utilities', Symbols.wifi),
    ('Staff Salaries', 85000, 'Payroll', Symbols.badge),
    ('Transport', 6800, 'Logistics', Symbols.local_shipping),
  ];

  @override
  Widget build(BuildContext context) {
    final total = _expenses.fold<double>(0, (s, e) => s + e.$2.toDouble());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ResponsiveContainer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Expenses (This Month)',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    CurrencyFormatter.format(total),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  final (title, amount, category, icon) = _expenses[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.error.withValues(alpha: 0.1),
                        child: Icon(icon, color: AppColors.error, size: 20),
                      ),
                      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(category),
                      trailing: Text(
                        CurrencyFormatter.format(amount.toDouble()),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Symbols.add),
        label: const Text('Add Expense'),
      ),
    );
  }
}
