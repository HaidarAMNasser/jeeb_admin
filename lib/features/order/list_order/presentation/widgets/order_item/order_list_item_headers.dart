import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_status.dart';
import 'package:intl/intl.dart';

String? formatOrderMoneyAmount(int? amount, String? currencyCode) {
  if (amount == null) return null;
  final c = currencyCode ?? '';
  return c.isNotEmpty ? '$amount $c' : amount.toString();
}

class OrderListItemHeader extends StatelessWidget {
  const OrderListItemHeader({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final restaurantLine = () {
      final n = order.restaurantName?.trim();
      if (n != null && n.isNotEmpty) return n;
      return AppTranslation.orderRestaurantPlaceholder;
    }();
    final customerLine = order.customer?.displayName.trim();
    final showCustomer = customerLine != null && customerLine.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppWidth.s50,
                height: AppHeight.s50,
                decoration: const BoxDecoration(
                  color: ColorManager.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  color: ColorManager.primary,
                  size: AppSize.s28,
                ),
              ),
              SizedBox(width: AppWidth.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: restaurantLine,
                      textStyle: getBoldStyle(
                        fontSize: AppFontSize.s18,
                        color: ColorManager.productNameColor,
                      ),
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    if (showCustomer) ...[
                      SizedBox(height: AppHeight.s4),
                      CustomText(
                        text: customerLine,
                        textStyle: getRegularStyle(
                          fontSize: AppFontSize.s14,
                          color: ColorManager.descriptionColor,
                        ),
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (order.status != null) ...[
          SizedBox(width: AppWidth.s8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: _StatusChip(status: order.statusEnum),
          ),
        ],
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p8,
        vertical: AppPadding.p4,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: CustomText(
        text: status.displayLabel,
        textStyle: getSemiBoldStyle(
          fontSize: AppFontSize.s10,
          color: status.color,
        ),
        maxLines: 1,
        textOverflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class OrderListItemMetaRow extends StatelessWidget {
  const OrderListItemMetaRow({
    super.key,
    required this.icon,
    required this.text,
    this.topPadding = 12,
  });

  final IconData icon;
  final String text;

  /// Logical top spacing (pixels).
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        children: [
          Icon(icon, size: AppSize.s16, color: ColorManager.descriptionColor),
          SizedBox(width: AppWidth.s4),
          Expanded(
            child: CustomText(
              text: text,
              textStyle: getRegularStyle(
                fontSize: AppFontSize.s12,
                color: ColorManager.descriptionColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String formatOrderDate(DateTime date) =>
    DateFormat('MMM dd, yyyy - HH:mm').format(date);
