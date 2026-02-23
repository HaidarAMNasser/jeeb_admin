import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';
import 'package:fatoorahapp/widgets/toast.dart';

void addOfferToSaleToasterValidation(
  List<CreateProductEntity> products,
  num stockId,
  num productsTotal,
  List<PaymentMethodEntryOffer> payments,
) {
  // Check if there are any products with quantity > 0
  final hasAtLeastOneReturnableProduct = products.any((p) {
    final quantity = double.tryParse(p.quantity.toString()) ?? 0.0;
    return quantity > 0;
  });

  if (!hasAtLeastOneReturnableProduct) {
    customToast(
      msg: TranslationsController.instance
          .getTranslations()
          .pleaseChooseProducts,
    );
    return;
  }
  if (stockId == 0) {
    customToast(
      msg: TranslationsController.instance
          .getTranslations()
          .pleaseChooseWarehouse,
    );
    return;
  }
  if (payments.isEmpty) {
    customToast(
      msg: TranslationsController.instance
          .getTranslations()
          .pleaseChoosePaymentMethod,
    );
    return;
  }

  // Calculate total payment amount
  num totalPaymentAmount = 0;

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

    if (parsedAmount <= 0) {
      customToast(
        msg: TranslationsController.instance
            .getTranslations()
            .paymentAmountCannotBeZero,
      );
      return;
    }

    totalPaymentAmount += parsedAmount;

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
        break;
      case "3": // Network payment
      case "5": // Other bank payment
        if (payment.bankId == null) {
          customToast(
            msg: TranslationsController.instance
                .getTranslations()
                .pleaseSelectBank,
          );
          return;
        }
        break;
    }
  }

  // Calculate total invoice amount from products

  // Check if payment total matches invoice total (EXACT comparison)
  final productsRounded = double.parse(productsTotal.toStringAsFixed(2));
  final paymentsRounded = double.parse(totalPaymentAmount.toStringAsFixed(2));

  // Convert to cents (integers) for absolute exact comparison to avoid floating point issues
  final productsCents = (productsRounded * 100).round();
  final paymentsCents = (paymentsRounded * 100).round();
  final areAmountsEqual = productsCents == paymentsCents;
  final difference = (paymentsRounded - productsRounded).abs();

  print("Payments Total: $paymentsRounded → Cents: $paymentsCents");
  print("Products Total: $productsRounded → Cents: $productsCents");
  print("Difference: $difference");
  print("Match: $areAmountsEqual");

  if (!areAmountsEqual) {
    if (paymentsCents > productsCents) {
      customToast(
        msg: TranslationsController.instance
            .getTranslations()
            .paymentGreaterThanInvoice,
      );
    } else {
      customToast(
        msg: TranslationsController.instance
            .getTranslations()
            .paymentLessThanInvoice,
      );
    }
    return;
  }
}
