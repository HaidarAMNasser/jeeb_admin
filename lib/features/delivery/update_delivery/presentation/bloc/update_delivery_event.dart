part of 'update_delivery_bloc.dart';

abstract class UpdateDeliveryEvent extends Equatable {
  const UpdateDeliveryEvent();

  @override
  List<Object> get props => [];
}

class UpdateDeliverySubmitted extends UpdateDeliveryEvent {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? password;
  final int? countryId;
  final int? cityId;
  final String? address;
  final String? birthday;
  final String? notificationChannel;
  final String? imagePath;

  const UpdateDeliverySubmitted({
    required this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.password,
    this.countryId,
    this.cityId,
    this.address,
    this.birthday,
    this.notificationChannel,
    this.imagePath,
  });

  @override
  List<Object> get props => [
        id,
        firstName ?? '',
        lastName ?? '',
        phone ?? '',
        email ?? '',
        password ?? '',
        countryId ?? 0,
        cityId ?? 0,
        address ?? '',
        birthday ?? '',
        notificationChannel ?? '',
        imagePath ?? '',
      ];
}
