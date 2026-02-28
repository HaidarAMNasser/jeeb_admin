import 'package:flutter/material.dart';
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
                  Container(
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
                  ),
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
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppHeight.s24),
              if (deliveryMan.phone.isNotEmpty)
                _buildInfoRow(Icons.phone, 'Phone', deliveryMan.phone),
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
                  'Status',
                  deliveryMan.isOnline == true ? 'Online' : 'Offline',
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
}
