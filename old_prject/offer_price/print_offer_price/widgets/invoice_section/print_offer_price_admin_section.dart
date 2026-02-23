import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/font_manager.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/authentication/profile/domain/entities/profile_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:flutter/material.dart';

Widget printOfferPriceAdminWidget({
  required OfferPriceSingleEntity data,
  ProfileEntity? myInfo,
}) {
  return Column(
    children: [
      if (data.employee != "")
        CustomText(
          text:
              "${TranslationsController.instance.getTranslations().salesRepresentative}: ${data.employee}",
          textStyle: getRegularStyle(
            fontSize: AppFontSize.s10,
            color: ColorManager.spaceColor,
          ),
        ),
    ],
  );
}
