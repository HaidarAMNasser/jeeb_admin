import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

bool isMerchantFormValid({
  required String firstName,
  required String lastName,
  required String email,
  required String phone,
  required String restaurantName,
  required int? countryId,
  required int? cityId,
  required int? areaId,
  required double? latitude,
  required double? longitude,
  required bool isEditMode,
  String? password,
}) {
  if (firstName.isEmpty ||
      lastName.isEmpty ||
      email.isEmpty ||
      phone.isEmpty ||
      restaurantName.isEmpty) {
    return false;
  }
  if (!isEditMode) {
    if (password == null ||
        password.isEmpty ||
        password.length < 6) {
      return false;
    }
  }
  if (countryId == null || cityId == null || areaId == null) {
    return false;
  }
  if (latitude == null || longitude == null) {
    return false;
  }
  return true;
}

void merchantFormValidationToast({
  required String firstName,
  required String lastName,
  required String email,
  required String phone,
  required String restaurantName,
  required int? countryId,
  required int? cityId,
  required int? areaId,
  required double? latitude,
  required double? longitude,
  required bool isEditMode,
  String? password,
}) {
  if (firstName.isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterFirstName);
    return;
  }
  if (lastName.isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterLastName);
    return;
  }
  if (email.isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterEmail);
    return;
  }
  if (phone.isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterPhone);
    return;
  }
  if (restaurantName.isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterRestaurantName);
    return;
  }
  if (!isEditMode) {
    if (password == null || password.isEmpty) {
      customToast(msg: AppTranslation.pleaseEnterPassword);
      return;
    }
    if (password.length < 6) {
      customToast(msg: AppTranslation.passwordMustBeAtLeast6Characters);
      return;
    }
  }
  if (countryId == null) {
    customToast(msg: AppTranslation.pleaseSelectCountry);
    return;
  }
  if (cityId == null) {
    customToast(msg: AppTranslation.pleaseSelectCity);
    return;
  }
  if (areaId == null) {
    customToast(msg: AppTranslation.pleaseSelectArea);
    return;
  }
  if (latitude == null || longitude == null) {
    customToast(msg: AppTranslation.pleaseSelectLocation);
  }
}
