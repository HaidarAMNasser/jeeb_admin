import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

void areaValidationToast({
  String? name,
  String? price,
}) {
  if (name == null || name.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterAreaName);
    return;
  }

  if (price == null || price.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterAreaPrice);
    return;
  }

  final priceValue = double.tryParse(price.trim());
  if (priceValue == null || priceValue <= 0) {
    customToast(msg: AppTranslation.invalidAreaPrice);
  }
}
