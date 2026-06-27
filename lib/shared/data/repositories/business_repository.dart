import '../dummy_data.dart';
import '../../models/dashboard_stats.dart';
import '../../models/invoice.dart';
import '../../models/party.dart';
import '../../models/payment.dart';
import '../../models/product.dart';
import '../../models/purchase.dart';
import '../../models/transaction.dart';

/// Abstract repository contract for business data.
abstract class BusinessRepository {
  Future<DashboardStats> getDashboardStats();
  Future<List<Party>> getCustomers();
  Future<List<Party>> getSuppliers();
  Future<List<Party>> getAllParties();
  Future<Party?> getPartyById(String id);
  Future<List<Product>> getProducts();
  Future<Product?> getProductById(String id);
  Future<List<Invoice>> getInvoices();
  Future<Invoice?> getInvoiceById(String id);
  Future<List<Purchase>> getPurchases();
  Future<List<Payment>> getPayments();
  Future<List<Transaction>> getRecentTransactions();
  Future<List<String>> getCategories();
}

/// Local implementation using dummy data — swap for API datasource later.
class LocalBusinessRepository implements BusinessRepository {
  @override
  Future<DashboardStats> getDashboardStats() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return DummyData.dashboardStats;
  }

  @override
  Future<List<Party>> getCustomers() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return DummyData.customers;
  }

  @override
  Future<List<Party>> getSuppliers() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return DummyData.suppliers;
  }

  @override
  Future<List<Party>> getAllParties() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return DummyData.parties;
  }

  @override
  Future<Party?> getPartyById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      return DummyData.parties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Product>> getProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return DummyData.products;
  }

  @override
  Future<Product?> getProductById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      return DummyData.products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Invoice>> getInvoices() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return DummyData.invoices;
  }

  @override
  Future<Invoice?> getInvoiceById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      return DummyData.invoices.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Purchase>> getPurchases() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return DummyData.purchases;
  }

  @override
  Future<List<Payment>> getPayments() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return DummyData.payments;
  }

  @override
  Future<List<Transaction>> getRecentTransactions() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return DummyData.transactions;
  }

  @override
  Future<List<String>> getCategories() async {
    return DummyData.categories;
  }
}
