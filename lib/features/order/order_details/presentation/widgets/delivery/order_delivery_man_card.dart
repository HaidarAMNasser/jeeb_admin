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
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';

class OrderDeliveryManCard extends StatelessWidget {
  final DeliveryManEntity deliveryMan;

  const OrderDeliveryManCard({super.key, required this.deliveryMan});

  @override
  Widget build(BuildContext context) {
    final deliveryManId = deliveryMan.id.trim();

    return FutureBuilder<String?>(
      future: di.sl<StorageService>().getUserRole(),
      builder: (context, snapshot) {
        final role = snapshot.data?.toLowerCase();
        final isAdmin = role == UserRole.admin.name;
        final openDeliveryDetails = isAdmin && deliveryManId.isNotEmpty;

        final padding = Padding(
          padding: EdgeInsets.all(AppPadding.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.delivery_dining_rounded,
                    color: ColorManager.primary,
                    size: AppSize.s20,
                  ),
                  SizedBox(width: AppWidth.s12),
                  Expanded(
                    child: CustomText(
                      text: AppTranslation.deliveryMan,
                      textStyle: getBoldStyle(
                        fontSize: AppFontSize.s16,
                        color: ColorManager.productNameColor,
                      ),
                    ),
                  ),
                  if (openDeliveryDetails)
                    Icon(
                      Icons.chevron_right_rounded,
                      color: ColorManager.descriptionColor,
                      size: AppSize.s24,
                    ),
                ],
              ),
              SizedBox(height: AppHeight.s12),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: ColorManager.primary,
                    size: AppSize.s20,
                  ),
                  SizedBox(width: AppWidth.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: deliveryMan.name,
                          textStyle: getBoldStyle(
                            fontSize: AppFontSize.s14,
                            color: ColorManager.productNameColor,
                          ),
                        ),
                        SizedBox(height: AppHeight.s4),
                        CustomText(
                          text: deliveryMan.email,
                          textStyle: getRegularStyle(
                            fontSize: AppFontSize.s12,
                            color: ColorManager.descriptionColor,
                          ),
                        ),
                        if (deliveryMan.phone.isNotEmpty) ...[
                          SizedBox(height: AppHeight.s4),
                          CustomText(
                            text: deliveryMan.phone,
                            textStyle: getRegularStyle(
                              fontSize: AppFontSize.s12,
                              color: ColorManager.descriptionColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

        return Card(
          color: ColorManager.defaultWhite,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r16),
          ),
          child: openDeliveryDetails
              ? InkWell(
                  onTap: () {
                    AppRouter.navigateTo(
                      context,
                      Routes.deliveryDetails,
                      arguments: {'deliveryManId': deliveryManId},
                    );
                  },
                  child: padding,
                )
              : padding,
        );
      },
    );
  }
}
