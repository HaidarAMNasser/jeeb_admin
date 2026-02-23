import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/helpful_functions/toaster_offer_to_sale_validation.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/bloc/offer_to_sale_Invoice_bloc.dart';
import 'package:fatoorahapp/feature/sales_invoices/create_sale_invoice/presentation/bloc/create_sale_invoice_bloc.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';
import 'package:fatoorahapp/widgets/fly_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget offerToSaleSubmissionButton({
  required String referenceNumber,
  required int userId,
  required String zatcaInvoiceType,
  required int employeeId,
  required int stockId,
  required int workPlaceId,
  required String dueDate,
  required String supplyDate,
  required String serviceEndDate,
  required String status,
  required List<CreateProductEntity> products,
  required List<PaymentMethodEntryOffer> payments,
}) {
  return BlocBuilder<MapOfferToInvoiceBloc, MapOfferToInvoiceState>(
    // buildWhen: (previous, current) =>
    //     previous.isValid != current.isValid ||
    //     previous.finalAmount != current.finalAmount ||
    //     previous.details != current.details ||
    //     previous.payments != current.payments,
    builder: (context, state) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          color: ColorManager.transparent,
        ),
        child: FlyButtonWidget(
          buttonColor: state.isValid && stockId != 0
              ? ColorManager.primaryColor
              : ColorManager.closeDialogColor,
          backgroundColor: ColorManager.transparent,
          onSuccess: () {
            // Call the toaster validation function
            print(state.finalAmount);
            addOfferToSaleToasterValidation(
              products,
              stockId,
              num.parse(state.finalAmount.toString()),
              payments,
            );
            print("aaaaaa${stockId}");

            if (stockId != 0 && state.isValid) {
              context.read<CreateSaleInvoiceBloc>().add(
                CreateInvoiceSubmitted(
                  quotationExpiryDate: serviceEndDate,
                  referenceNumber: referenceNumber,
                  userId: userId,
                  zatcaInvoiceType: zatcaInvoiceType,
                  employeeId: employeeId,
                  stockId: stockId,
                  workPlaceId: workPlaceId,
                  dueDate: dueDate,
                  supplyDate: supplyDate,
                  serviceEndDate: serviceEndDate,
                  status: status,
                  products: products,
                  payments: payments,
                ),
              );
            }
          },
          successButtonText: TranslationsController.instance
              .getTranslations()
              .save,
        ),
      );
    },
  );
}
