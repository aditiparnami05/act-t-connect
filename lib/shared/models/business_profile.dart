import 'package:equatable/equatable.dart';

/// Business profile information.
class BusinessProfile extends Equatable {
  const BusinessProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.gstin,
    required this.pan,
    this.logoPath,
  });

  final String name;
  final String email;
  final String phone;
  final String address;
  final String gstin;
  final String pan;
  final String? logoPath;

  @override
  List<Object?> get props => [name, email, phone, address, gstin, pan, logoPath];
}
