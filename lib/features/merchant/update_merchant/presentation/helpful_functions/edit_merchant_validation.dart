import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

bool isEditMerchantFormValid({
  required String firstName,
  required String lastName,
  required String email,
  required String phone,
}) {
  return firstName.isNotEmpty &&
      lastName.isNotEmpty &&
      email.isNotEmpty &&
      phone.isNotEmpty;
}

void editMerchantValidationToast({
  required String firstName,
  required String lastName,
  required String email,
  required String phone,
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
}
