import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_item_entity.dart';

class OrderItemsSection extends StatelessWidget {
  final List<OrderItemEntity> items;
  final String? currencyCode;

  const OrderItemsSection({
    super.key,
    required this.items,
    this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final currency = currencyCode ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: '${AppTranslation.products} (${items.length})',
          textStyle: getBoldStyle(
            fontSize: AppFontSize.s18,
            color: ColorManager.defaultWhite,
          ),
        ),
        SizedBox(height: AppHeight.s12),
        ...items.map((item) => Card(
              color: ColorManager.defaultWhite,
              child: Padding(
                padding: EdgeInsets.all(AppPadding.p16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: item.productName,
                            textStyle: getSemiBoldStyle(
                              fontSize: AppFontSize.s14,
                              color: ColorManager.productNameColor,
                            ),
                          ),
                          SizedBox(height: AppHeight.s4),
                          CustomText(
                            text: 'Qty: ${item.quantity} × ${item.unitPrice}${currency.isNotEmpty ? ' $currency' : ''}',
                            textStyle: getRegularStyle(
                              fontSize: AppFontSize.s12,
                              color: ColorManager.descriptionColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomText(
                      text: '${item.totalPrice}${currency.isNotEmpty ? ' $currency' : ''}',
                      textStyle: getBoldStyle(
                        fontSize: AppFontSize.s14,
                        color: ColorManager.primary,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
