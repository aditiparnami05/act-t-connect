import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/action_tile.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/loading_widgets.dart';
import '../../../../core/widgets/summary_card.dart';
import '../../../../shared/models/transaction.dart';
import '../../../../shared/providers/data_providers.dart';
import '../../../shell/presentation/widgets/app_top_bar.dart';

/// Home dashboard with KPIs, charts, and quick actions.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final columns = context.gridColumns(phone: 2, tablet: 3, desktop: 6);

    return Scaffold(
      appBar: const AppTopBar(showGreeting: true),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(dashboardStatsProvider);
          ref.invalidate(transactionsProvider);
        },
        child: statsAsync.when(
          loading: () => const CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: DashboardSkeleton()),
              SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          error: (e, _) => CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(child: Center(child: Text('Error: $e'))),
            ],
          ),
          data: (stats) => ResponsiveContainer(
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppDimensions.space1),
                      GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: AppDimensions.space2,
                          crossAxisSpacing: AppDimensions.space2,
                          mainAxisExtent: context.isTablet ? 96 : 104,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          SummaryCard(
                            title: "Today's Sales",
                            value: CurrencyFormatter.formatCompact(stats.todaysSales),
                            icon: Symbols.trending_up,
                            color: AppColors.success,
                          ),
                          SummaryCard(
                            title: "Today's Purchase",
                            value: CurrencyFormatter.formatCompact(stats.todaysPurchase),
                            icon: Symbols.shopping_bag,
                            color: AppColors.secondary,
                          ),
                          SummaryCard(
                            title: 'Outstanding Payments',
                            value: CurrencyFormatter.formatCompact(stats.outstandingPayments),
                            icon: Symbols.arrow_upward,
                            color: AppColors.error,
                          ),
                          SummaryCard(
                            title: 'Outstanding Receipts',
                            value: CurrencyFormatter.formatCompact(stats.outstandingReceipts),
                            icon: Symbols.arrow_downward,
                            color: AppColors.warning,
                          ),
                          SummaryCard(
                            title: 'Inventory Value',
                            value: CurrencyFormatter.formatCompact(stats.inventoryValue),
                            icon: Symbols.warehouse,
                            color: AppColors.primary,
                          ),
                          SummaryCard(
                            title: 'Profit',
                            value: CurrencyFormatter.formatCompact(stats.profit),
                            icon: Symbols.account_balance_wallet,
                            color: AppColors.success,
                            useGradient: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.sectionGap),
                      const SectionHeader(title: 'Quick Actions'),
                      GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: context.gridColumns(phone: 4, tablet: 4, desktop: 8),
                          mainAxisSpacing: AppDimensions.space2,
                          crossAxisSpacing: AppDimensions.space2,
                          mainAxisExtent: context.isTablet ? 120 : 112,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ActionTile(
                            label: 'Create Invoice',
                            icon: Symbols.receipt_long,
                            index: 0,
                            onTap: () => context.push(AppRoutes.invoiceCreate),
                          ),
                          ActionTile(
                            label: 'Purchase',
                            icon: Symbols.shopping_cart,
                            index: 1,
                            color: AppColors.secondary,
                            onTap: () => context.push(AppRoutes.purchases),
                          ),
                          ActionTile(
                            label: 'Add Customer',
                            icon: Symbols.person_add,
                            index: 2,
                            onTap: () => context.push('${AppRoutes.customers}/add'),
                          ),
                          ActionTile(
                            label: 'Add Supplier',
                            icon: Symbols.local_shipping,
                            index: 3,
                            color: AppColors.accent,
                            onTap: () => context.push(AppRoutes.suppliers),
                          ),
                          ActionTile(
                            label: 'Inventory',
                            icon: Symbols.inventory_2,
                            index: 4,
                            onTap: () => context.go(AppRoutes.inventory),
                          ),
                          ActionTile(
                            label: 'Reports',
                            icon: Symbols.assessment,
                            index: 5,
                            onTap: () => context.push(AppRoutes.reports),
                          ),
                          ActionTile(
                            label: 'Expenses',
                            icon: Symbols.payments,
                            index: 6,
                            onTap: () => context.push(AppRoutes.expenses),
                          ),
                          ActionTile(
                            label: 'Payments',
                            icon: Symbols.account_balance,
                            index: 8,
                            onTap: () => context.push(AppRoutes.payments),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (context.isTablet)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _WeeklySalesChart(data: stats.weeklySales)),
                            const SizedBox(width: 16),
                            Expanded(child: _MonthlyRevenueChart(data: stats.monthlyRevenue)),
                          ],
                        )
                      else ...[
                        _WeeklySalesChart(data: stats.weeklySales),
                        const SizedBox(height: 16),
                        _MonthlyRevenueChart(data: stats.monthlyRevenue),
                      ],
                      const SizedBox(height: 16),
                      _StockOverviewChart(overview: stats.stockOverview),
                      const SizedBox(height: 24),
                      const SectionHeader(title: 'Recent Transactions'),
                    ],
                  ),
                ),
                transactionsAsync.when(
                  loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: LoadingWidget(),
                    ),
                  ),
                  error: (e, _) => SliverToBoxAdapter(child: Text('Error: $e')),
                  data: (transactions) => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _TransactionTile(
                        transaction: transactions[index],
                        index: index,
                      ),
                      childCount: transactions.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeeklySalesChart extends StatelessWidget {
  const _WeeklySalesChart({required this.data});
  final List<double> data;

  @override
  Widget build(BuildContext context) {
    final maxY = data.isEmpty ? 1.0 : data.reduce((a, b) => a > b ? a : b) * 1.2;

    return _ChartCard(
      title: 'Weekly Sales',
      subtitle: 'Last 7 days',
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY,
            barTouchData: BarTouchData(enabled: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                    return Text(days[v.toInt() % 7], style: const TextStyle(fontSize: 11));
                  },
                ),
              ),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(
              data.length,
              (i) => BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: data[i],
                    gradient: AppColors.primaryGradient,
                    width: 16,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthlyRevenueChart extends StatelessWidget {
  const _MonthlyRevenueChart({required this.data});
  final List<double> data;

  @override
  Widget build(BuildContext context) {
    return _ChartCard(
      title: 'Monthly Revenue',
      subtitle: 'Last 6 months',
      child: SizedBox(
        height: 180,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 100000,
              getDrawingHorizontalLine: (v) => FlLine(
                color: AppColors.textSecondary.withValues(alpha: 0.1),
                strokeWidth: 1,
              ),
            ),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  data.length,
                  (i) => FlSpot(i.toDouble(), data[i]),
                ),
                isCurved: true,
                gradient: AppColors.primaryGradient,
                barWidth: 3,
                dotData: FlDotData(
                  getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.primary,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.primary.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StockOverviewChart extends StatelessWidget {
  const _StockOverviewChart({required this.overview});
  final Map<String, int> overview;

  @override
  Widget build(BuildContext context) {
    final colors = [AppColors.success, AppColors.warning, AppColors.error];
    final entries = overview.entries.toList();
    final total = entries.fold<int>(0, (sum, e) => sum + e.value);

    return _ChartCard(
      title: 'Stock Overview',
      subtitle: '$total total items',
      child: SizedBox(
        height: 160,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: List.generate(entries.length, (i) {
                    final e = entries[i];
                    final percent = total == 0 ? 0 : ((e.value / total) * 100).round();
                    return PieChartSectionData(
                      value: e.value.toDouble(),
                      title: '$percent%',
                      color: colors[i % colors.length],
                      radius: 50,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(entries.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: colors[i % colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${entries[i].key} (${entries[i].value})',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.padding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction, required this.index});

  final Transaction transaction;
  final int index;

  IconData _iconForType(TransactionType type) {
    return switch (type) {
      TransactionType.sale => Symbols.receipt_long,
      TransactionType.purchase => Symbols.shopping_cart,
      TransactionType.payment => Symbols.payment,
      TransactionType.receipt => Symbols.account_balance_wallet,
      TransactionType.expense => Symbols.payments,
    };
  }

  Color _colorForType(TransactionType type) {
    return switch (type) {
      TransactionType.sale => AppColors.success,
      TransactionType.purchase => AppColors.secondary,
      TransactionType.payment => AppColors.error,
      TransactionType.receipt => AppColors.success,
      TransactionType.expense => AppColors.warning,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(transaction.type);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_iconForType(transaction.type), color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  '${transaction.subtitle} • ${DateFormatter.display(transaction.date)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '${transaction.isCredit ? '+' : '-'}${CurrencyFormatter.format(transaction.amount)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: transaction.isCredit ? AppColors.success : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: (50 * index).ms)
        .slideX(begin: 0.05, end: 0);
  }
}
