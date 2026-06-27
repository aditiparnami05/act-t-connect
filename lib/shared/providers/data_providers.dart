import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/business_repository.dart';
import '../models/dashboard_stats.dart';
import '../models/invoice.dart';
import '../models/party.dart';
import '../models/payment.dart';
import '../models/product.dart';
import '../models/purchase.dart';
import '../models/transaction.dart';

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  return LocalBusinessRepository();
});

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  return ref.watch(businessRepositoryProvider).getDashboardStats();
});

final customersProvider = FutureProvider<List<Party>>((ref) async {
  return ref.watch(businessRepositoryProvider).getCustomers();
});

final suppliersProvider = FutureProvider<List<Party>>((ref) async {
  return ref.watch(businessRepositoryProvider).getSuppliers();
});

final productsProvider = FutureProvider<List<Product>>((ref) async {
  return ref.watch(businessRepositoryProvider).getProducts();
});

final invoicesProvider = FutureProvider<List<Invoice>>((ref) async {
  return ref.watch(businessRepositoryProvider).getInvoices();
});

final purchasesProvider = FutureProvider<List<Purchase>>((ref) async {
  return ref.watch(businessRepositoryProvider).getPurchases();
});

final paymentsProvider = FutureProvider<List<Payment>>((ref) async {
  return ref.watch(businessRepositoryProvider).getPayments();
});

final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  return ref.watch(businessRepositoryProvider).getRecentTransactions();
});

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(businessRepositoryProvider).getCategories();
});
