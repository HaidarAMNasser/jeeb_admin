part of 'update_merchant_bloc.dart';

abstract class UpdateMerchantEvent extends Equatable {
  const UpdateMerchantEvent();

  @override
  List<Object?> get props => [];
}

class UpdateMerchantSubmitted extends UpdateMerchantEvent {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final int? countryId;
  final int? cityId;
  final int? areaId;
  final String? restaurantName;
  final String? merchantType;
  final double? latitude;
  final double? longitude;
  final String? address;
  final bool? hidePhoneNumber;
  final bool? isActive;
  final bool isConfirmAction;

  const UpdateMerchantSubmitted({
    required this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.countryId,
    this.cityId,
    this.areaId,
    this.restaurantName,
    this.merchantType,
    this.latitude,
    this.longitude,
    this.address,
    this.hidePhoneNumber,
    this.isActive,
    this.isConfirmAction = false,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        phone,
        email,
        countryId,
        cityId,
        areaId,
        restaurantName,
        merchantType,
        latitude,
        longitude,
        address,
        hidePhoneNumber,
        isActive,
        isConfirmAction,
      ];
}
