part of 'create_delivery_bloc.dart';

abstract class CreateDeliveryEvent extends Equatable {
  const CreateDeliveryEvent();

  @override
  List<Object> get props => [];
}

class CreateDeliverySubmitted extends CreateDeliveryEvent {
  final String name;
  final String phone;
  final String email;
  final String? vehicleType;
  final String? status;

  const CreateDeliverySubmitted({
    required this.name,
    required this.phone,
    required this.email,
    this.vehicleType,
    this.status,
  });

  @override
  List<Object> get props => [name, phone, email, vehicleType ?? '', status ?? ''];
}
