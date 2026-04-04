import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart' as di;
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/routes/route_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/auth/login/domain/entities/user_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';

/// Store / merchant summary for an order when the API provides a name or id.
class OrderRestaurantCard extends StatelessWidget {
  const OrderRestaurantCard({super.key, required this.order});

  final OrderEntity order;

  static bool shouldShow(OrderEntity order) {
    final n = order.restaurantName?.trim();
    if (n != null && n.isNotEmpty) return true;
    final m = order.merchantId?.trim();
    return m != null && m.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final name = order.restaurantName?.trim();
    final hasName = name != null && name.isNotEmpty;
    final hasMerchantId =
        order.merchantId != null && order.merchantId!.trim().isNotEmpty;
    if (!hasName && !hasMerchantId) return const SizedBox.shrink();

    final merchantId = order.merchantId?.trim() ?? '';

    return FutureBuilder<String?>(
      future: di.sl<StorageService>().getUserRole(),
      builder: (context, snapshot) {
        final role = snapshot.data?.toLowerCase();
        final isAdmin = role == UserRole.admin.name;
        final openMerchantDetails = isAdmin && merchantId.isNotEmpty;

        final padding = Padding(
          padding: EdgeInsets.all(AppPadding.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.storefront_rounded,
                    color: ColorManager.primary,
                    size: AppSize.s20,
                  ),
                  SizedBox(width: AppWidth.s12),
                  Expanded(
                    child: CustomText(
                      text: AppTranslation.orderRestaurantSection,
                      textStyle: getBoldStyle(
                        fontSize: AppFontSize.s16,
                        color: ColorManager.productNameColor,
                      ),
                    ),
                  ),
                  if (openMerchantDetails)
                    Icon(
                      Icons.chevron_right_rounded,
                      color: ColorManager.descriptionColor,
                      size: AppSize.s24,
                    ),
                ],
              ),
              SizedBox(height: AppHeight.s12),
              if (hasName) _row(AppTranslation.restaurantName, name),
              if (hasMerchantId) ...[
                if (hasName) SizedBox(height: AppHeight.s8),
                _row(
                  AppTranslation.orderMerchantIdLabel,
                  merchantId,
                ),
              ],
            ],
          ),
        );

        return Card(
          color: ColorManager.defaultWhite,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r16),
          ),
          child: openMerchantDetails
              ? InkWell(
                  onTap: () {
                    AppRouter.navigateTo(
                      context,
                      Routes.merchantDetails,
                      arguments: {'merchantId': merchantId},
                    );
                  },
                  child: padding,
                )
              : padding,
        );
      },
    );
  }

  Widget _row(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: CustomText(
            text: '$label:',
            textStyle: getSemiBoldStyle(
              fontSize: AppFontSize.s14,
              color: ColorManager.descriptionColor,
            ),
          ),
        ),
        Expanded(
          child: CustomText(
            text: value,
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s14,
              color: ColorManager.productNameColor,
            ),
            maxLines: 3,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
