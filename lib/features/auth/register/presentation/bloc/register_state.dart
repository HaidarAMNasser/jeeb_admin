part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  final CountryEntity? selectedCountry;
  final CityEntity? selectedCity;
  final bool isLocationLoading;
  final double? useLocationLat;
  final double? useLocationLng;
  final String merchantBusinessType;

  const RegisterState({
    this.selectedCountry,
    this.selectedCity,
    this.isLocationLoading = false,
    this.useLocationLat,
    this.useLocationLng,
    this.merchantBusinessType = 'RESTAURANT',
  });

  @override
  List<Object?> get props => [
        selectedCountry,
        selectedCity,
        isLocationLoading,
        useLocationLat,
        useLocationLng,
        merchantBusinessType,
      ];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial({
    super.selectedCountry,
    super.selectedCity,
    super.isLocationLoading,
    super.useLocationLat,
    super.useLocationLng,
    super.merchantBusinessType,
  });
}

class RegisterLoading extends RegisterState {
  const RegisterLoading({
    super.selectedCountry,
    super.selectedCity,
    super.isLocationLoading,
    super.useLocationLat,
    super.useLocationLng,
    super.merchantBusinessType,
  });
}

class RegisterSuccess extends RegisterState {
  final int userId;
  final String email;
  final String password;
  /// When false (API returned a session token), skip OTP and go to login/success toast.
  final bool requiresEmailVerification;

  const RegisterSuccess({
    required this.userId,
    required this.email,
    required this.password,
    this.requiresEmailVerification = true,
    super.selectedCountry,
    super.selectedCity,
    super.isLocationLoading,
    super.useLocationLat,
    super.useLocationLng,
    super.merchantBusinessType,
  });

  @override
  List<Object?> get props =>
      [...super.props, userId, email, password, requiresEmailVerification];
}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError({
    required this.message,
    super.selectedCountry,
    super.selectedCity,
    super.isLocationLoading,
    super.useLocationLat,
    super.useLocationLng,
    super.merchantBusinessType,
  });

  @override
  List<Object?> get props => [...super.props, message];
}

