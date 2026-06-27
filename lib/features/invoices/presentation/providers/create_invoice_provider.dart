import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/models/party.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/providers/data_providers.dart';
import '../models/create_invoice_draft.dart';

class CreateInvoiceNotifier extends StateNotifier<CreateInvoiceDraft> {
  CreateInvoiceNotifier(this._invoiceCount)
      : super(
          CreateInvoiceDraft(
            invoiceNumber: _generateInvoiceNumber(_invoiceCount),
            invoiceDate: DateTime.now(),
            dueDate: DateTime.now().add(const Duration(days: 15)),
          ),
        );

  final int _invoiceCount;
  static const _uuid = Uuid();

  static String _generateInvoiceNumber(int count) {
    final year = DateTime.now().year;
    return 'INV-$year-${(count + 1).toString().padLeft(4, '0')}';
  }

  void refreshInvoiceNumber(int count) {
    state = state.copyWith(
      invoiceNumber: _generateInvoiceNumber(count),
      invoiceDate: DateTime.now(),
    );
  }

  void setCustomer(Party customer) {
    state = state.copyWith(customer: customer);
  }

  void clearCustomer() {
    state = state.copyWith(clearCustomer: true);
  }

  void setInvoiceDate(DateTime date) {
    state = state.copyWith(invoiceDate: date);
  }

  void setDueDate(DateTime date) {
    state = state.copyWith(dueDate: date);
  }

  void setStatus(InvoiceDraftStatus status) {
    state = state.copyWith(status: status);
  }

  void addProduct(Product product) {
    final exists = state.lines.any((l) => l.product.id == product.id);
    if (exists) {
      final lines = state.lines.map((line) {
        if (line.product.id == product.id) {
          return line.copyWith(quantity: line.quantity + 1);
        }
        return line;
      }).toList();
      state = state.copyWith(lines: lines);
      return;
    }

    state = state.copyWith(
      lines: [
        ...state.lines,
        InvoiceLineDraft(id: _uuid.v4(), product: product),
      ],
    );
  }

  void updateLine(String id, InvoiceLineDraft line) {
    state = state.copyWith(
      lines: state.lines.map((l) => l.id == id ? line : l).toList(),
    );
    _syncPaymentStatus();
  }

  void removeLine(String id) {
    state = state.copyWith(
      lines: state.lines.where((l) => l.id != id).toList(),
    );
    _syncPaymentStatus();
  }

  void setOrderDiscount(double value) {
    state = state.copyWith(orderDiscount: value);
    _syncPaymentStatus();
  }

  void setShipping(double value) {
    state = state.copyWith(shipping: value);
    _syncPaymentStatus();
  }

  void setRoundOff(double value) {
    state = state.copyWith(roundOff: value);
    _syncPaymentStatus();
  }

  void setPaymentMethod(PaymentMethod method) {
    state = state.copyWith(paymentMethod: method);
  }

  void setPaymentStatus(PaymentStatus status) {
    state = state.copyWith(
      paymentStatus: status,
      amountReceived: switch (status) {
        PaymentStatus.paid => state.grandTotal,
        PaymentStatus.partial => state.amountReceived,
        PaymentStatus.pending => 0,
      },
    );
  }

  void setAmountReceived(double amount) {
    final total = state.grandTotal;
    PaymentStatus status;
    if (amount >= total && total > 0) {
      status = PaymentStatus.paid;
    } else if (amount > 0) {
      status = PaymentStatus.partial;
    } else {
      status = PaymentStatus.pending;
    }
    state = state.copyWith(
      amountReceived: amount,
      paymentStatus: status,
    );
  }

  void setSpecialNotes(String value) => state = state.copyWith(specialNotes: value);
  void setTerms(String value) => state = state.copyWith(termsAndConditions: value);
  void setCustomerRemarks(String value) =>
      state = state.copyWith(customerRemarks: value);

  void addAttachment(String label) {
    state = state.copyWith(attachments: [...state.attachments, label]);
  }

  void removeAttachment(int index) {
    final list = [...state.attachments]..removeAt(index);
    state = state.copyWith(attachments: list);
  }

  void saveDraft() {
    state = state.copyWith(status: InvoiceDraftStatus.draft);
  }

  void _syncPaymentStatus() {
    if (state.paymentStatus == PaymentStatus.paid) {
      state = state.copyWith(amountReceived: state.grandTotal);
    } else if (state.paymentStatus == PaymentStatus.partial &&
        state.amountReceived > state.grandTotal) {
      state = state.copyWith(amountReceived: state.grandTotal);
    }
  }

  void reset() {
    state = CreateInvoiceDraft(
      invoiceNumber: _generateInvoiceNumber(_invoiceCount),
      invoiceDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 15)),
    );
  }
}

final createInvoiceProvider =
    StateNotifierProvider.autoDispose<CreateInvoiceNotifier, CreateInvoiceDraft>(
  (ref) {
    final count = ref.read(invoicesProvider).maybeWhen(
          data: (list) => list.length,
          orElse: () => 0,
        );
    return CreateInvoiceNotifier(count);
  },
);
