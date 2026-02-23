import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/feature/sales_invoice_detail/widgets/custom_row_colomn.dart';
import 'package:fatoorahapp/widgets/divider_widget.dart';
import 'package:flutter/material.dart';

class PrintOfferPriceProductsSection extends StatelessWidget {
  final OfferPriceSingleEntity offerPriceEntity;
  const PrintOfferPriceProductsSection({
    super.key,
    required this.offerPriceEntity,
  });

  @override
  Widget build(BuildContext context) {
    List<OfferPriceDetailEntity> products = offerPriceEntity.offerPriceDetails;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.labelColor),
        borderRadius: BorderRadius.circular(AppRadius.r2),
      ),
      padding: EdgeInsetsDirectional.symmetric(vertical: AppPadding.p4),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: AppPadding.p8),
            child: Row(
              children: [
                ColumnNameWidget(
                  name: TranslationsController.instance
                      .getTranslations()
                      .products,
                  flex: 2,
                  index: 0,
                ),
                ColumnNameWidget(
                  name: TranslationsController.instance
                      .getTranslations()
                      .quantity,
                  index: 1,
                ),
                ColumnNameWidget(
                  name: TranslationsController.instance
                      .getTranslations()
                      .priceOne,
                  index: 2,
                ),
                ColumnNameWidget(
                  name: TranslationsController.instance.getTranslations().total,
                  index: 2,
                ),
                ColumnNameWidget(
                  name: TranslationsController.instance
                      .getTranslations()
                      .discount,
                  index: 3,
                ),
                ColumnNameWidget(
                  name: TranslationsController.instance
                      .getTranslations()
                      .taxValue,
                  index: 4,
                ),
                ColumnNameWidget(
                  name: TranslationsController.instance
                      .getTranslations()
                      .priceWithTax,
                  index: 5,
                ),
              ],
            ),
          ),
          CustomDivider(color: ColorManager.labelColor, height: AppHeight.s10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.zero,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: AppPadding.p8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RowDataWidget(
                      value: products[index].product.name,
                      flex: 2,
                      index: 0,
                    ),
                    RowDataWidget(value: products[index].quantity, index: 1),
                    RowDataWidget(
                      value: _safeParseDouble(products[index].price.toString()),
                      index: 2,
                    ),
                    RowDataWidget(
                      value:
                          (double.parse(products[index].price.toString()) *
                                  double.parse(
                                    products[index].quantity.toString(),
                                  ))
                              .toStringAsFixed(2),
                      index: 3,
                    ),
                    RowDataWidget(
                      value: _safeParseDiscountPrice(
                        offerPriceEntity.offerPriceDetails[index].discountPrice,
                      ),
                      index: 4,
                    ),
                    RowDataWidget(
                      value: products[index].taxes.isNotEmpty
                          ? _safeParseDouble(
                              products[index].taxes[0].amount.toString(),
                            )
                          : "0.00",
                      index: 5,
                    ),
                    RowDataWidget(
                      value: _safeParseDouble(
                        products[index].totalPrice.toString(),
                      ),
                      index: 6,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return CustomDivider(
                color: ColorManager.labelColor,
                height: AppHeight.s10,
              );
            },
            itemCount: products.length,
          ),
        ],
      ),
    );
  }

  String _safeParseDouble(String value) {
    if (value.isEmpty || value == 'null') {
      print('Empty or null value detected: "$value"');
      return "0.00";
    }

    try {
      final parsed = double.parse(value);
      return parsed.toStringAsFixed(2);
    } catch (e) {
      print('Failed to parse double: "$value", error: $e');
      return "0.00";
    }
  }



  String _safeParseDiscountPrice(String? discountPrice) {
    print(
      'Parsing discount price: "$discountPrice" (type: ${discountPrice.runtimeType})',
    );

    if (discountPrice == null) {
      print('Discount price is null');
      return "0.00";
    }

    if (discountPrice.isEmpty || discountPrice == 'null') {
      print('Discount price is empty or "null" string');
      return "0.00";
    }

    try {
      final parsed = double.parse(discountPrice);
      print('Successfully parsed discount price: $parsed');
      return parsed.toStringAsFixed(2);
    } catch (e) {
      print('Failed to parse discount price: "$discountPrice", error: $e');
      return "0.00";
    }
  }
}
