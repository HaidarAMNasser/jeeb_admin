import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/offer/create_offer/domain/entities/offer_product_line.dart';

void offerValidationToast({
  String? name,
  String? description,
  List<OfferProductLine>? offerProducts,
  String? discountType,
  String? discountValue,
}) {
  if (name == null || name.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterOfferName);
    return;
  }
  if (description == null || description.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterOfferDescription);
    return;
  }
  if (offerProducts == null || offerProducts.isEmpty) {
    customToast(msg: AppTranslation.pleaseSelectAtLeastOneProduct);
    return;
  }
  for (final line in offerProducts) {
    if (line.quantity < 1) {
      customToast(msg: AppTranslation.pleaseEnterValidOfferProductQuantity);
      return;
    }
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
