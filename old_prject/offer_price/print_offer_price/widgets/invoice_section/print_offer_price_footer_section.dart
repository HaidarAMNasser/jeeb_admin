import 'package:fatoorahapp/core/constances/assets_manager.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/font_manager.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/custom_images_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';

class PrintOfferPriceFooterSection extends StatelessWidget {
  final OfferPriceSingleEntity data;
  const PrintOfferPriceFooterSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: AppPadding.p16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                CustomText(
                  text: TranslationsController.instance
                      .getTranslations()
                      .invoiceText1,
                  textAlign: TextAlign.center,
                  textStyle: getRegularStyle(
                    fontSize: AppFontSize.s8,
                    color: ColorManager.invoiceQrDescription,
                  ),
                ),
                verticalSpace(height: AppHeight.s8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: TranslationsController.instance
                          .getTranslations()
                          .invoiceText2,
                      textStyle: getRegularStyle(
                        fontSize: AppFontSize.s8,
                        color: ColorManager.invoiceQrDescription,
                      ),
                    ),
                    horizontalSpace(width: AppWidth.s4),
                    CustomAssetImage(
                      image: ImageAssets.textLogo,
                      height: AppHeight.s9,
                      width: AppWidth.s25,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // QrImageView(data: data.uuid, size: AppSize.s100)
        ],
      ),
    );
  }
}
