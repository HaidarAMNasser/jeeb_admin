import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/domain/entities/merchant_statistics_entity.dart';

class MerchantStatisticsCard extends StatelessWidget {
  final MerchantStatisticsEntity item;

  const MerchantStatisticsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;
    final country = item.location.country?.name.displayName(languageCode);
    final city = item.location.city?.name.displayName(languageCode);
    final locationParts = [
      if (country != null && country.isNotEmpty) country,
      if (city != null && city.isNotEmpty) city,
    ];
    final coordinates = item.location.coordinates;
    final locationText = locationParts.isEmpty
        ? AppTranslation.notSpecified
        : locationParts.join(', ');

    return Card(
      color: ColorManager.defaultWhite,
      margin: EdgeInsets.only(bottom: AppMargin.m16),
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
                _TypeBadge(type: item.type),
              ],
            ),
            SizedBox(height: AppHeight.s16),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: AppTranslation.totalOrders,
                    value: item.stats.totalOrders.toString(),
                    icon: Icons.receipt_long,
                  ),
                ),
                SizedBox(width: AppWidth.s12),
                Expanded(
                  child: _StatTile(
                    label: AppTranslation.totalRevenue,
                    value: item.stats.totalRevenueDisplay.toStringAsFixed(2),
                    icon: Icons.payments_outlined,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppHeight.s12),
            _InfoRow(
              icon: Icons.location_city_outlined,
              text: locationText,
            ),
            if (coordinates != null) ...[
              SizedBox(height: AppHeight.s8),
              _InfoRow(
                icon: Icons.map_outlined,
                text:
                    '${coordinates.lat.toStringAsFixed(5)}, ${coordinates.lng.toStringAsFixed(5)}',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;

  const _TypeBadge({required this.type});

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

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatTile({
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: ColorManager.primary, size: AppSize.s18),
        SizedBox(width: AppWidth.s8),
        Expanded(
          child: CustomText(
            text: text,
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s13,
              color: ColorManager.productNameColor,
            ),
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
