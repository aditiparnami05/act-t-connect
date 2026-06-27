import 'package:intl/intl.dart';

/// Currency formatting utilities for Indian Rupee.
abstract final class CurrencyFormatter {
  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String format(double amount) => _inr.format(amount);

  static String formatCompact(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)}Cr';
    }
    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)}L';
    }
    if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    }
    return format(amount);
  }
}
