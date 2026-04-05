import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

void deliveryValidationToast({
  String? firstName,
  String? lastName,
  String? phone,
  String? email,
  String? password,
  required bool isEditMode,
  double? latitude,
  double? longitude,
}) {
  if (firstName == null || firstName.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterFirstName);
    return;
  }

  if (lastName == null || lastName.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterLastName);
    return;
  }

  if (phone == null || phone.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterPhone);
    return;
  }

  if (email == null || email.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterEmail);
    return;
  }

  if (!isEditMode) {
    if (password == null || password.trim().isEmpty) {
      customToast(msg: AppTranslation.pleaseEnterPassword);
      return;
    }

    if (password.trim().length < 6) {
      customToast(msg: AppTranslation.passwordMustBeAtLeast6Characters);
      return;
    }

    if (latitude == null || longitude == null) {
      customToast(msg: AppTranslation.deliveryLocationRequired);
      return;
    }
  }
}

bool isDeliveryFormValid({
  required String firstName,
  required String lastName,
  required String phone,
  required String email,
  String? password,
  required bool isEditMode,
  double? latitude,
  double? longitude,
}) {
  if (firstName.trim().isEmpty) return false;
  if (lastName.trim().isEmpty) return false;
  if (phone.trim().isEmpty) return false;
  if (email.trim().isEmpty) return false;

  if (!isEditMode) {
    if (password == null || password.trim().isEmpty) return false;
    if (password.trim().length < 6) return false;
    if (latitude == null || longitude == null) return false;
  }

  return true;
}

