import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common_widgets.dart';

/// Employee management screen.
class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  static const _employees = [
    ('Rajesh Kumar', 'Admin', 'admin@acttconnect.com'),
    ('Priya Sharma', 'Accountant', 'priya@acttconnect.com'),
    ('Amit Patel', 'Sales Manager', 'amit@acttconnect.com'),
    ('Sneha Reddy', 'Inventory Manager', 'sneha@acttconnect.com'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ResponsiveContainer(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 16),
          itemCount: _employees.length,
          itemBuilder: (context, index) {
            final (name, role, email) = _employees[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    name[0],
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('$role • $email'),
                trailing: const Icon(Symbols.chevron_right, size: 20),
                onTap: () {},
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Symbols.person_add),
        label: const Text('Add Employee'),
      ),
    );
  }
}
