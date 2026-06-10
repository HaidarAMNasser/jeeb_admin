import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

class MerchantStatisticsTypeBadge extends StatelessWidget {
  final String type;

  const MerchantStatisticsTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final label = type == 'STORE'
        ? AppTranslation.merchantTypeMarket
        : AppTranslation.merchantTypeRestaurant;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p8,
        vertical: AppPadding.p4,
      ),
      decoration: BoxDecoration(
        color: ColorManager.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: CustomText(
        text: label,
        textStyle: getSemiBoldStyle(
          fontSize: AppFontSize.s12,
          color: ColorManager.primary,
        ),
      ),
    );
  }
}
