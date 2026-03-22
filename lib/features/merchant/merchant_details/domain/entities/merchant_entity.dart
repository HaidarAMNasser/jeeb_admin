import 'package:equatable/equatable.dart';

class MerchantEntity extends Equatable {
  final String id;
  final String name;
  final String? firstName;
  final String? lastName;
  final String email;
  final int? countryId;
  final int? cityId;
  final String? address;
  final String? cityName;
  final String? countryName;
  final String? location; // Not used in UI right now
  final String? phoneNumber;
  final bool? hidePhoneNumber;
  final String restaurantName;
  final String? image; // Might be null

  const MerchantEntity({
    required this.id,
    required this.name,
    required this.restaurantName,
    this.firstName,
    this.lastName,
    required this.email,
    this.countryId,
    this.cityId,
    this.address,
    this.cityName,
    this.countryName,
    this.location,
    this.phoneNumber,
    this.hidePhoneNumber,
    this.image,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        firstName,
        lastName,
        email,
        countryId,
        cityId,
        address,
        cityName,
        countryName,
        location,
        phoneNumber,
        hidePhoneNumber,
        image,
      ];
}

