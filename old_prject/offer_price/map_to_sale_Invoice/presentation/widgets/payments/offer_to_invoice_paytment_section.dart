import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/bloc/offer_to_sale_Invoice_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/widgets/payments/offer_to_sale_payment_item.dart';
import 'package:fatoorahapp/feature/purchase_invoices/purchase_invoice_return/presentation/widgets/products/add_product_widget.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfferToSalePaymentSection extends StatefulWidget {
  const OfferToSalePaymentSection({super.key});
  @override
  State<OfferToSalePaymentSection> createState() =>
      _OfferToSalePaymentSectionState();
}

class _OfferToSalePaymentSectionState extends State<OfferToSalePaymentSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapOfferToInvoiceBloc, MapOfferToInvoiceState>(
      builder: (context, state) {
        final payments = state.payments;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.details.isNotEmpty)
              CustomText(
                text: TranslationsController.instance
                    .getTranslations()
                    .paymentMethods,
                textStyle: getBoldStyle(),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final item = payments[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSize.s10),
                  child: OfferToSalePaymentMethodWidget(
                    initBank: item.bankId,
                    initDate: item.dueDate,
                    initTreasury: item.bankId,
                    initOption: item.paymentType != ""
                        ? item.paymentType
                        : null,
                    index: index,
                    onDelete: () {
                      context.read<MapOfferToInvoiceBloc>().add(
                        DeletePaymentFromOfferInvoice(index: index),
                      );
                    },
                    item: item,
                    onSelectPayment: (val) {
                      final bloc = BlocProvider.of<MapOfferToInvoiceBloc>(
                        context,
                      );
                      final existingPayment = bloc.state.payments[index];

                      // Create new amount controller with updated value
                      final newAmount = (index == 0)
                          ? bloc.state.finalAmount.toStringAsFixed(2)
                          : '0.00';

                      final updatedPayment = existingPayment.copyWith(
                        id: val.id.toString(),
                        paymentType: val.name,
                        type: val.type,
                        parentId: val.parentId,
                        amount: TextEditingController(text: newAmount),
                      );

                      bloc.add(
                        EditPaymentInOfferInvoice(
                          index: index,
                          payment: updatedPayment,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            if (state.details.isNotEmpty)
              AddProductWidget(
                onPressed: () {
                  context.read<MapOfferToInvoiceBloc>().add(
                    AddPaymentToOfferInvoice(
                      payment: PaymentMethodEntryOffer(
                        id: "",
                        paymentType: "",
                        amount: TextEditingController(text: "0"),
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
