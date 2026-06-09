import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

/// Shows [deliveryCoordinates]-style fields when present, plus lat/lng.
class OrderLocationCard extends StatelessWidget {
  final String? address;
  final String? landmark;
  final String? specialInstructions;
  final double? latitude;
  final double? longitude;

  const OrderLocationCard({
    super.key,
    this.address,
    this.landmark,
    this.specialInstructions,
    this.latitude,
    this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorManager.defaultWhite,
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: ColorManager.primary,
                  size: AppSize.s20,
                ),
                SizedBox(width: AppWidth.s12),
                CustomText(
                  text: AppTranslation.location,
                  textStyle: getBoldStyle(
                    fontSize: AppFontSize.s16,
                    color: ColorManager.productNameColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppHeight.s8),
            if (address != null && address!.trim().isNotEmpty) ...[
              _line(AppTranslation.address, address!.trim()),
              SizedBox(height: AppHeight.s4),
            ],
            if (landmark != null && landmark!.trim().isNotEmpty) ...[
              _line(AppTranslation.landmark, landmark!.trim()),
              SizedBox(height: AppHeight.s4),
            ],
            if (specialInstructions != null &&
                specialInstructions!.trim().isNotEmpty) ...[
              _line(
                AppTranslation.specialInstructions,
                specialInstructions!.trim(),
              ),
              SizedBox(height: AppHeight.s4),
            ],
            if (latitude != null) ...[
              CustomText(
                text: '${AppTranslation.latitude}: $latitude',
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.descriptionColor,
                ),
              ),
              SizedBox(height: AppHeight.s4),
            ],
            if (longitude != null)
              CustomText(
                text: '${AppTranslation.longitude}: $longitude',
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.descriptionColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _line(String label, String value) {
    return CustomText(
      text: '$label: $value',
      textStyle: getRegularStyle(
        fontSize: AppFontSize.s14,
        color: ColorManager.descriptionColor,
      ),
    );
  }
}
