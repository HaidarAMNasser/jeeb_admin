/// Immutable values from the delivery add/edit form for submit.
class DeliveryFormValues {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;
  final String? address;
  final String? birthday;
  final String? imagePath;
  final int? countryId;
  final int? cityId;
  /// Set when admin picks driver location on map (create flow).
  final double? latitude;
  final double? longitude;

  const DeliveryFormValues({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    this.address,
    this.birthday,
    this.imagePath,
    this.countryId,
    this.cityId,
    this.latitude,
    this.longitude,
  });
}
