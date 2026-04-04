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
    final fn = firstName?.trim() ?? '';
    final ln = lastName?.trim() ?? '';
    if (fn.isNotEmpty && ln.isNotEmpty) return '$fn $ln';
    if (fn.isNotEmpty) return fn;
    if (ln.isNotEmpty) return ln;
    final e = email?.trim();
    if (e != null && e.isNotEmpty) return e;
    final ph = phone?.trim();
    if (ph != null && ph.isNotEmpty) return ph;
    return id;
  }

  @override
  List<Object?> get props => [id, firstName, lastName, email, phone, address, role];
}
