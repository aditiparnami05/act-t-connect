import 'package:equatable/equatable.dart';

/// Business party — customer or supplier.
class Party extends Equatable {
  const Party({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.type,
    required this.outstandingBalance,
    this.address,
    this.gstin,
    this.city,
  });

  final String id;
  final String name;
  final String phone;
  final String email;
  final PartyType type;
  final double outstandingBalance;
  final String? address;
  final String? gstin;
  final String? city;

  bool get isCustomer => type == PartyType.customer;
  bool get isSupplier => type == PartyType.supplier;

  Party copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    PartyType? type,
    double? outstandingBalance,
    String? address,
    String? gstin,
    String? city,
  }) {
    return Party(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      type: type ?? this.type,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      address: address ?? this.address,
      gstin: gstin ?? this.gstin,
      city: city ?? this.city,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, phone, email, type, outstandingBalance, address, gstin, city];
}

enum PartyType { customer, supplier }
