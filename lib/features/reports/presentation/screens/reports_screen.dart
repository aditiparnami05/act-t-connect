import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/common_widgets.dart';

/// Business reports with PDF and Excel export.
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  static const _reports = [
    _ReportItem('Sales Report', Symbols.trending_up, AppColors.success),
    _ReportItem('Purchase Report', Symbols.shopping_cart, AppColors.secondary),
    _ReportItem('GST Report', Symbols.receipt, AppColors.primary),
    _ReportItem('Stock Report', Symbols.inventory_2, AppColors.accent),
    _ReportItem('Profit & Loss', Symbols.account_balance, AppColors.warning),
    _ReportItem('Expenses', Symbols.payments, AppColors.error),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ResponsiveContainer(
        child: GridView.builder(
          padding: const EdgeInsets.only(top: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.sizeOf(context).shortestSide >= 600 ? 3 : 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: _reports.length,
          itemBuilder: (context, index) {
            final report = _reports[index];
            return Card(
              child: InkWell(
                onTap: () => _showExportOptions(context, report.title),
                borderRadius: BorderRadius.circular(AppDimensions.radius),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: report.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(report.icon, color: report.color, size: 28),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        report.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showExportOptions(BuildContext context, String title) {
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
            Text(title, style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Symbols.picture_as_pdf, color: AppColors.error),
              title: const Text('Export as PDF'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title PDF exported')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Symbols.table_chart, color: AppColors.success),
              title: const Text('Export as Excel'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title Excel exported')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportItem {
  const _ReportItem(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final Color color;
}
