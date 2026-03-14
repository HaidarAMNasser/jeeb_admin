import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

void registerValidationToast({
  String? firstName,
  String? lastName,
  String? email,
  String? phone,
  String? password,
  String? address,
  String? restaurantName,
  required double? latitude,
  required double? longitude,
  required int? countryId,
  required int? cityId,
}) {
  if (firstName == null || firstName.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterFirstName);
    return;
  }

  if (lastName == null || lastName.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterLastName);
    return;
  }

  if (email == null || email.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterEmail);
    return;
  }

  if (phone == null || phone.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterPhone);
    return;
  }

  if (password == null || password.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterPassword);
    return;
  }

  if (password.trim().length < 6) {
    customToast(msg: AppTranslation.passwordMustBeAtLeast6Characters);
    return;
  }

  if (address == null || address.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterAddress);
    return;
  }

  if (restaurantName == null || restaurantName.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterRestaurantName);
    return;
  }

  if (countryId == null) {
    customToast(msg: AppTranslation.pleaseSelectCountry);
    return;
  }

  if (cityId == null) {
    customToast(msg: AppTranslation.pleaseSelectCity);
    return;
  }

  final hasDeviceLocation = latitude != null && longitude != null;
  if (!hasDeviceLocation) {
    customToast(msg: AppTranslation.pleaseSelectLocation);
    return;
  }
}

bool isRegisterFormValid({
  required String firstName,
  required String lastName,
  required String email,
  required String phone,
  required String password,
  required String address,
  required String restaurantName,
  required double? latitude,
  required double? longitude,
  required int? countryId,
  required int? cityId,
}) {
  if (firstName.trim().isEmpty) return false;
  if (lastName.trim().isEmpty) return false;
  if (email.trim().isEmpty) return false;
  if (phone.trim().isEmpty) return false;
  if (password.trim().isEmpty || password.trim().length < 6) return false;
  if (address.trim().isEmpty) return false;
  if (restaurantName.trim().isEmpty) return false;

  if (countryId == null) return false;
  if (cityId == null) return false;
  if (latitude == null || longitude == null) return false;

  return true;
}

