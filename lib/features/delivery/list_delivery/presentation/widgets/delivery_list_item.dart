import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/route_manager.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';

class DeliveryListItem extends StatelessWidget {
  final DeliveryManEntity deliveryMan;

  const DeliveryListItem({super.key, required this.deliveryMan});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppRouter.navigateTo(
          context,
          Routes.deliveryDetails,
          arguments: {'deliveryManId': deliveryMan.id},
        );
      },
      child: Card(
        color: ColorManager.defaultWhite,
        margin: EdgeInsets.only(bottom: AppMargin.m16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DeliveryAvatar(imageUrl: deliveryMan.image),
              SizedBox(width: AppWidth.s12),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 0),
                            child: CustomText(
                              text: deliveryMan.name,
                              textStyle: getBoldStyle(
                                fontSize: AppFontSize.s18,
                                color: ColorManager.productNameColor,
                              ),
                              maxLines: 2,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(width: AppWidth.s8),
                        Flexible(
                          child: _buildBadge(
                            label: deliveryMan.confirmed
                                ? AppTranslation.confirmed
                                : AppTranslation.notConfirmed,
                            backgroundColor: deliveryMan.confirmed
                                ? ColorManager.success.withOpacity(0.12)
                                : ColorManager.defaultYellow.withOpacity(0.18),
                            textColor: deliveryMan.confirmed
                                ? ColorManager.success
                                : ColorManager.defaultYellow,
                          ),
                        ),
                      ],
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

                    if (deliveryMan.phone.isNotEmpty) ...[
                      SizedBox(height: AppHeight.s8),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: AppSize.s16,
                            color: ColorManager.descriptionColor,
                          ),
                          SizedBox(width: AppWidth.s4),
                          Expanded(
                            child: CustomText(
                              text: deliveryMan.phone,
                              textStyle: getRegularStyle(
                                fontSize: AppFontSize.s12,
                                color: ColorManager.descriptionColor,
                              ),
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: AppHeight.s12),
                    if (deliveryMan.isOnline != null)
                      _buildBadge(
                        label: deliveryMan.isOnline == true
                            ? AppTranslation.online
                            : AppTranslation.offline,
                        backgroundColor: deliveryMan.isOnline == true
                            ? ColorManager.primary.withOpacity(0.1)
                            : ColorManager.descriptionColor.withOpacity(0.2),
                        textColor: deliveryMan.isOnline == true
                            ? ColorManager.primary
                            : ColorManager.descriptionColor,
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

  Widget _buildBadge({
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p8,
        vertical: AppPadding.p4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: CustomText(
        text: label,
        textStyle: getSemiBoldStyle(
          fontSize: AppFontSize.s10,
          color: textColor,
        ),
      ),
    );
  }
}

class _DeliveryAvatar extends StatelessWidget {
  final String? imageUrl;

  const _DeliveryAvatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final size = AppWidth.s50;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _placeholder(size),
          ),
        ),
      );
    }
    return _placeholder(size);
  }

  Widget _placeholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ColorManager.background,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.delivery_dining,
        color: ColorManager.primary,
        size: AppSize.s28,
      ),
    );
  }
}
