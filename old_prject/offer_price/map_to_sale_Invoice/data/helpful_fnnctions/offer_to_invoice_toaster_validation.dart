import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';
import 'package:fatoorahapp/widgets/toast.dart';

bool addOfferToInvoiceToasterValidation(
  List<CreateProductEntity> products,
  List<PaymentMethodEntryOffer> payments,
  String dstcokId,
) {
  if (products.isEmpty) {
    customToast(
      msg: TranslationsController.instance
          .getTranslations()
          .pleaseChooseProducts,
    );
    return false;
  } else {
    // Check if all products have quantity zero
    bool hasValidQuantity = false;
    for (var product in products) {
      if (product.quantity != "" && product.quantity != '0') {
        hasValidQuantity = true;
        break;
      }
    }

    if (!hasValidQuantity) {
      customToast(msg: "لا يمكن اختيار منتج بالكمية 0");
      return false;
    }
    if (dstcokId == "0" || dstcokId == "") {
      customToast(msg: "يجب اختيار المخزن");
      return false;
    }
    if (payments.isEmpty) {
      customToast(
        msg: TranslationsController.instance
            .getTranslations()
            .pleaseChoosePaymentMethod,
      );
      return false;
    } else if (payments.any((e) => e.amount == null || e.amount!.text == "0")) {
      customToast(
        msg: TranslationsController.instance
            .getTranslations()
            .pleaseSelectValue,
      );
      return false;
    } else {
      // final paymentIds = payments.map((p) => p.id).toList();

      // if (paymentIds.length != paymentIds.toSet().length) {
      //   customToast(
      //       msg: TranslationsController.instance
      //           .getTranslations()
      //           .duplicatePaymentMethod);
      //   return false;
      // }
    }
  }
  return true;
}
