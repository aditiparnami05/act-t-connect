import 'package:equatable/equatable.dart';

/// Payment transaction record.
class Payment extends Equatable {
  const Payment({
    required this.id,
    required this.partyId,
    required this.partyName,
    required this.amount,
    required this.date,
    required this.type,
    required this.mode,
    this.reference,
    this.notes,
  });

  final String id;
  final String partyId;
  final String partyName;
  final double amount;
  final DateTime date;
  final PaymentType type;
  final PaymentMode mode;
  final String? reference;
  final String? notes;

  @override
  List<Object?> get props =>
      [id, partyId, partyName, amount, date, type, mode, reference, notes];
}

enum PaymentType { received, made }
enum PaymentMode { cash, upi, bank, cheque, card }
