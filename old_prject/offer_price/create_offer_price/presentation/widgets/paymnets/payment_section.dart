import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/create_offer_price_presentation/create_offer_price_bloc/create_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/feature/purchase_invoices/purchase_invoice_return/presentation/widgets/products/add_product_widget.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchase_request_create/presentation/widgets/select_payment_method_widget.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentSection extends StatefulWidget {
  final bool fromEdit;
  final OfferPriceSingleEntity? offerPriceSingleEntity;
  const PaymentSection({
    this.offerPriceSingleEntity,
    required this.fromEdit,
    super.key,
  });
  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  @override
  Widget build(BuildContext context) {
    // bool isFromEdit = widget.fromEdit && widget.offerPriceSingleEntity != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (context.read<OfferPriceCreateBloc>().getProducts().isNotEmpty)
          CustomText(
            text: TranslationsController.instance
                .getTranslations()
                .paymentMethod,
            textStyle: getBoldStyle(),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: BlocProvider.of<OfferPriceCreateBloc>(
            context,
          ).getPayments().length,
          itemBuilder: (context, index) {
            PaymentMethodEntryOffer item =
                BlocProvider.of<OfferPriceCreateBloc>(
                  context,
                ).getPayments()[index];
            return Padding(
              key: ValueKey('payment_${item.id}_$index'),
              padding: EdgeInsets.zero,
              child: SelectPaymentMethodWidget(
                initBank: item.bankId,
                initDate: item.dueDate,
                initTreasury: item.bankId,
                initOption: item.paymentType != "" ? item.paymentType : null,
                index: index,
                onDelete: () {
                  BlocProvider.of<OfferPriceCreateBloc>(
                    context,
                  ).add(DeletePaymentFromOffer(index: index));
                },
                item: item,
                onSelectPayment: (val) {
                  // if (BlocProvider.of<OfferPriceCreateBloc>(context)
                  //     .getPayments()
                  //     .any((e) => e.id == val.id.toString())) {
                  //   customToast(
                  //       msg: TranslationsController.instance
                  //           .getTranslations()
                  //           .duplicatePaymentMethod);
                  //   BlocProvider.of<OfferPriceCreateBloc>(context)
                  //       .add(EditPaymentInOffer(
                  //           index: index,
                  //           payment: PaymentMethodEntryOffer(
                  //               amount: index == 0
                  //                   ? TextEditingController(
                  //                       text: BlocProvider.of<
                  //                               OfferPriceCreateBloc>(context)
                  //                           .state
                  //                           .finalAmount
                  //                           .toStringAsFixed(2),
                  //                     )
                  //                   : TextEditingController(
                  //                       text: '0',
                  //                     ),
                  //               id: val.id.toString(),
                  //               paymentType: val.name)));
                  // } else {
                  BlocProvider.of<OfferPriceCreateBloc>(context).add(
                    EditPaymentInOffer(
                      index: index,
                      payment: PaymentMethodEntryOffer(
                        amount: index == 0
                            ? TextEditingController(
                                text: BlocProvider.of<OfferPriceCreateBloc>(
                                  context,
                                ).state.finalAmount.toStringAsFixed(2),
                              )
                            : TextEditingController(text: '0'),
                        id: val.id.toString(),
                        paymentType: val.name,
                        type: val.type,
                        parentId: val.parentId,
                      ),
                    ),
                  );
                  // }
                },
              ),
            );
          },
        ),
        if ((widget.fromEdit &&
                widget.offerPriceSingleEntity!.offerPriceDetails.isNotEmpty) ||
            (context.read<OfferPriceCreateBloc>().getProducts().isNotEmpty))
          AddProductWidget(
            onPressed: () {
              final payments = BlocProvider.of<OfferPriceCreateBloc>(
                context,
              ).getPayments();
              bool canAdd = true;
              for (final payment in payments) {
                if (payment.id.isEmpty) {
                  customToast(
                    msg: TranslationsController.instance
                        .getTranslations()
                        .pleaseSelectMethodFirst,
                  );
                  canAdd = false;
                  break;
                } else if (payment.amount == null ||
                    payment.amount!.text.isEmpty) {
                  customToast(
                    msg: TranslationsController.instance
                        .getTranslations()
                        .pleaseSelectValue,
                  );
                  canAdd = false;
                  break;
                } else if (payment.effectivePaymentMethodId == "8") {
                  // Business Guarantee validation
                  if (payment.dueDate == null || payment.dueDate!.isEmpty) {
                    customToast(
                      msg: TranslationsController.instance.getTranslations().pleaseSelectPaymentDateForBusinessGuarantee,
                    );
                    canAdd = false;
                    break;
                  }
                }
              }

              if (canAdd) {
                BlocProvider.of<OfferPriceCreateBloc>(context).add(
                  AddPaymentToOffer(
                    payment: PaymentMethodEntryOffer(
                      id: "",
                      paymentType: "",
                      amount: TextEditingController(text: "0"),
                    ),
                  ),
                );
              }
            },
          ),
      ],
    );
  }
}
