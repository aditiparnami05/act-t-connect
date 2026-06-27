import 'package:equatable/equatable.dart';

import '../../../../shared/models/invoice.dart';
import '../../../../shared/models/invoice_item.dart';
import '../../../../shared/models/party.dart';
import '../../../../shared/models/product.dart';

enum PaymentMethod { cash, upi, card, bank, credit }

enum PaymentStatus { paid, partial, pending }

enum InvoiceDraftStatus { draft, pending, sent }

/// Editable line item on the create-invoice form.
class InvoiceLineDraft extends Equatable {
  const InvoiceLineDraft({
    required this.id,
    required this.product,
    this.quantity = 1,
    this.discount = 0,
    this.customRate,
  });

  final String id;
  final Product product;
  final int quantity;
  final double discount;
  final double? customRate;

  String get hsnCode => product.sku;

  double get rate => customRate ?? product.sellingPrice;

  InvoiceItem get toInvoiceItem => InvoiceItem(
        productId: product.id,
        productName: product.name,
        quantity: quantity,
        rate: rate,
        gstRate: product.gstRate,
        discount: discount,
      );

  double get lineSubtotal => quantity * rate;
  double get lineDiscount => lineSubtotal * (discount / 100);
  double get lineTaxable => lineSubtotal - lineDiscount;
  double get lineTax => lineTaxable * (product.gstRate / 100);
  double get lineTotal => lineTaxable + lineTax;

  InvoiceLineDraft copyWith({
    int? quantity,
    double? discount,
    double? customRate,
  }) {
    return InvoiceLineDraft(
      id: id,
      product: product,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      customRate: customRate ?? this.customRate,
    );
  }

  @override
  List<Object?> get props => [id, product, quantity, discount, customRate];
}

/// Full draft state for the invoice creation screen.
class CreateInvoiceDraft extends Equatable {
  const CreateInvoiceDraft({
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.dueDate,
    this.status = InvoiceDraftStatus.draft,
    this.customer,
    this.lines = const [],
    this.orderDiscount = 0,
    this.shipping = 0,
    this.roundOff = 0,
    this.paymentMethod = PaymentMethod.cash,
    this.paymentStatus = PaymentStatus.pending,
    this.amountReceived = 0,
    this.specialNotes = '',
    this.termsAndConditions = '',
    this.customerRemarks = '',
    this.attachments = const [],
  });

  final String invoiceNumber;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final InvoiceDraftStatus status;
  final Party? customer;
  final List<InvoiceLineDraft> lines;
  final double orderDiscount;
  final double shipping;
  final double roundOff;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final double amountReceived;
  final String specialNotes;
  final String termsAndConditions;
  final String customerRemarks;
  final List<String> attachments;

  double get itemsSubtotal =>
      lines.fold(0.0, (sum, line) => sum + line.lineSubtotal);

  double get itemsDiscount =>
      lines.fold(0.0, (sum, line) => sum + line.lineDiscount) + orderDiscount;

  double get tax =>
      lines.fold(0.0, (sum, line) => sum + line.lineTax);

  double get subtotalAfterLineDiscount =>
      lines.fold(0.0, (sum, line) => sum + line.lineTaxable);

  double get grandTotal {
    final raw = subtotalAfterLineDiscount - orderDiscount + tax + shipping;
    return raw + roundOff;
  }

  double get balanceDue =>
      (grandTotal - amountReceived).clamp(0, double.infinity);

  bool get isValid => customer != null && lines.isNotEmpty;

  InvoiceStatus get invoiceStatus {
    switch (paymentStatus) {
      case PaymentStatus.paid:
        return InvoiceStatus.paid;
      case PaymentStatus.partial:
        return InvoiceStatus.partial;
      case PaymentStatus.pending:
        return InvoiceStatus.unpaid;
    }
  }

  CreateInvoiceDraft copyWith({
    String? invoiceNumber,
    DateTime? invoiceDate,
    DateTime? dueDate,
    InvoiceDraftStatus? status,
    Party? customer,
    bool clearCustomer = false,
    List<InvoiceLineDraft>? lines,
    double? orderDiscount,
    double? shipping,
    double? roundOff,
    PaymentMethod? paymentMethod,
    PaymentStatus? paymentStatus,
    double? amountReceived,
    String? specialNotes,
    String? termsAndConditions,
    String? customerRemarks,
    List<String>? attachments,
  }) {
    return CreateInvoiceDraft(
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      customer: clearCustomer ? null : (customer ?? this.customer),
      lines: lines ?? this.lines,
      orderDiscount: orderDiscount ?? this.orderDiscount,
      shipping: shipping ?? this.shipping,
      roundOff: roundOff ?? this.roundOff,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      amountReceived: amountReceived ?? this.amountReceived,
      specialNotes: specialNotes ?? this.specialNotes,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      customerRemarks: customerRemarks ?? this.customerRemarks,
      attachments: attachments ?? this.attachments,
    );
  }

  @override
  List<Object?> get props => [
        invoiceNumber,
        invoiceDate,
        dueDate,
        status,
        customer,
        lines,
        orderDiscount,
        shipping,
        roundOff,
        paymentMethod,
        paymentStatus,
        amountReceived,
        specialNotes,
        termsAndConditions,
        customerRemarks,
        attachments,
      ];
}
