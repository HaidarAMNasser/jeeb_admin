import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/order_item/order_list_item_title_widgets.dart';

/// Compact order row: status + store (one row), customer, then date + total.
class OrderListItemTitle extends StatelessWidget {
  const OrderListItemTitle({
    super.key,
    required this.order,
    this.useAdminPaymentLabels = false,
    this.showAdminPaidMenu = false,
    this.onAdminOpenPaidDetails,
  });

  final OrderEntity order;
  final bool useAdminPaymentLabels;
  final bool showAdminPaidMenu;
  final VoidCallback? onAdminOpenPaidDetails;

  @override
  Widget build(BuildContext context) {
    final restaurant = orderListRestaurantLine(order);
    final customerLine = order.customer != null
        ? order.customer!.displayName.trim()
        : '';
    final customerDisplay = customerLine.isNotEmpty
        ? customerLine
        : AppTranslation.orderListCustomerMissing;
    final totalLine = orderListFormatMoney(
      order.totalAmount,
      order.currencyCode,
    );
    final dateStr = order.date != null
        ? DateFormat('MMM d · HH:mm').format(order.date!)
        : null;

    return Column(
      spacing: AppHeight.s8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: OrderListStatusBadge(
                      status: order.statusEnum,
                      rawStatus: order.status,
                      useAdminPaymentLabels: useAdminPaymentLabels,
                    ),
                  ),
                  if (showAdminPaidMenu && onAdminOpenPaidDetails != null) ...[
                    SizedBox(width: AppWidth.s4),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        size: AppSize.s16,
                        color: ColorManager.textDarkColor,
                      ),
                      onSelected: (_) => onAdminOpenPaidDetails!(),
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'details',
                          child: CustomText(
                            text: 'عرض التفاصيل والتأكيد',
                            textStyle: getMediumStyle(
                              fontSize: AppFontSize.s14,
                              color: ColorManager.textDarkColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: AppWidth.s8),
            OrderListInfoBadge(
              icon: Icons.storefront_outlined,
              text: restaurant,
              backgroundColor: ColorManager.categoryBadgeBackground,
              foregroundColor: ColorManager.categoryTextColor,
            ),
          ],
        ),
        SizedBox(height: AppHeight.s8),
        CustomText(
          text: "${AppTranslation.customer} : $customerDisplay",
          textStyle: getMediumStyle(
            fontSize: AppFontSize.s14,
            color: ColorManager.textDarkColor,
          ),
        ),
        if (dateStr != null || totalLine != null) ...[
          SizedBox(height: AppHeight.s8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (dateStr != null)
                Flexible(
                  child: CustomText(
                    text: dateStr,
                    textStyle: getMediumStyle(
                      fontSize: AppFontSize.s14,
                      color: ColorManager.textDarkColor,
                    ),
                  ),
                ),
              if (dateStr != null && totalLine != null)
                SizedBox(width: AppWidth.s8),
              if (totalLine != null)
                Expanded(
                  child: OrderListInfoBadge(
                    icon: Icons.payments_outlined,
                    text: '${AppTranslation.orderTotalLabel}: $totalLine',
                    backgroundColor: ColorManager.primary.withValues(
                      alpha: 0.08,
                    ),
                    foregroundColor: ColorManager.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
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
