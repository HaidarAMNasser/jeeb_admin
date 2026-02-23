import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

void productValidationToast({
  String? name,
  String? price,
  String? categoryId,
  List<String>? images,
}) {
  if (name == null || name.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterProductName);
    return;
  }

  if (price == null || price.trim().isEmpty) {
    customToast(msg: AppTranslation.pleaseEnterProductPrice);
    return;
  }

  final priceValue = double.tryParse(price.trim());
  if (priceValue == null || priceValue <= 0) {
    customToast(msg: AppTranslation.invalidProductPrice);
    return;
  }

  if (categoryId == null || categoryId.isEmpty) {
    customToast(msg: AppTranslation.pleaseSelectCategory);
    return;
  }

  if (images == null || images.isEmpty) {
    customToast(msg: AppTranslation.pleaseAddAtLeastOneImage);
    return;
  }
}

bool isProductFormValid({
  required String name,
  required String price,
  required String? categoryId,
  required List<String> images,
}) {
  if (name.trim().isEmpty) return false;
  if (price.trim().isEmpty) return false;
  final priceValue = double.tryParse(price.trim());
  if (priceValue == null || priceValue <= 0) return false;
  if (categoryId == null || categoryId.isEmpty) return false;
  if (images.isEmpty) return false;
  return true;
}

