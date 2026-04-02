import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/order_item/order_list_item_headers.dart';

/// Main column inside the tappable area (header, meta, products, total).
class OrderListItemTitle extends StatelessWidget {
  const OrderListItemTitle({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final totalLine = formatOrderMoneyAmount(
      order.totalAmount,
      order.currencyCode,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrderListItemHeader(order: order),
        if (order.date != null)
          OrderListItemMetaRow(
            icon: Icons.calendar_today,
            text: formatOrderDate(order.date!),
          ),
        if (order.products.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: AppHeight.s8),
            child: CustomText(
              text: order.products.map((p) => p.name).join(', '),
              textStyle: getMediumStyle(
                fontSize: AppFontSize.s12,
                color: ColorManager.descriptionColor,
              ),
            ),
          ),
        SizedBox(height: AppHeight.s4),
        CustomText(
          text: '${AppTranslation.order} #${order.id}',
          textStyle: getRegularStyle(
            fontSize: AppFontSize.s12,
            color: ColorManager.productNameColor,
          ),
          maxLines: 2,
          textOverflow: TextOverflow.ellipsis,
        ),
        if (totalLine != null) ...[
          SizedBox(height: AppHeight.s8),
          CustomText(
            text: '${AppTranslation.orderTotalLabel}: $totalLine',
            textStyle: getSemiBoldStyle(
              fontSize: AppFontSize.s14,
              color: ColorManager.primary,
            ),
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
          if (order.numberOfPeople != null)
            OrderListItemMetaRow(
              icon: Icons.people,
              text: '${order.numberOfPeople} ${AppTranslation.people}',
              topPadding: AppHeight.s8,
            ),
        ],
      ],
    );
  }
}

/// Outlined row action (confirm / kitchen) at the bottom of the card.
class OrderListItemMerchantAction extends StatelessWidget {
  const OrderListItemMerchantAction({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppPadding.p16,
        0,
        AppPadding.p16,
        AppPadding.p16,
      ),
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ColorManager.primary,
                ),
              )
            : CustomText(
                text: label,
                textStyle: getSemiBoldStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.primary,
                ),
              ),
      ),
    );
  }
}
