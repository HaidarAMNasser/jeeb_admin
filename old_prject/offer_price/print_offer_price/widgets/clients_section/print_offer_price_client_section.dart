import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/font_manager.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';

class PrintOfferPriceClientSection extends StatelessWidget {
  final OfferPriceSingleEntity data;
  const PrintOfferPriceClientSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final translations = TranslationsController.instance.getTranslations();
    final user = data.user;
    final address = user.clientsDataAddressesEntity.isNotEmpty == true
        ? user.clientsDataAddressesEntity[0]
        : null;

    bool isValid(String? value) {
      return value != null && value.trim().isNotEmpty && value != 'null';
    }

    String buildAddressString() {
      if (address == null) return '';
      final parts = [
        address.countryEntity.name.trim(),
        address.regionEntity.name.trim(),
        address.cityEntity.name.trim(),
        address.area.trim(),
      ].where((element) => element.isNotEmpty).toList();
      return parts.join(' - ');
    }

    String buildAnotherAddressInfoString() {
      if (address == null) return '';
      final parts = [
        address.buildingNumber.trim(),
        address.street.trim(),
        address.postalCode.trim(),
      ].where((element) => element.isNotEmpty).toList();
      return parts.join(' - ');
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isValid(user.name))
          CustomText(
            text: '  ${user.name} ',
            textStyle: getBoldStyle(
              fontSize: AppFontSize.s10,
              color: ColorManager.spaceColor,
            ),
          ),
        if (isValid(user.commercialRecord)) ...[
          verticalSpace(height: AppHeight.s4),
          CustomText(
            text:
                "${LocalBuyerSchemeData.getLabelByKey(data.user.identityType)} ${user.commercialRecord}",
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s10,
              color: ColorManager.spaceColor,
            ),
          ),
        ],
        if (buildAddressString().isNotEmpty) ...[
          verticalSpace(height: AppHeight.s4),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    text: buildAddressString(),
                    textStyle: getRegularStyle(
                      fontSize: AppFontSize.s10,
                      color: ColorManager.spaceColor,
                    ),
                  ),
                  if (buildAnotherAddressInfoString().isNotEmpty)
                    CustomText(
                      text: buildAnotherAddressInfoString(),
                      textStyle: getRegularStyle(
                        fontSize: AppFontSize.s10,
                        color: ColorManager.spaceColor,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],

        if (isValid(user.taxNumber)) ...[
          verticalSpace(height: AppHeight.s4),
          CustomText(
            text: "${translations.taxNumber} : ${user.taxNumber}",
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s10,
              color: ColorManager.spaceColor,
            ),
          ),
        ],
        if (isValid(user.companyPhone)) ...[
          verticalSpace(height: AppHeight.s4),
          CustomText(
            text: '${translations.phone} : ${user.companyPhone}',
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s10,
              color: ColorManager.spaceColor,
            ),
          ),
        ],
        if (isValid(user.companyMobile)) ...[
          verticalSpace(height: AppHeight.s4),
          CustomText(
            text: '${translations.mobileNumber} : ${user.companyMobile}',
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s10,
              color: ColorManager.spaceColor,
            ),
          ),
        ],
        if (isValid(user.phone)) ...[
          verticalSpace(height: AppHeight.s4),
          CustomText(
            text: '${translations.phone} : ${user.phone}',
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s10,
              color: ColorManager.spaceColor,
            ),
          ),
        ],
        if (isValid(user.address)) ...[
          CustomText(
            text: '${translations.address} : ${buildAddressString()}',
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s10,
              color: ColorManager.spaceColor,
            ),
          ),
        ],
      ],
    );
  }
}
