import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/loading_widgets.dart';
import '../../../../shared/providers/data_providers.dart';

/// Analytics dashboard with advanced charts.
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: statsAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (stats) => ResponsiveContainer(
          child: ListView(
            padding: const EdgeInsets.only(top: 16, bottom: 32),
            children: [
              _MetricRow(
                items: [
                  _Metric('Revenue', CurrencyFormatter.formatCompact(stats.monthlyRevenue.last)),
                  _Metric('Profit', CurrencyFormatter.formatCompact(stats.profit)),
                  _Metric('Inventory', CurrencyFormatter.formatCompact(stats.inventoryValue)),
                ],
              ),
              const SizedBox(height: 20),
              _ChartCard(
                title: 'Revenue Trend',
                child: SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            stats.monthlyRevenue.length,
                            (i) => FlSpot(i.toDouble(), stats.monthlyRevenue[i]),
                          ),
                          isCurved: true,
                          color: AppColors.primary,
                          barWidth: 3,
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.primary.withValues(alpha: 0.1),
                          ),
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _ChartCard(
                title: 'Weekly Performance',
                child: SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: stats.weeklySales.reduce((a, b) => a > b ? a : b) * 1.2,
                      titlesData: const FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(
                        stats.weeklySales.length,
                        (i) => BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: stats.weeklySales[i],
                              color: AppColors.accent,
                              width: 14,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ],
                        ),
                      ),
                    ),
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

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.items});
  final List<_Metric> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items
          .map(
            (m) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: m != items.last ? 8 : 0),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.label, style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: 4),
                    Text(m.value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Metric {
  const _Metric(this.label, this.value);
  final String label;
  final String value;
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
