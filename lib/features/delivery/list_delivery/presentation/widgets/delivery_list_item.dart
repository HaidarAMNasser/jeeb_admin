import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/route_manager.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/presentation/widgets/delivery_list_item_avatar.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/presentation/widgets/delivery_list_item_status_row.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/merchant_list_item_phone_badge.dart';

class DeliveryListItem extends StatelessWidget {
  final DeliveryManEntity deliveryMan;

  const DeliveryListItem({super.key, required this.deliveryMan});

  @override
  Widget build(BuildContext context) {
    final hasPhone = deliveryMan.phone.trim().isNotEmpty;
    final isConfirmed =
        deliveryMan.isActive == true || deliveryMan.confirmed;

    void goToDetails() {
      AppRouter.navigateTo(
        context,
        Routes.deliveryDetails,
        arguments: {'deliveryManId': deliveryMan.id},
      );
    }

    return Card(
      color: ColorManager.defaultWhite,
      margin: EdgeInsets.only(bottom: AppMargin.m16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: goToDetails,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DeliveryListItemAvatar(imageUrl: deliveryMan.image),
              SizedBox(width: AppWidth.s12),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: MerchantListItemPhoneBadge.reserveEndPadding(
                            hasPhone,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: deliveryMan.name,
                              textStyle: getBoldStyle(
                                fontSize: AppFontSize.s18,
                                color: ColorManager.productNameColor,
                              ),
                              maxLines: 2,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: AppHeight.s10),
                            CustomText(
                              text: deliveryMan.email,
                              textStyle: getRegularStyle(
                                fontSize: AppFontSize.s12,
                                color: ColorManager.descriptionColor,
                              ),
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: AppHeight.s12),
                            DeliveryListItemStatusRow(
                              isOnline: deliveryMan.isOnline,
                              isConfirmed: isConfirmed,
                            ),
                          ],
                        ),
                      ),
                      if (hasPhone)
                        PositionedDirectional(
                          top: 0,
                          end: 0,
                          child: MerchantListItemPhoneBadge(
                            phoneNumber: deliveryMan.phone.trim(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
