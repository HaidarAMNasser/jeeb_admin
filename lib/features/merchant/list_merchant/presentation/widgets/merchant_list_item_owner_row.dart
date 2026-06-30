import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';

class MerchantListItemOwnerRow extends StatelessWidget {
  final String ownerName;

  const MerchantListItemOwnerRow({super.key, required this.ownerName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CustomText(
            text: "${AppTranslation.owner}: ",
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s12,
              color: ColorManager.descriptionColor,
            ),
          ),
          SizedBox(height: AppHeight.s4),
          CustomText(
            text: ownerName,
            textStyle: getRegularStyle(color: ColorManager.backgroundDark),
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
