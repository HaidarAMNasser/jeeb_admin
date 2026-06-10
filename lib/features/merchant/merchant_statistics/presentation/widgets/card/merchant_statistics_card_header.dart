import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/domain/entities/merchant_statistics_entity.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/presentation/widgets/card/merchant_statistics_type_badge.dart';

class MerchantStatisticsCardHeader extends StatelessWidget {
  final MerchantStatisticsEntity item;

  const MerchantStatisticsCardHeader({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppWidth.s50,
          height: AppHeight.s50,
          decoration: BoxDecoration(
            color: ColorManager.background,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.store,
            color: ColorManager.primary,
            size: AppSize.s28,
          ),
        ),
        SizedBox(width: AppWidth.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: item.name?.isNotEmpty == true
                    ? item.name!
                    : AppTranslation.notSpecified,
                textStyle: getBoldStyle(
                  fontSize: AppFontSize.s18,
                  color: ColorManager.productNameColor,
                ),
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppHeight.s4),
              CustomText(
                text: '${AppTranslation.merchantUserId}: ${item.userId}',
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s12,
                  color: ColorManager.descriptionColor,
                ),
              ),
            ],
          ),
        ),
        MerchantStatisticsTypeBadge(type: item.type),
      ],
    );
  }
}
