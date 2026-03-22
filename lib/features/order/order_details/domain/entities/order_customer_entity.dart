import 'package:equatable/equatable.dart';

class OrderCustomerEntity extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? address;
  final String? role;

  const OrderCustomerEntity({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.address,
    this.role,
  });

  String get displayName {
    if (firstName != null && lastName != null) return '$firstName $lastName'.trim();
    if (firstName != null && firstName!.isNotEmpty) return firstName!;
    if (lastName != null && lastName!.isNotEmpty) return lastName!;
    return id;
  }

  @override
  List<Object?> get props => [id, firstName, lastName, email, phone, address, role];
}
