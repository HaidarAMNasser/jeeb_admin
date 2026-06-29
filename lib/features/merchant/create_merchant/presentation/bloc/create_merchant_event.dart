part of 'create_merchant_bloc.dart';

abstract class CreateMerchantEvent extends Equatable {
  const CreateMerchantEvent();

  @override
  List<Object> get props => [];
}

class CreateMerchantSubmitted extends CreateMerchantEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final int countryId;
  final int cityId;
  final int areaId;
  final String restaurantName;
  final String merchantType;
  final double latitude;
  final double longitude;
  final String? address;
  final String? notificationChannel;

  const CreateMerchantSubmitted({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.countryId,
    required this.cityId,
    required this.areaId,
    required this.restaurantName,
    required this.merchantType,
    required this.latitude,
    required this.longitude,
    this.address,
    this.notificationChannel,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        email,
        password,
        phone,
        countryId,
        cityId,
        areaId,
        restaurantName,
        merchantType,
        latitude,
        longitude,
        address ?? '',
        notificationChannel ?? '',
      ];
}
