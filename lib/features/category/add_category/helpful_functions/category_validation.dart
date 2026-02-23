import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

void categoryValidationToast({String? name}) {
  if (name == null || name.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterCategoryName);
    return;
  }
}

bool isCategoryFormValid({required String name}) {
  return name.trim().isNotEmpty;
}

