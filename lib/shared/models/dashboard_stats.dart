import 'package:equatable/equatable.dart';

/// Dashboard summary metrics.
class DashboardStats extends Equatable {
  const DashboardStats({
    required this.todaysSales,
    required this.todaysPurchase,
    required this.outstandingPayments,
    required this.outstandingReceipts,
    required this.inventoryValue,
    required this.profit,
    required this.weeklySales,
    required this.monthlyRevenue,
    required this.stockOverview,
  });

  final double todaysSales;
  final double todaysPurchase;
  final double outstandingPayments;
  final double outstandingReceipts;
  final double inventoryValue;
  final double profit;
  final List<double> weeklySales;
  final List<double> monthlyRevenue;
  final Map<String, int> stockOverview;

  @override
  List<Object?> get props => [
        todaysSales,
        todaysPurchase,
        outstandingPayments,
        outstandingReceipts,
        inventoryValue,
        profit,
        weeklySales,
        monthlyRevenue,
        stockOverview,
      ];
}
