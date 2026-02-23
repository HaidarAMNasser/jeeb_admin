import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/create_offer_price_presentation/create_offer_price_bloc/create_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void deleteNotValidPayment(
    BuildContext context, List<PaymentMethodEntryOffer> payments) {
  for (int i = payments.length - 1; i >= 0; i--) {
    if (payments[i].amount == null) {
      BlocProvider.of<OfferPriceCreateBloc>(context)
          .add(DeletePaymentFromOffer(index: i));
    }
  }
}
