import 'package:fatoorahapp/core/constances/assets_manager.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/font_manager.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrintOfferPricePaymentSection extends StatelessWidget {
  final OfferPriceSingleEntity data;
  const PrintOfferPricePaymentSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String _formatPaymentLabel(
      String methodName, {
      String? date,
      String? guaranteePercent,
    }) {
      final details = <String>[];
      final trimmedDate = date?.trim();
      if (trimmedDate != null && trimmedDate.isNotEmpty) {
        details.add('($trimmedDate)');
      }
      final trimmedPercent = guaranteePercent?.trim();
      if (trimmedPercent != null && trimmedPercent.isNotEmpty) {
        details.add('(النسبة: $trimmedPercent%)');
      }
      if (details.isEmpty) {
        return methodName;
      }
      return '$methodName ${details.join(' ')}';
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsetsDirectional.zero,
      itemBuilder: (context, index) {
        final payment = data.payments[index];
        return Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: AppPadding.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: _formatPaymentLabel(
                        payment.method.name,
                        date: payment.date,
                        guaranteePercent: payment.method.id == 8
                            ? payment.guaranteePercent
                            : null,
                      ),
                      textStyle: getBoldStyle(fontSize: AppFontSize.s10),
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: payment.value.toString(),
                          textStyle: getBoldStyle(fontSize: AppFontSize.s10),
                        ),
                        SizedBox(width: 3.w),
                        Padding(
                          padding: EdgeInsets.only(right: 2.5.w),
                          child: SvgPicture.asset(
                            color: ColorManager.invoiceQrDescription,
                            IconAssets.newRiyalh,
                            height: 12.h,
                            width: 15.h,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return verticalSpace(height: AppHeight.s2_5);
      },
      itemCount: data.payments.length,
    );
  }
}
