import 'dart:ui' as ui;
import 'package:fatoorahapp/core/constances/assets_manager.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/font_manager.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/helpful_funcations/format_to_only_date.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/authentication/profile/domain/entities/profile_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/feature/offer_price/print_offer_price/widgets/invoice_section/print_offer_price_address_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/build_commercial_record.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/custom_images_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrintOfferPriceHeaderSection extends StatelessWidget {
  final OfferPriceSingleEntity data;
  final ProfileEntity? myInfo;

  const PrintOfferPriceHeaderSection({
    super.key,
    required this.data,
    this.myInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CachedImageWidget(
          isCircle: false,
          image: myInfo?.client.image ?? '',
          imageHeight: AppHeight.s33,
          imageWidth: AppWidth.s56,
        ),
        verticalSpace(height: AppHeight.s4),
        CustomText(
          text: TranslationsController.instance
              .getTranslations()
              .quotationTitle,
          textStyle: getBoldStyle(
            fontSize: AppFontSize.s12,
            color: ColorManager.black,
          ),
        ),
        verticalSpace(height: AppHeight.s4),
        const CustomSvgAssetImage(image: ImageAssets.invoiceBarcode),
        verticalSpace(height: AppHeight.s4),
        CustomText(
          text:
              "${TranslationsController.instance.getTranslations().quotationNumber} ${data.identificationNumber}",
          textStyle: getBoldStyle(
            fontSize: AppFontSize.s10,
            color: ColorManager.spaceColor,
          ),
        ),
        verticalSpace(height: AppHeight.s4),
        CustomText(
          text: myInfo?.client.name ?? '',
          textStyle: getBoldStyle(
            fontSize: AppFontSize.s10,
            color: ColorManager.black,
          ),
        ),
        if (data.workplaceEntity.commercialName != null &&
            data.workplaceEntity.commercialName!.isNotEmpty) ...[
          verticalSpace(height: AppHeight.s4),
          CustomText(
            text:
                data.workplaceEntity.commercialName ??
                myInfo?.client.commercialName ??
                '',
            textStyle: getBoldStyle(
              fontSize: AppFontSize.s10,
              color: ColorManager.black,
            ),
          ),
        ],
        verticalSpace(height: AppHeight.s4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text:
                  "${TranslationsController.instance.getTranslations().offerDate}: ",
              textStyle: getRegularStyle(
                fontSize: AppFontSize.s10,
                color: ColorManager.spaceColor,
              ),
            ),
            Directionality(
              textDirection: ui.TextDirection.ltr,
              child: CustomText(
                text: "${formatToDateOnly(data.date)}",
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s10,
                  color: ColorManager.spaceColor,
                ),
              ),
            ),
          ],
        ),

        if (data.supplyDate.isNotEmpty) ...[
          verticalSpace(height: AppHeight.s4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text:
                    "${TranslationsController.instance.getTranslations().quotationDate}: ",
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s10,
                  color: ColorManager.spaceColor,
                ),
              ),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: CustomText(
                  text: "${formatToDateOnly(data.supplyDate)}",
                  textStyle: getRegularStyle(
                    fontSize: AppFontSize.s10,
                    color: ColorManager.spaceColor,
                  ),
                ),
              ),
            ],
          ),
        ],

        if (data.expirationDate.isNotEmpty) ...[
          verticalSpace(height: AppHeight.s4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text:
                    "${TranslationsController.instance.getTranslations().expirationDate} ",
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s10,
                  color: ColorManager.spaceColor,
                ),
              ),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: CustomText(
                  text: "${formatToDateOnly(data.expirationDate)}",
                  textStyle: getRegularStyle(
                    fontSize: AppFontSize.s10,
                    color: ColorManager.spaceColor,
                  ),
                ),
              ),
            ],
          ),
        ],
        if (data.serviceEndDate.isNotEmpty) ...[
          verticalSpace(height: AppHeight.s4),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text:
                    "${TranslationsController.instance.getTranslations().quotationExpiryDate}: ",
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s10,
                  color: ColorManager.spaceColor,
                ),
              ),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: CustomText(
                  text: "${formatToDateOnly(data.serviceEndDate)}",
                  textStyle: getRegularStyle(
                    fontSize: AppFontSize.s10,
                    color: ColorManager.spaceColor,
                  ),
                ),
              ),
            ],
          ),
        ],
        //  verticalSpace(height: AppHeight.s4),
        PrintOfferPriceAddressWidget(data: data, myInfo: myInfo),
        verticalSpace(height: AppHeight.s4),
        buildCommercialRecord(data.workplaceEntity, myInfo),
        verticalSpace(height: AppHeight.s4),
        CustomText(
          text:
              "${TranslationsController.instance.getTranslations().taxNumber} ${myInfo?.client.taxNumber ?? ''}",
          textStyle: getRegularStyle(
            fontSize: AppFontSize.s10,
            color: ColorManager.spaceColor,
          ),
        ),
        if (data.workplaceEntity.phone != "" || myInfo?.client.phone != "") ...[
          verticalSpace(height: AppHeight.s4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: TranslationsController.instance.getTranslations().phone,
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s10,
                  color: ColorManager.spaceColor,
                ),
              ),
              horizontalSpace(width: 4.w),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: CustomText(
                  text: data.workplaceEntity.phone != ""
                      ? data.workplaceEntity.phone
                      : myInfo != null
                      ? myInfo?.client.phone ?? ''
                      : "",
                  textStyle: getRegularStyle(
                    fontSize: AppFontSize.s10,
                    color: ColorManager.spaceColor,
                  ),
                ),
              ),
            ],
          ),
        ],
        if (data.workplaceEntity.mobile != "")
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: TranslationsController.instance
                      .getTranslations()
                      .mobileNumber,
                  textStyle: getRegularStyle(
                    fontSize: AppFontSize.s10,
                    color: ColorManager.spaceColor,
                  ),
                ),
                horizontalSpace(width: 4.w),
                data.workplaceEntity.mobile != ""
                    ? Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: CustomText(
                          text: data.workplaceEntity.mobile,
                          textStyle: getRegularStyle(
                            fontSize: AppFontSize.s10,
                            color: ColorManager.spaceColor,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
      ],
    );
  }
}
