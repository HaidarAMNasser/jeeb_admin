import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';

class DeliveryDetailsContent extends StatelessWidget {
  final DeliveryManEntity deliveryMan;

  const DeliveryDetailsContent({
    super.key,
    required this.deliveryMan,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppPadding.p16),
      child: Card(
        color: ColorManager.defaultWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _DeliveryAvatar(imageUrl: deliveryMan.image),
                  SizedBox(width: AppWidth.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: deliveryMan.name,
                          textStyle: getBoldStyle(
                            fontSize: AppFontSize.s20,
                            color: ColorManager.productNameColor,
                          ),
                        ),
                        SizedBox(height: AppHeight.s4),
                        CustomText(
                          text: deliveryMan.email,
                          textStyle: getRegularStyle(
                            fontSize: AppFontSize.s14,
                            color: ColorManager.descriptionColor,
                          ),
                        ),
                        SizedBox(height: AppHeight.s8),
                        Wrap(
                          spacing: AppWidth.s8,
                          runSpacing: AppHeight.s8,
                          children: [
                            _buildBadge(
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
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppHeight.s24),
              if (deliveryMan.phone.isNotEmpty)
                _buildInfoRow(Icons.phone, AppTranslation.phone, deliveryMan.phone),
              if (deliveryMan.cityName != null &&
                  deliveryMan.cityName!.isNotEmpty) ...[
                SizedBox(height: AppHeight.s12),
                _buildInfoRow(Icons.location_city, 'City', deliveryMan.cityName!),
              ],
              if (deliveryMan.countryName != null &&
                  deliveryMan.countryName!.isNotEmpty) ...[
                SizedBox(height: AppHeight.s12),
                _buildInfoRow(Icons.public, 'Country', deliveryMan.countryName!),
              ],
              if (deliveryMan.isOnline != null) ...[
                SizedBox(height: AppHeight.s12),
                _buildInfoRow(
                  Icons.circle,
                  AppTranslation.status,
                  deliveryMan.isOnline == true
                      ? AppTranslation.online
                      : AppTranslation.offline,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppSize.s20,
          color: ColorManager.descriptionColor,
        ),
        SizedBox(width: AppWidth.s8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                textStyle: getSemiBoldStyle(
                  fontSize: AppFontSize.s12,
                  color: ColorManager.descriptionColor,
                ),
              ),
              SizedBox(height: AppHeight.s4),
              CustomText(
                text: value,
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.productNameColor,
                ),
              ),
            ],
          ),
        ),
      ],
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
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: AppWidth.s100,
          height: AppHeight.s100,
          child: Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _placeholder(),
          ),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: AppWidth.s100,
      height: AppHeight.s100,
      decoration: BoxDecoration(
        color: ColorManager.background,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.delivery_dining,
        color: ColorManager.primary,
        size: AppSize.s40,
      ),
    );
  }
}
