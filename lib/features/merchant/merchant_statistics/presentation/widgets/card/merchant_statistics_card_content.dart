import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/icon_value_row.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/domain/entities/merchant_statistics_entity.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/presentation/widgets/card/merchant_statistics_card_header.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/presentation/widgets/card/merchant_statistics_stat_tile.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/merchant_list_item_location_section.dart';

class MerchantStatisticsCardContent extends StatelessWidget {
  final MerchantStatisticsEntity item;

  const MerchantStatisticsCardContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;
    final country = item.location.country?.name.displayName(languageCode);
    final city = item.location.city?.name.displayName(languageCode);
    final hasLocation =
        (country != null && country.isNotEmpty) ||
        (city != null && city.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MerchantStatisticsCardHeader(item: item),
        SizedBox(height: AppHeight.s16),
        Row(
          children: [
            Expanded(
              child: MerchantStatisticsStatTile(
                label: AppTranslation.totalOrders,
                value: item.stats.totalOrders.toString(),
                icon: Icons.receipt_long,
              ),
            ),
            SizedBox(width: AppWidth.s12),
            Expanded(
              child: MerchantStatisticsStatTile(
                label: AppTranslation.totalRevenue,
                value: item.stats.totalRevenueDisplay.toStringAsFixed(2),
                icon: Icons.payments_outlined,
              ),
            ),
          ],
        ),
        if (hasLocation)
          MerchantListItemLocationSection(
            cityName: city,
            countryName: country,
            address: null,
          )
        else ...[
          SizedBox(height: AppHeight.s12),
          IconValueRow(
            icon: Icons.location_city_outlined,
            value: AppTranslation.notSpecified,
            iconSize: AppSize.s18,
            iconColor: ColorManager.primary,
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
            valueStyle: getRegularStyle(
              fontSize: AppFontSize.s13,
              color: ColorManager.productNameColor,
            ),
          ),
        ],
      ],
    );
  }
}
