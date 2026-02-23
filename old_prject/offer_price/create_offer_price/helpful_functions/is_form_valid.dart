import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';

// bool isFormValid(
//     String? clientId,
//     String? adminId,
//     List<CreateProductEntity> products,
//     List<PaymentMethodEntryOffer> payments,
//     num total) {
//   if (products.isEmpty || payments.isEmpty || clientId == "" || adminId == "") {
//     return false;
//   }
//   final ids = <String>{};
//   for (var payment in payments) {
//     if (payment.id.isEmpty ) {
//       return false;
//     }
//   }
//   // num total = products.fold<num>(
//   //   0,
//   //   (previousValue, product) =>
//   //       previousValue +
//   //       ((num.tryParse(product.price) ?? 0) *
//   //           (num.tryParse(product.quantity.toString()) ?? 1)),
//   // );

//   num sum = 0;
//   for (var payment in payments) {
//     if (payment.amount != null &&
//         payment.amount!.text.isNotEmpty &&
//         payment.amount!.text != "0") {
//       sum += num.tryParse(payment.amount!.text) ?? 0;
//     } else {
//       return false;
//     }
//     switch (payment.id) {
//       case "2":
//         if (payment.dueDate == null || payment.dueDate == "") {
//           return false;
//         }
//         break;
//       case "1":
//       case "3":
//       case "5":
//         if (payment.bankId == null) {
//           return false;
//         }
//         break;
//       default:
//         break;
//     }
//   }

//   bool arePaymentsCorrect = (num.parse(total.toStringAsFixed(2)) ==
//       num.parse(sum.toStringAsFixed(2)));
//   return arePaymentsCorrect;
// }
bool isFormValid(
  String? clientId,
  String? adminId,
  List<CreateProductEntity> products,

  List<PaymentMethodEntryOffer> payments,
  num total,
  String workplaceId,
) {
  // Basic checks for client, admin, and products
  if (products.isEmpty || clientId == "") {
    return false;
  }

  // If no payment methods are added, consider it valid
  if (payments.isEmpty) {
    return true;
  }

  // Now we validate each payment if at least one is added
  num sum = 0;
  for (var payment in payments) {
    if (payment.id.isEmpty) {
      return false;
    }

    if (payment.amount == null ||
        payment.amount!.text.isEmpty ||
        payment.amount!.text == "0" ||
        payment.amount!.text == "0.00") {
      return false;
    }

    // Validate amount precision (max 2 decimal places)
    final amountText = payment.amount!.text.trim();
    if (!RegExp(r'^-?\d+(\.\d{1,2})?$').hasMatch(amountText)) {
      print("❌ Payment amount must have at most 2 decimal places. Value: $amountText");
      return false;
    }

    sum += num.tryParse(payment.amount!.text) ?? 0;

    switch (payment.effectivePaymentMethodId) {
      case "2": // due date required
        if (payment.dueDate == null || payment.dueDate == "") {
          return false;
        }
        break;
      case "1":
      case "3":
      case "5": // bank required
        if (payment.bankId == null) {
          return false;
        }
        break;
      case "8": // Business Guarantee - date required
        if (payment.dueDate == null || payment.dueDate!.isEmpty) {
          return false;
        }
        break;
      default:
        break;
    }
  }

  // Round both to 2 decimal places for exact comparison
  final sumRounded = double.parse(sum.toStringAsFixed(2));
  final totalRounded = double.parse(total.toStringAsFixed(2));
  
  // Convert to cents (integers) for absolute exact comparison to avoid floating point issues
  final sumCents = (sumRounded * 100).round();
  final totalCents = (totalRounded * 100).round();
  final differenceCents = sumCents - totalCents;
  
  print('\n💰 [OFFER PRICE VALIDATION]');
  print('  ├─ Sum of payments: $sumRounded → Cents: $sumCents');
  print('  ├─ Expected total: $totalRounded → Cents: $totalCents');
  print('  ├─ Difference in cents: $differenceCents');

  if (sumCents < totalCents) {
    print('  └─ ❌ Payments LESS than total\n');
    return false;
  } else if (sumCents > totalCents) {
    print('  └─ ❌ Payments GREATER than total\n');
    return false;
  }

  print('  └─ ✅ Payments exactly match total\n');
  return true;
}
