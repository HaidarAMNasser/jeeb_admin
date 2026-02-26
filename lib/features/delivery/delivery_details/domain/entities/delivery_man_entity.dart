import 'package:equatable/equatable.dart';

class DeliveryManEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? vehicleType;
  final String? status;
  final String? image;

  const DeliveryManEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.vehicleType,
    this.status,
    this.image,
  });

  @override
  List<Object?> get props => [id, name, phone, email, vehicleType, status, image];
}
