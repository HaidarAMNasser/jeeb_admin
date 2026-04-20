part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfile extends ProfileEvent {
  const GetProfile();
}

class UpdateProfile extends ProfileEvent {
  final String? firstName;
  final String? lastName;
  final String? phone;
  final int? countryId;
  final int? cityId;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool? isActive;
  final bool? isOpen;
  final String? restaurantName;
  final dynamic imageFile;

  const UpdateProfile({
    this.firstName,
    this.lastName,
    this.phone,
    this.countryId,
    this.cityId,
    this.address,
    this.latitude,
    this.longitude,
    this.isActive,
    this.isOpen,
    this.restaurantName,
    this.imageFile,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        phone,
        countryId,
        cityId,
        address,
        latitude,
        longitude,
        isActive,
        isOpen,
        restaurantName,
        imageFile,
      ];
}

class FormValuesInitialized extends ProfileEvent {
  const FormValuesInitialized();
}

class ClearUpdateSuccess extends ProfileEvent {
  const ClearUpdateSuccess();
}

class SaveProfile extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final String? address;
  /// Sent on PATCH only when non-null (merchant saves).
  final String? restaurantName;

  const SaveProfile({
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.address,
    this.restaurantName,
  });

  @override
  List<Object?> get props => [firstName, lastName, phone, address, restaurantName];
}

class ChangeLanguage extends ProfileEvent {
  final String languageCode;

  const ChangeLanguage(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class ClearLocaleToApply extends ProfileEvent {
  const ClearLocaleToApply();
}

class UpdateLocation extends ProfileEvent {
  final double latitude;
  final double longitude;

  const UpdateLocation({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}

class UpdateAccountActive extends ProfileEvent {
  /// Merchant: restaurant open (`isOpen` in API).
  final bool isOpen;

  const UpdateAccountActive(this.isOpen);

  @override
  List<Object?> get props => [isOpen];
}
