import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';

bool checkPaymentDifferences(
  List<PaymentMethodEntryOffer> initialPayments,
  List<PaymentMethodEntryOffer> currentPayments,
) {
  if (initialPayments.length != currentPayments.length) return true;
  for (int i = 0; i < initialPayments.length; i++) {
    final a = initialPayments[i];
    final b = currentPayments[i];

    if (a.id != b.id ||
        a.paymentType != b.paymentType ||
        num.parse(a.amount!.text).toStringAsFixed(2) !=   num.parse(b.amount!.text).toStringAsFixed(2) ||
        a.bankName != b.bankName ||
        a.bankId != b.bankId ||
        a.dueDate != b.dueDate) {
      return true;
    }
  }

  return false;
}
