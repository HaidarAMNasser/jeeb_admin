import 'package:fatoorahapp/core/constances/assets_manager.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/core/routing/navigation_extensions.dart';
import 'package:fatoorahapp/core/routing/routes.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/widgets/divider_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../widgets/more_options_widget.dart';
import '../../../../../widgets/single_more_item_widget.dart';

class OfferPriceTitleWidget extends StatelessWidget {
  final String title;
  final String id;
  final bool showOptions;
  final bool fromExchange;
  final OfferPriceDataEntity offerPriceDataEntity;
  const OfferPriceTitleWidget(
      {super.key,
      required this.title,
      required this.id,
      required this.fromExchange,
      required this.offerPriceDataEntity,
      required this.showOptions});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(
          text: title,
          textStyle: getBoldStyle(fontSize: 12.sp),
        ),
        horizontalSpace(width: 8.w),
        CustomText(
          text: id,
          textStyle: getRegularStyle(fontSize: 12.sp),
        ),
        if (showOptions) ...[
          Spacer(),
          moreOptionsWidget(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleMoreItemWidget(
                  context: context,
                  title:
                      TranslationsController.instance.getTranslations().preview,
                  icon: IconAssets.eye,
                  onTap: () {
                    Navigator.pop(context);
                    context.pushNamed(Routes.receiptDetailsScreen, arguments: {
                      'fromExchange': this.fromExchange,
                      'offerPriceDataEntity': this.offerPriceDataEntity,
                    });
                  },
                ),
                const CustomDivider(),
                SingleMoreItemWidget(
                  context: context,
                  title:
                      TranslationsController.instance.getTranslations().print,
                  icon: IconAssets.printer,
                  onTap: () {
                    Navigator.pop(context);
                    context.pushNamed(Routes.receiptPrintScreen, arguments: {
                      "offerPriceDataEntity": this.offerPriceDataEntity,
                      "fromExchange": this.fromExchange
                    });
                  },
                ),
              ],
            ),
            context: context,
            onPreviewTap: () {
               Navigator.of(context).pop();
              context.pushNamed(Routes.receiptDetailsScreen, arguments: {
                'fromExchange': this.fromExchange,
                'offerPriceDataEntity': this.offerPriceDataEntity,
              });
            },
          ),
        ],
      ],
    );
  }
}
