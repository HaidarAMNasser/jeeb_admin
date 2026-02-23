import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/font_manager.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/helpful_funcations/smart_scrollable_text.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/shif_indicators/presentation/widgets/number_of_invoices_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsWidget extends StatefulWidget {
  final OfferPriceDetailEntity productEntity;
  const ProductDetailsWidget({super.key, required this.productEntity});

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  var isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r18.r),
        border: Border.all(color: ColorManager.borderColor),
      ),
      child: Column(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Row(
              children: [
                Row(
                  children: [
                    SmartScrollableText(
                      maxWidth: 200.w,
                      child: CustomText(
                        text: widget.productEntity.product.name,
                        textStyle: getBoldStyle(
                          fontSize: AppFontSize.s14,
                          color: ColorManager.labelColor,
                        ),
                      ),
                    ),
                    //
                  ],
                ),
                Spacer(),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                ),
              ],
            ),
          ),
          verticalSpace(height: 8.h),
          NumberOfInvoicesTextWidget(
            title:
                "${TranslationsController.instance.getTranslations().value} :",
            number: widget.productEntity.totalPrice.toString(),
            hasDot: false,
            titleFontSize: 12.sp,
            numberFontSize: 12.sp,
            numberColor: ColorManager.textColor,
          ),
          verticalSpace(height: 8.h),
          NumberOfInvoicesTextWidget(
            title:
                "${TranslationsController.instance.getTranslations().unitPrice} :",
            number: widget.productEntity.price.toString(),
            hasDot: false,
            titleFontSize: 12.sp,
            numberFontSize: 12.sp,
            numberColor: ColorManager.textColor,
          ),
          verticalSpace(height: 8.h),
          NumberOfInvoicesTextWidget(
            title:
                "${TranslationsController.instance.getTranslations().quantity} :",
            number: widget.productEntity.quantity.toString(),
            hasDot: false,
            numberColor: ColorManager.textColor,
          ),
          if (widget.productEntity.discountType != 0) ...[
            verticalSpace(height: 8.h),
            NumberOfInvoicesTextWidget(
              title: TranslationsController.instance
                  .getTranslations()
                  .discountType,

              number: DisCountType.fromId(
                widget.productEntity.discountType.toString(),
              ).title,
              //     .id,
              hasDot: false,

              numberColor: ColorManager.textColor,
            ),
          ],

          if (widget.productEntity.discountValue != "0") ...[
            verticalSpace(height: 8.h),
            NumberOfInvoicesTextWidget(
              title: TranslationsController.instance.getTranslations().discount,

              number: widget.productEntity.discountValue,
              //     .id,
              hasDot: false,

              numberColor: ColorManager.textColor,
            ),
          ],
          if (widget.productEntity.taxes.isNotEmpty) ...[
            verticalSpace(height: 8.h),
            NumberOfInvoicesTextWidget(
              title:
                  "${TranslationsController.instance.getTranslations().tax} :",

              number: widget.productEntity.taxes[0].taxName,
              //     .id,
              hasDot: false,

              numberColor: ColorManager.textColor,
            ),
          ],
          if (widget.productEntity.taxes.isNotEmpty &&
              widget.productEntity.taxes[0].taxReason != null) ...[
            if (widget.productEntity.taxes[0].taxReason != null &&
                widget.productEntity.taxes[0].taxReason!.arabicText != "") ...[
              verticalSpace(height: 8.h),
              NumberOfInvoicesTextWidget(
                title:
                    "${TranslationsController.instance.getTranslations().taxReason} :",

                number: widget.productEntity.taxes[0].taxReason!.arabicText
                    .toString(),
                //     .id,
                hasDot: false,

                numberColor: ColorManager.textColor,
              ),
            ],
          ],
          // ],
        ],
      ),
    );
  }
}
