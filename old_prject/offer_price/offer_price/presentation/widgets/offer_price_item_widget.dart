import 'package:fatoorahapp/core/constances/assets_manager.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/font_manager.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/core/routing/navigation_extensions.dart';
import 'package:fatoorahapp/core/routing/routes.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/presentation/widgets/offer_price_title_widget.dart';
import 'package:fatoorahapp/feature/shif_indicators/presentation/widgets/number_of_invoices_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/custom_images_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../widgets/text_colored_container_widget.dart';

class OfferPriceItemWidget extends StatelessWidget {
  final bool showIcon;
  final OfferPriceDataEntity? offerPriceDataEntity;
  const OfferPriceItemWidget({
    super.key,
    required this.showIcon,
    this.offerPriceDataEntity,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          Routes.offerPriceDetailsScreen,
          arguments: {"offerPriceDataEntity": offerPriceDataEntity},
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showIcon) ...[
              Container(
                padding: EdgeInsets.all(4.w),
                height: 36.w,
                width: 36.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorManager.green50,
                  shape: BoxShape.circle,
                ),
                child: CustomSvgAssetImage(image: IconAssets.receipt),
              ),
              verticalSpace(height: 12.h),
            ],
            OfferPriceTitleWidget(
              offerPriceDataEntity: this.offerPriceDataEntity!,
              title: offerPriceDataEntity!.user.name,
              id: offerPriceDataEntity!.user.identificationNumber.toString(),
              showOptions: !showIcon,
            ),
            verticalSpace(height: 12.h),
            Row(
              children: [
                TextInColoredContainerWidget(
                  text: this.offerPriceDataEntity!.date,
                  color: ColorManager.green50,
                ),
                horizontalSpace(width: 8.w),
                TextInColoredContainerWidget(
                  text:
                      '${TranslationsController.instance.getTranslations().quotationNumber} ${this.offerPriceDataEntity!.identificationNumber}',
                  color: ColorManager.green50,
                ),
              ],
            ),
            // this.offerPriceDataEntity!.identificationNumber.toString(),
            verticalSpace(height: 20.h),
            NumberOfInvoicesTextWidget(
              title:
                  "${TranslationsController.instance.getTranslations().expirationDate} ",
              number: "${this.offerPriceDataEntity!.expirationDate}",
              hasDot: false,
              titleFontSize: 12.sp,
              numberFontSize: 12.sp,
              numberColor: ColorManager.textColor,
            ),
            verticalSpace(height: 12.h),
            NumberOfInvoicesTextWidget(
              numberFontSize: AppFontSize.s14,
              fontWeight: FontWeight.w700,
              title:
                  "${TranslationsController.instance.getTranslations().quotationValue}",
              number: this.offerPriceDataEntity!.totalPrice.toString(),
              hasDot: false,
              titleFontSize: 12.sp,
            ),
            if (this.offerPriceDataEntity!.payments.isNotEmpty) ...[
              verticalSpace(height: 12.h),
              NumberOfInvoicesTextWidget(
                title:
                    "${TranslationsController.instance.getTranslations().paymentType} ",
                number: this.offerPriceDataEntity!.payments
                    .map((e) => e.methodName ?? Payment(e.methodId.toString()).title)
                    .join(", "),
                hasDot: false,
                titleFontSize: 12.sp,
                numberFontSize: 12.sp,
                numberColor: ColorManager.textColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
