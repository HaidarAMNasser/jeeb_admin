part of 'create_delivery_bloc.dart';

abstract class CreateDeliveryEvent extends Equatable {
  const CreateDeliveryEvent();

  @override
  List<Object> get props => [];
}

class CreateDeliverySubmitted extends CreateDeliveryEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final int? countryId;
  final int? cityId;
  final String? address;
  final String? birthday;
  final String? notificationChannel;
  final int? officeOwnerId;
  final String? imagePath;

  const CreateDeliverySubmitted({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    this.countryId,
    this.cityId,
    this.address,
    this.birthday,
    this.notificationChannel,
    this.officeOwnerId,
    this.imagePath,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        email,
        password,
        phone,
        countryId ?? 0,
        cityId ?? 0,
        address ?? '',
        birthday ?? '',
        notificationChannel ?? '',
        officeOwnerId ?? 0,
        imagePath ?? '',
      ];
}
