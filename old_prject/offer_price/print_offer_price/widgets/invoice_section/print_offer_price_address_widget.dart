import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/font_manager.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/helpful_funcations/build_my_info_address.dart';
import 'package:fatoorahapp/feature/authentication/profile/domain/entities/profile_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';

class PrintOfferPriceAddressWidget extends StatelessWidget {
  final OfferPriceSingleEntity data;
  final ProfileEntity? myInfo;
  const PrintOfferPriceAddressWidget({
    super.key,
    required this.data,
    this.myInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpace(height: AppHeight.s4),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (data.workplaceEntity.countryEntity.name != "" ||
                data.workplaceEntity.regionEntity.name != "" ||
                data.workplaceEntity.cityEntity.name != "" ||
                data.workplaceEntity.area != "")
              CustomText(
                text: [
                  data.workplaceEntity.countryEntity.name,
                  data.workplaceEntity.regionEntity.name,
                  data.workplaceEntity.cityEntity.name,
                  data.workplaceEntity.area,
                ].where((element) => element.trim().isNotEmpty).join(" - "),
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s10,
                  color: ColorManager.spaceColor,
                ),
              ),
            if (data.workplaceEntity.buildingNumber != "" ||
                data.workplaceEntity.streetName != "" ||
                data.workplaceEntity.postalNumber != "")
              CustomText(
                text: [
                  data.workplaceEntity.buildingNumber,
                  data.workplaceEntity.streetName,
                  data.workplaceEntity.postalNumber,
                ].where((element) => element.trim().isNotEmpty).join(" - "),
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s10,
                  color: ColorManager.spaceColor,
                ),
              ),
          ],
        ),
        buildMyInfoAddress(
          myInfo,
          data.workplaceEntity.countryEntity.name,
          data.workplaceEntity.regionEntity.name,
          data.workplaceEntity.cityEntity.name,
          data.workplaceEntity.area,
          data.workplaceEntity.buildingNumber,
          data.workplaceEntity.streetName,
        ),
      ],
    );
  }
}
