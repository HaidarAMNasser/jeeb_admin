import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/domain/entities/merchant_statistics_entity.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/presentation/widgets/card/merchant_statistics_card_content.dart';

class MerchantStatisticsCard extends StatelessWidget {
  final MerchantStatisticsEntity item;

  const MerchantStatisticsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorManager.defaultWhite,
      margin: EdgeInsets.only(bottom: AppMargin.m16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p16),
        child: MerchantStatisticsCardContent(item: item),
      ),
    );
  }
}
