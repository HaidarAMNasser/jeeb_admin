part of 'update_delivery_bloc.dart';

abstract class UpdateDeliveryEvent extends Equatable {
  const UpdateDeliveryEvent();

  @override
  List<Object> get props => [];
}

class UpdateDeliverySubmitted extends UpdateDeliveryEvent {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? vehicleType;
  final String? status;

  const UpdateDeliverySubmitted({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.vehicleType,
    this.status,
  });

  @override
  List<Object> get props => [id, name, phone, email, vehicleType ?? '', status ?? ''];
}
