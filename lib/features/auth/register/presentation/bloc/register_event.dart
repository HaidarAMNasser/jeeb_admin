part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final String role;
  final int? countryId;
  final int? cityId;
  final double? latitude;
  final double? longitude;
  final String notificationChannel;
  final String? address;

  const RegisterSubmitted({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
    this.countryId,
    this.cityId,
    this.latitude,
    this.longitude,
    required this.notificationChannel,
    this.address,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        password,
        phone,
        role,
        countryId,
        cityId,
        latitude,
        longitude,
        notificationChannel,
        address,
      ];
}

