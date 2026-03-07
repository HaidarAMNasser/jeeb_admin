import 'package:equatable/equatable.dart';

class DeliveryManEntity extends Equatable {
  final String id;
  final String name; // firstName + lastName
  final String phone;
  final String email;
  final String? cityName;
  final String? countryName;
  final String? image;
  final bool? isOnline;
  final bool confirmed;
  final int? officeOwnerId;

  const DeliveryManEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.cityName,
    this.countryName,
    this.image,
    this.isOnline,
    this.confirmed = false,
    this.officeOwnerId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        cityName,
        countryName,
        image,
        isOnline,
        confirmed,
        officeOwnerId,
      ];
}
