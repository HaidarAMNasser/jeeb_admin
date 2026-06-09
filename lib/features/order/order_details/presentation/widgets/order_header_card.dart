import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/routes/route_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_status.dart';

class OrderHeaderCard extends StatelessWidget {
  final OrderEntity order;

  const OrderHeaderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order.statusEnum;
    return Card(
      color: ColorManager.defaultWhite,
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomText(
                    text: '${AppTranslation.order} #${order.id}',
                    textStyle: getBoldStyle(
                      fontSize: AppFontSize.s20,
                      color: ColorManager.productNameColor,
                    ),
                  ),
                ),
                if (order.status != null) ...[
                  SizedBox(width: AppPadding.p8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.p8,
                        vertical: AppPadding.p4,
                      ),
                      decoration: BoxDecoration(
                        color: status.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                      ),
                      child: CustomText(
                        text: status.displayLabel,
                        textStyle: getSemiBoldStyle(
                          fontSize: AppFontSize.s12,
                          color: status.color,
                        ),
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (status == OrderStatus.onTheWay) ...[
              SizedBox(height: AppHeight.s12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    AppRouter.navigateTo(
                      context,
                      Routes.orderStatus,
                      arguments: {
                        'orderId': order.id,
                        'initialStatus': order.status,
                        'deliveryLatitude': order.latitude,
                        'deliveryLongitude': order.longitude,
                      },
                    );
                  },
                  icon: const Icon(Icons.route_rounded, size: 20),
                  label: CustomText(
                    text: AppTranslation.trackOrderLive,
                    textStyle: getSemiBoldStyle(
                      fontSize: AppFontSize.s14,
                      color: ColorManager.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorManager.primary,
                    side: const BorderSide(color: ColorManager.primary),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

