import '../models/business_profile.dart';
import '../models/dashboard_stats.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import '../models/party.dart';
import '../models/payment.dart';
import '../models/product.dart';
import '../models/purchase.dart';
import '../models/transaction.dart';

/// Seed data for offline demo and development.
abstract final class DummyData {
  static const businessProfile = BusinessProfile(
    name: 'Act-T Connect Pvt. Ltd.',
    email: 'contact@acttconnect.com',
    phone: '+91 98765 43210',
    address: '123 Business Park, Sector 18, Gurugram, Haryana 122015',
    gstin: '06AABCA1234A1Z5',
    pan: 'AABCA1234A',
    logoPath: 'assets/images/logo.png',
  );

  static const userEmail = 'admin@acttconnect.com';
  static const userPassword = 'admin123';
  static const userName = 'Rajesh Kumar';

  static final dashboardStats = DashboardStats(
    todaysSales: 87500,
    todaysPurchase: 45200,
    outstandingPayments: 234500,
    outstandingReceipts: 189750,
    inventoryValue: 1250000,
    profit: 32800,
    weeklySales: [42000, 55000, 48000, 62000, 87500, 71000, 68000],
    monthlyRevenue: [320000, 385000, 410000, 445000, 478000, 512000],
    stockOverview: {'In Stock': 156, 'Low Stock': 23, 'Out of Stock': 8},
  );

  static final parties = <Party>[
    const Party(
      id: 'c1',
      name: 'Sharma Electronics',
      phone: '+91 98100 12345',
      email: 'sharma@email.com',
      type: PartyType.customer,
      outstandingBalance: 45000,
      address: '45 MG Road, Delhi',
      gstin: '07AABCS1234B1Z2',
      city: 'Delhi',
    ),
    const Party(
      id: 'c2',
      name: 'Patel Traders',
      phone: '+91 98200 23456',
      email: 'patel@email.com',
      type: PartyType.customer,
      outstandingBalance: 28500,
      address: '12 Ring Road, Ahmedabad',
      gstin: '24AABCP5678C1Z3',
      city: 'Ahmedabad',
    ),
    const Party(
      id: 'c3',
      name: 'Kumar Industries',
      phone: '+91 98300 34567',
      email: 'kumar@email.com',
      type: PartyType.customer,
      outstandingBalance: 0,
      address: '78 Industrial Area, Pune',
      city: 'Pune',
    ),
    const Party(
      id: 'c4',
      name: 'Singh Retail Hub',
      phone: '+91 98400 45678',
      email: 'singh@email.com',
      type: PartyType.customer,
      outstandingBalance: 67200,
      address: '33 Mall Road, Jaipur',
      city: 'Jaipur',
    ),
    const Party(
      id: 's1',
      name: 'Global Distributors',
      phone: '+91 99100 11111',
      email: 'global@supplier.com',
      type: PartyType.supplier,
      outstandingBalance: 125000,
      address: 'Warehouse 5, Noida',
      gstin: '09AABCG9012D1Z4',
      city: 'Noida',
    ),
    const Party(
      id: 's2',
      name: 'Prime Wholesale',
      phone: '+91 99200 22222',
      email: 'prime@supplier.com',
      type: PartyType.supplier,
      outstandingBalance: 78500,
      address: 'Sector 62, Noida',
      city: 'Noida',
    ),
    const Party(
      id: 's3',
      name: 'Metro Supplies Co.',
      phone: '+91 99300 33333',
      email: 'metro@supplier.com',
      type: PartyType.supplier,
      outstandingBalance: 0,
      address: 'Andheri East, Mumbai',
      city: 'Mumbai',
    ),
  ];

  static final products = <Product>[
    const Product(
      id: 'p1',
      name: 'Wireless Bluetooth Speaker',
      sku: 'WBS-001',
      category: 'Electronics',
      sellingPrice: 2499,
      purchasePrice: 1650,
      stock: 45,
      unit: 'Pcs',
      barcode: '8901234567890',
      gstRate: 18,
    ),
    const Product(
      id: 'p2',
      name: 'USB-C Fast Charger 65W',
      sku: 'UFC-065',
      category: 'Electronics',
      sellingPrice: 1299,
      purchasePrice: 850,
      stock: 8,
      unit: 'Pcs',
      barcode: '8901234567891',
      gstRate: 18,
    ),
    const Product(
      id: 'p3',
      name: 'LED Desk Lamp',
      sku: 'LDL-200',
      category: 'Home & Office',
      sellingPrice: 1899,
      purchasePrice: 1200,
      stock: 32,
      unit: 'Pcs',
      barcode: '8901234567892',
      gstRate: 12,
    ),
    const Product(
      id: 'p4',
      name: 'Ergonomic Office Chair',
      sku: 'EOC-500',
      category: 'Furniture',
      sellingPrice: 8999,
      purchasePrice: 6200,
      stock: 0,
      unit: 'Pcs',
      barcode: '8901234567893',
      gstRate: 18,
    ),
    const Product(
      id: 'p5',
      name: 'A4 Copier Paper (500 sheets)',
      sku: 'ACP-500',
      category: 'Stationery',
      sellingPrice: 320,
      purchasePrice: 245,
      stock: 200,
      unit: 'Ream',
      barcode: '8901234567894',
      gstRate: 12,
    ),
    const Product(
      id: 'p6',
      name: 'Smart Watch Series X',
      sku: 'SWX-100',
      category: 'Electronics',
      sellingPrice: 4999,
      purchasePrice: 3500,
      stock: 15,
      unit: 'Pcs',
      barcode: '8901234567895',
      gstRate: 18,
    ),
  ];

  static final invoices = <Invoice>[
    Invoice(
      id: 'inv1',
      invoiceNumber: 'INV-2026-0142',
      partyId: 'c1',
      partyName: 'Sharma Electronics',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      status: InvoiceStatus.paid,
      paidAmount: 14750,
      items: const [
        InvoiceItem(
          productId: 'p1',
          productName: 'Wireless Bluetooth Speaker',
          quantity: 5,
          rate: 2499,
          gstRate: 18,
          discount: 5,
        ),
      ],
    ),
    Invoice(
      id: 'inv2',
      invoiceNumber: 'INV-2026-0141',
      partyId: 'c2',
      partyName: 'Patel Traders',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: InvoiceStatus.partial,
      paidAmount: 10000,
      items: const [
        InvoiceItem(
          productId: 'p3',
          productName: 'LED Desk Lamp',
          quantity: 10,
          rate: 1899,
          gstRate: 12,
        ),
      ],
    ),
    Invoice(
      id: 'inv3',
      invoiceNumber: 'INV-2026-0140',
      partyId: 'c4',
      partyName: 'Singh Retail Hub',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: InvoiceStatus.unpaid,
      items: const [
        InvoiceItem(
          productId: 'p6',
          productName: 'Smart Watch Series X',
          quantity: 8,
          rate: 4999,
          gstRate: 18,
        ),
      ],
    ),
  ];

  static final purchases = <Purchase>[
    Purchase(
      id: 'pur1',
      billNumber: 'PUR-2026-0089',
      supplierId: 's1',
      supplierName: 'Global Distributors',
      date: DateTime.now().subtract(const Duration(days: 1)),
      paymentStatus: PaymentStatus.partial,
      paidAmount: 50000,
      items: const [
        InvoiceItem(
          productId: 'p1',
          productName: 'Wireless Bluetooth Speaker',
          quantity: 50,
          rate: 1650,
          gstRate: 18,
        ),
      ],
    ),
    Purchase(
      id: 'pur2',
      billNumber: 'PUR-2026-0088',
      supplierId: 's2',
      supplierName: 'Prime Wholesale',
      date: DateTime.now().subtract(const Duration(days: 3)),
      paymentStatus: PaymentStatus.paid,
      paidAmount: 42500,
      items: const [
        InvoiceItem(
          productId: 'p5',
          productName: 'A4 Copier Paper (500 sheets)',
          quantity: 100,
          rate: 245,
          gstRate: 12,
        ),
      ],
    ),
  ];

  static final payments = <Payment>[
    Payment(
      id: 'pay1',
      partyId: 'c1',
      partyName: 'Sharma Electronics',
      amount: 14750,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      type: PaymentType.received,
      mode: PaymentMode.upi,
      reference: 'UPI123456789',
    ),
    Payment(
      id: 'pay2',
      partyId: 's1',
      partyName: 'Global Distributors',
      amount: 50000,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: PaymentType.made,
      mode: PaymentMode.bank,
      reference: 'NEFT987654321',
    ),
    Payment(
      id: 'pay3',
      partyId: 'c2',
      partyName: 'Patel Traders',
      amount: 10000,
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: PaymentType.received,
      mode: PaymentMode.cash,
    ),
  ];

  static final transactions = <Transaction>[
    Transaction(
      id: 't1',
      title: 'Sale - Sharma Electronics',
      subtitle: 'INV-2026-0142',
      amount: 14750,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      type: TransactionType.sale,
      isCredit: true,
    ),
    Transaction(
      id: 't2',
      title: 'Purchase - Global Distributors',
      subtitle: 'PUR-2026-0089',
      amount: 82500,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.purchase,
      isCredit: false,
    ),
    Transaction(
      id: 't3',
      title: 'Payment Received',
      subtitle: 'Patel Traders',
      amount: 10000,
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: TransactionType.receipt,
      isCredit: true,
    ),
    Transaction(
      id: 't4',
      title: 'Sale - Singh Retail Hub',
      subtitle: 'INV-2026-0140',
      amount: 47192,
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: TransactionType.sale,
      isCredit: true,
    ),
    Transaction(
      id: 't5',
      title: 'Office Rent',
      subtitle: 'Monthly Expense',
      amount: 25000,
      date: DateTime.now().subtract(const Duration(days: 5)),
      type: TransactionType.expense,
      isCredit: false,
    ),
  ];

  static List<Party> get customers =>
      parties.where((p) => p.isCustomer).toList();

  static List<Party> get suppliers =>
      parties.where((p) => p.isSupplier).toList();

  static List<String> get categories =>
      products.map((p) => p.category).toSet().toList();
}
