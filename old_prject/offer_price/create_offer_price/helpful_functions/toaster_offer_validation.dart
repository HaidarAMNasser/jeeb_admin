import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';
import 'package:fatoorahapp/widgets/toast.dart';

void addOfferPriceToasterValidation(
  String? selectedAdmin,
  String? selectedWorkPlace,
  String? selectedClient,
  List<CreateProductEntity> products,
  List<PaymentMethodEntryOffer> payments,
) {
  if (selectedClient == null || selectedClient == "") {
    customToast(
      msg: TranslationsController.instance
          .getTranslations()
          .pleaseChooseCustomer,
    );
  } else if (products.isEmpty) {
    customToast(
      msg: TranslationsController.instance
          .getTranslations()
          .pleaseChooseProducts,
    );
  }
  // else if (payments.isEmpty) {
  //   customToast(
  //       msg: TranslationsController.instance
  //           .getTranslations()
  //           .pleaseChoosePaymentMethod);
  // }
  else {
    // Check for payment method specific validations
    for (var payment in payments) {
      // Validate payment amount
      if (payment.amount == null || payment.amount!.text.trim().isEmpty) {
        customToast(
          msg: TranslationsController.instance
              .getTranslations()
              .pleaseEnterPaymentAmount,
        );
        return;
      }

      final parsedAmount = num.tryParse(payment.amount!.text.trim());
      if (parsedAmount == null) {
        customToast(
          msg: TranslationsController.instance
              .getTranslations()
              .invalidPaymentAmount,
        );
        return;
      }

      if (parsedAmount == 0) {
        customToast(
          msg: TranslationsController.instance
              .getTranslations()
              .paymentAmountCannotBeZero,
        );
        return;
      }

      // Check payment method specific requirements using effective ID for behavior classification
      switch (payment.effectivePaymentMethodId) {
        case "2": // Deferred payment
          if (payment.dueDate == null || payment.dueDate!.isEmpty) {
            customToast(
              msg: TranslationsController.instance
                  .getTranslations()
                  .pleaseSelectDueDate,
            );
            return;
          }
          break;
        case "1":
          if (payment.bankId == null) {
            customToast(msg: TranslationsController.instance
                .getTranslations()
                .pleaseSelectTreasury);
            return;
          }
        case "3":
        case "5":
          if (payment.bankId == null) {
            customToast(
              msg: TranslationsController.instance
                  .getTranslations()
                  .pleaseSelectBank,
            );
            return;
          }
          break;
        case "8": // Business Guarantee
          if (payment.dueDate == null || payment.dueDate!.isEmpty) {
            customToast(msg: TranslationsController.instance.getTranslations().pleaseSelectPaymentDateForBusinessGuarantee);
            return;
          }
          final amountText = payment.amount!.text.trim();
          if (!RegExp(r'^-?\d+(\.\d{1,2})?$').hasMatch(amountText)) {
            customToast(
              msg: TranslationsController.instance.getTranslations().businessGuaranteeAmountMaxTwoDecimals,
            );
            return;
          }
          break;
      }
    }
  }
}
