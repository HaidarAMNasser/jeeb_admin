import 'package:equatable/equatable.dart';

class DeliveryManEntity extends Equatable {
  final String id;
  final String name; // firstName + lastName
  final String? firstName;
  final String? lastName;
  final String phone;
  final String email;
  final String? cityName;
  final String? countryName;
  final int? countryId;
  final int? cityId;
  final String? address;
  final String? image;
  final bool? isOnline;
  final bool confirmed;
  /// When true, account is active (admin has activated). When false/null, OTP verified but admin has not activated yet.
  final bool? isActive;
  final int? officeOwnerId;
  final String? role;
  final String? notificationChannel;
  final String? birthday;
  final String? verifiedAt;
  final String? createdAt;
  final String? updatedAt;

  const DeliveryManEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.firstName,
    this.lastName,
    this.cityName,
    this.countryName,
    this.countryId,
    this.cityId,
    this.address,
    this.image,
    this.isOnline,
    this.confirmed = false,
    this.isActive,
    this.officeOwnerId,
    this.role,
    this.notificationChannel,
    this.birthday,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        firstName,
        lastName,
        phone,
        email,
        cityName,
        countryName,
        countryId,
        cityId,
        address,
        image,
        isOnline,
        confirmed,
        isActive,
        officeOwnerId,
        role,
        notificationChannel,
        birthday,
        verifiedAt,
        createdAt,
        updatedAt,
      ];
}
