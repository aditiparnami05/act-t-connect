import 'package:equatable/equatable.dart';

/// Line item within an invoice or purchase bill.
class InvoiceItem extends Equatable {
  const InvoiceItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.rate,
    required this.gstRate,
    this.discount = 0,
  });

  final String productId;
  final String productName;
  final int quantity;
  final double rate;
  final double gstRate;
  final double discount;

  double get subtotal => quantity * rate;
  double get discountAmount => subtotal * (discount / 100);
  double get taxableAmount => subtotal - discountAmount;
  double get gstAmount => taxableAmount * (gstRate / 100);
  double get total => taxableAmount + gstAmount;

  @override
  List<Object?> get props =>
      [productId, productName, quantity, rate, gstRate, discount];
}
