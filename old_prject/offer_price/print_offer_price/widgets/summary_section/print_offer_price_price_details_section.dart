import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/feature/print_invoice_screen/widget/raw_value_icon_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';

class PrintOfferPricePriceDetailsSection extends StatelessWidget {
  final OfferPriceSingleEntity data;
  const PrintOfferPricePriceDetailsSection({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RowValueIcon(
          title:
              TranslationsController.instance.getTranslations().totalBeforeTax,
          value: data.offerPriceDetails
              .fold<double>(
                  0.0,
                  (previousValue, element) =>
                      previousValue +
                      double.parse(element.price) *
                          double.parse(element.quantity))
              .toStringAsFixed(2),
        ),
        verticalSpace(height: AppHeight.s3),
        RowValueIcon(
          title: TranslationsController.instance.getTranslations().discount,
          value:
              "${num.parse(data.discountPrice.toString()).toStringAsFixed(2)}",
        ),
        verticalSpace(height: AppHeight.s3),
        RowValueIcon(
          title:
              TranslationsController.instance.getTranslations().valueAddedTax,
          value: "${num.parse(data.taxPrice.toString()).toStringAsFixed(2)}",
        ),
        verticalSpace(height: AppHeight.s3),
        RowValueIcon(
          title: TranslationsController.instance.getTranslations().totalWithTax,
          value: "${num.parse(data.netPrice).toStringAsFixed(2)}",
        ),
      ],
    );
  }
}
