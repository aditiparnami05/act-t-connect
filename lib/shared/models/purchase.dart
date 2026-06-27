import 'package:equatable/equatable.dart';

import 'invoice_item.dart';

/// Purchase bill from a supplier.
class Purchase extends Equatable {
  const Purchase({
    required this.id,
    required this.billNumber,
    required this.supplierId,
    required this.supplierName,
    required this.date,
    required this.items,
    required this.paymentStatus,
    this.paidAmount = 0,
  });

  final String id;
  final String billNumber;
  final String supplierId;
  final String supplierName;
  final DateTime date;
  final List<InvoiceItem> items;
  final PaymentStatus paymentStatus;
  final double paidAmount;

  double get grandTotal => items.fold(0, (sum, i) => sum + i.total);
  double get balanceDue => grandTotal - paidAmount;

  @override
  List<Object?> get props =>
      [id, billNumber, supplierId, supplierName, date, items, paymentStatus, paidAmount];
}

enum PaymentStatus { paid, partial, unpaid }
