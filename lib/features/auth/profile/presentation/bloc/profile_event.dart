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
      ];
}

