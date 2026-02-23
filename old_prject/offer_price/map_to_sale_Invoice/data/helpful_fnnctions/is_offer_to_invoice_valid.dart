// import 'package:fatoorahapp/core/constances/local_data.dart';
// import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';

// bool isOfferToInvoiceFormValid({
//   required List<CreateProductEntity> products,
//   required List<PaymentMethodEntryOffer> payments,
//   required num productsTotal,
//   required String dstcokId,
  
// }) {
//   print("🟨 Input Products: ${products.length} items");
//   print("🟨 Input Payments: ${payments.length} items");

//   // --- Step 1: Check for returnable products ---
//   final hasAtLeastOneReturnableProduct = products.any((p) {
//     final quantity = double.tryParse(p.quantity.toString()) ?? 0.0;
//     return quantity > 0;
//   });
//   print(
//       "🟦 [Step 1] Has returnable product? -> $hasAtLeastOneReturnableProduct");
//   if (!hasAtLeastOneReturnableProduct) {
//     print("❌ No returnable products. Exiting.");
//     return false;
//   }
//   if (dstcokId == "0" || dstcokId == "") {
//     print("❌ No stock selected. Exiting.");
//     return false;
//   }
//   // --- Step 2: Debug product total calculations ---
//   print("🟦 [Step 2] Product Line Calculations:");
//   for (int i = 0; i < products.length; i++) {
//     final product = products[i];
//     final quantity = double.tryParse(product.quantity.toString()) ?? 0.0;
//     final price = double.tryParse(product.price) ?? 0.0;
//     final discountPerItem =
//         double.tryParse(product.discountValue ?? '0.0') ?? 0.0;
//     final lineTax = double.tryParse(product.taxValue ?? '0') ?? 0.0;
//     final lineTotal = price * quantity;
//     final lineDiscount = discountPerItem * quantity;
//     final taxableAmount = lineTotal - lineDiscount;

//     print("   • Product #$i -> name: ${product.name}");
//     print(
//         "     Qty: $quantity | Price: $price | Tax: $lineTax | Disc/item: $discountPerItem");
//     print(
//         "     Line total: $lineTotal | Line discount: $lineDiscount | Taxable: $taxableAmount");
//   }

//   // --- Step 3 & 4: Edge cases ---
//   if (productsTotal <= 0.0) {
//     print("🟨 [Step 3] Product total is 0. Returning TRUE.");
//     return true;
//   }
//   if (payments.isEmpty) {
//     print("❌ [Step 4] Payments empty, but total > 0. Returning FALSE.");
//     return false;
//   }

//   // --- Step 5: Validate payments ---
//   print("🟦 [Step 5] Validating payments...");
//   double paymentsSum = 0.0;
//   final Set<String> seenPaymentIds = {};

//   for (int i = 0; i < payments.length; i++) {
//     final payment = payments[i];
//     final id = payment.id;

//     print("   • Payment #$i -> ID: $id");

//     if (id.isEmpty) {
//       print("❌ Empty payment ID.");
//       return false;
//     }

//     // if (!seenPaymentIds.add(id)) {
//     //   print("❌ Duplicate payment ID: $id");
//     //   return false;
//     // }

//     final amountText = payment.amount?.text ?? '0';
//     final amount = double.tryParse(amountText) ?? 0.0;
//     print("     Amount: $amount");

//     if (amount <= 0) {
//       print("❌ Invalid payment amount (<= 0).");
//       return false;
//     }
//     paymentsSum += amount;

//     switch (id) {
//       case "2":
//         if (payment.dueDate == null || payment.dueDate!.isEmpty) {
//           print("❌ Missing due date for credit payment.");
//           return false;
//         } else {
//           print("     ✓ Due date: ${payment.dueDate}");
//         }
//         break;
//       case "1":
//       case "3":
//       case "5":
//         if (payment.bankId == null) {
//           print("❌ Missing bank ID for bank/cheque/card.");
//           return false;
//         } else {
//           print("     ✓ Bank ID: ${payment.bankId}");
//         }
//         break;
//       default:
//         print("     ✓ No extra validation needed for method $id");
//         break;
//     }
//   }

//   // --- Step 6: Final check ---
//   const double epsilon = 0.01;
//   final difference = (productsTotal - paymentsSum).abs();
//   final areAmountsEqual = difference < epsilon;

//   print("🟩 [Step 6] Comparing totals:");
//   print("     Products Total: $productsTotal");
//   print("     Payments Total: $paymentsSum");
//   print("     Difference: $difference");
//   print("     Allowed Epsilon: $epsilon");
//   print("     Amounts Equal? -> $areAmountsEqual");

//   return areAmountsEqual;
// }
