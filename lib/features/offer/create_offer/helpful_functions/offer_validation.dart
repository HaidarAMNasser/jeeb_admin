import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

void offerValidationToast({
  String? name,
  String? shortDescription,
  List<String>? productIds,
  String? discountType,
  String? discountValue,
}) {
  if (name == null || name.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterOfferName);
    return;
  }
  if (shortDescription == null || shortDescription.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterOfferShortDescription);
    return;
  }
  if (productIds == null || productIds.isEmpty) {
    customToast(msg: AppTranslation.pleaseSelectAtLeastOneProduct);
    return;
  }
  if (discountType == null || discountType.isEmpty) {
    customToast(msg: AppTranslation.pleaseSelectDiscountType);
    return;
  }
  if (discountValue == null || discountValue.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterOfferDiscountValue);
    return;
  }
  final v = num.tryParse(discountValue.trim());
  if (v == null || v < 0) {
    customToast(msg: AppTranslation.invalidOfferDiscountValue);
    return;
  }
  if (discountType == 'PERCENTAGE' && v > 100) {
    customToast(msg: AppTranslation.invalidOfferDiscountValue);
    return;
  }
}
