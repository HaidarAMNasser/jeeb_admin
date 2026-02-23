import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/helpful_functions/delete_not_valid_payment.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/helpful_functions/is_form_valid.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/helpful_functions/toaster_offer_validation.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/create_offer_price_presentation/create_offer_price_bloc/create_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/update_offer_price/presentation/bloc/update_offer_price_bloc.dart';
import 'package:fatoorahapp/widgets/fly_button_widget.dart';
import 'package:fatoorahapp/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget createOfferPriceSubbmissionButton({
  required selectedClient,
  required selectedAdmin,
  required refrenceNumber,
  required identificationNumber,
  required supplyDate,
  required serviceEndDate,
  required expirationDate,
  required date,
  required selectedWorkPlace,
  required bool fromEdit,
  String? offerPriceId,
}) {
  return BlocBuilder<OfferPriceCreateBloc, CreateOfferPriceState>(
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
          buttonColor: fromEdit
              ? state.hasChanges && state.isValid
                    ? ColorManager.primaryColor
                    : ColorManager.closeDialogColor
              : state.isValid
              ? ColorManager.primaryColor
              : ColorManager.closeDialogColor,
          backgroundColor: ColorManager.transparent,
          onSuccess: () {
            isFormValid(
              selectedAdmin,
              selectedClient,
              context.read<OfferPriceCreateBloc>().getProducts(),
              context.read<OfferPriceCreateBloc>().getPayments(),
              context.read<OfferPriceCreateBloc>().state.finalAmount,
              selectedWorkPlace.toString(),
            );
            addOfferPriceToasterValidation(
              selectedAdmin.toString(),
              selectedWorkPlace.toString(),
              selectedClient,
              context.read<OfferPriceCreateBloc>().getProducts(),
              context.read<OfferPriceCreateBloc>().getPayments(),
            );
            deleteNotValidPayment(
              context,
              context.read<OfferPriceCreateBloc>().getPayments(),
            );
            if (!fromEdit && state.isValid) {
              context.read<OfferPriceCreateBloc>().add(
                OfferPriceCreateSubmitted(
                  referenceNumber: refrenceNumber.text,
                  userId: int.parse(selectedClient),
                  supplyDate: supplyDate,
                  serviceEndDate: serviceEndDate,
                  workPalceId: selectedWorkPlace,
                  expirationDate: expirationDate,
                  employeeId: int.tryParse(selectedAdmin ?? '0') ?? 0,
                  payments: context.read<OfferPriceCreateBloc>().getPayments(),
                  date: date,
                  status: 1,
                  details: context.read<OfferPriceCreateBloc>().getProducts(),
                ),
              );
            } else if (fromEdit && state.isValid && state.hasChanges) {
              if (offerPriceId != null) {
                context.read<OfferPriceUpdateBloc>().add(
                  OfferPriceUpdateSubmitted(
                    offerPriceId: offerPriceId,
                    referenceNumber: refrenceNumber.text,
                    userId: int.parse(selectedClient),
                    supplyDate: supplyDate,
                    serviceEndDate: serviceEndDate,
                    workPalceId: selectedWorkPlace,
                    expirationDate: expirationDate,
                    employeeId: int.tryParse(selectedAdmin) ?? 0,
                    payments: context
                        .read<OfferPriceCreateBloc>()
                        .getPayments(),
                    date: date,
                    status: 1,
                    details: context.read<OfferPriceCreateBloc>().getProducts(),
                  ),
                );
              }
            }
            if (state.hasChanges == false && state.isValid ) {
              customToast(
                msg: TranslationsController.instance
                    .getTranslations()
                    .noChanges,
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
