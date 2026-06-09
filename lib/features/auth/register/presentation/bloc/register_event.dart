part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}

/// Backend values: `RESTAURANT` or `STORE` (market).
class RegisterMerchantTypeChanged extends RegisterEvent {
  final String type;

  const RegisterMerchantTypeChanged(this.type);

  @override
  List<Object?> get props => [type];
}

class RegisterCountryChanged extends RegisterEvent {
  final CountryEntity? country;

  const RegisterCountryChanged(this.country);

  @override
  List<Object?> get props => [country];
}

class RegisterCityChanged extends RegisterEvent {
  final CityEntity? city;

  const RegisterCityChanged(this.city);

  @override
  List<Object?> get props => [city];
}

class RegisterRoleChanged extends RegisterEvent {
  final String? role;

  const RegisterRoleChanged(this.role);

  @override
  List<Object?> get props => [role];
}

class RegisterNotificationChannelChanged extends RegisterEvent {
  final String channel;

  const RegisterNotificationChannelChanged(this.channel);

  @override
  List<Object?> get props => [channel];
}

class RegisterLocationLoadingChanged extends RegisterEvent {
  final bool isLoading;

  const RegisterLocationLoadingChanged(this.isLoading);

  @override
  List<Object?> get props => [isLoading];
}

class RegisterLocationUpdated extends RegisterEvent {
  final double? latitude;
  final double? longitude;

  const RegisterLocationUpdated({
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class RegisterLocationCleared extends RegisterEvent {
  const RegisterLocationCleared();
}

