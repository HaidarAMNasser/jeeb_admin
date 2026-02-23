import 'package:fatoorahapp/core/constances/local_data.dart';

bool checkProductDifferences(
  List<CreateProductEntity> initialProducts,
  List<CreateProductEntity> currentProducts,
) {
  if (initialProducts.length != currentProducts.length) return true;

  for (int i = 0; i < initialProducts.length; i++) {
    final a = initialProducts[i];
    final b = currentProducts[i];

    if (a.id != b.id ||
        a.name != b.name ||
        a.discountTypeId != b.discountTypeId ||
        a.tax != b.tax ||
        a.taxId != b.taxId ||
        a.taxKey != b.taxKey ||
        a.taxReasonId != b.taxReasonId ||
        a.taxReason != b.taxReason ||
        a.price != b.price ||
        a.quantity != b.quantity ||
        a.taxId != b.taxId ||
        a.taxKey != b.taxKey) {
      return true;
    }
  }

  return false;
}
