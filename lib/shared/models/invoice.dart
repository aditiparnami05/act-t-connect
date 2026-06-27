import 'package:equatable/equatable.dart';

import 'invoice_item.dart';

/// Sales invoice document.
class Invoice extends Equatable {
  const Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.partyId,
    required this.partyName,
    required this.date,
    required this.items,
    required this.status,
    this.notes,
    this.paidAmount = 0,
  });

  final String id;
  final String invoiceNumber;
  final String partyId;
  final String partyName;
  final DateTime date;
  final List<InvoiceItem> items;
  final InvoiceStatus status;
  final String? notes;
  final double paidAmount;

  double get subtotal => items.fold(0, (sum, i) => sum + i.taxableAmount);
  double get totalGst => items.fold(0, (sum, i) => sum + i.gstAmount);
  double get grandTotal => items.fold(0, (sum, i) => sum + i.total);
  double get balanceDue => grandTotal - paidAmount;

  @override
  List<Object?> get props =>
      [id, invoiceNumber, partyId, partyName, date, items, status, notes, paidAmount];
}

enum InvoiceStatus { paid, partial, unpaid, draft }
