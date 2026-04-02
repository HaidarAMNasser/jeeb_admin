import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_status.dart';

String orderListRestaurantLine(OrderEntity order) {
  final n = order.restaurantName?.trim();
  if (n != null && n.isNotEmpty) return n;
  return AppTranslation.orderRestaurantPlaceholder;
}

String? orderListFormatMoney(int? amount, String? currencyCode) {
  if (amount == null) return null;
  final c = currencyCode ?? '';
  return c.isNotEmpty ? '$amount $c' : amount.toString();
}

String orderListStatusLabel(OrderStatus status, String? rawStatus) {
  if (status != OrderStatus.unknown) return status.displayLabel;
  final raw = rawStatus?.trim();
  if (raw != null && raw.isNotEmpty) {
    return raw
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map(
          (w) => w.length == 1
              ? w.toUpperCase()
              : '${w[0].toUpperCase()}${w.substring(1)}',
        )
        .join(' ');
  }
  return status.displayLabel;
}

class OrderListStatusBadge extends StatelessWidget {
  const OrderListStatusBadge({
    super.key,
    required this.status,
    this.rawStatus,
  });

  final OrderStatus status;
  final String? rawStatus;

  @override
  Widget build(BuildContext context) {
    final label = orderListStatusLabel(status, rawStatus);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p10,
        vertical: AppPadding.p6,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.r8),
        border: Border.all(color: status.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.iconData, size: AppSize.s16, color: status.color),
          SizedBox(width: AppWidth.s8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: CustomText(
              text: label,
              textStyle: getBoldStyle(
                fontSize: AppFontSize.s11,
                color: status.color,
              ),
              maxLines: 2,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderListInfoBadge extends StatelessWidget {
  const OrderListInfoBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    this.icon,
    this.maxLines = 2,
    this.fontWeight,
  });

  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData? icon;
  final int maxLines;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.s100,
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p10,
        vertical: AppPadding.p8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppSize.s16, color: foregroundColor),
            SizedBox(width: AppWidth.s8),
          ],
          Expanded(
            child: CustomText(
              text: text,
              textStyle: (fontWeight != null ? getBoldStyle : getMediumStyle)(
                fontSize: AppFontSize.s12,
                color: foregroundColor,
              ).copyWith(fontWeight: fontWeight),
              maxLines: maxLines,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
