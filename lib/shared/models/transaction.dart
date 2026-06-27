import 'package:equatable/equatable.dart';

/// Recent transaction for dashboard feed.
class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.type,
    this.isCredit = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final bool isCredit;

  @override
  List<Object?> get props => [id, title, subtitle, amount, date, type, isCredit];
}

enum TransactionType { sale, purchase, payment, receipt, expense }
