import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

class MerchantStatisticsStatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const MerchantStatisticsStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.p12),
      decoration: BoxDecoration(
        color: ColorManager.background,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ColorManager.primary, size: AppSize.s20),
          SizedBox(height: AppHeight.s8),
          CustomText(
            text: value,
            textStyle: getBoldStyle(
              fontSize: AppFontSize.s18,
              color: ColorManager.defaultWhite,
            ),
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppHeight.s4),
          CustomText(
            text: label,
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s11,
              color: ColorManager.textColor,
            ),
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
