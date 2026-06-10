import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_search_field.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/presentation/widgets/page_body/merchant_statistics_date_filter_bar.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/presentation/widgets/page_body/merchant_statistics_list.dart';

class MerchantStatisticsPageBody extends StatelessWidget {
  const MerchantStatisticsPageBody({
    super.key,
    required this.searchController,
    required this.scrollController,
    required this.from,
    required this.to,
    required this.onApplyFilters,
    required this.onClearFilters,
    required this.onFromChanged,
    required this.onToChanged,
  });

  final TextEditingController searchController;
  final ScrollController scrollController;
  final DateTime? from;
  final DateTime? to;
  final VoidCallback onApplyFilters;
  final VoidCallback onClearFilters;
  final ValueChanged<DateTime?> onFromChanged;
  final ValueChanged<DateTime?> onToChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchField(
          hintText: AppTranslation.searchMerchantStatisticsHint,
          controller: searchController,
          onSubmitted: (_) => onApplyFilters(),
          onRefetch: onClearFilters,
        ),
        MerchantStatisticsDateFilterBar(
          from: from,
          to: to,
          onFromChanged: onFromChanged,
          onToChanged: onToChanged,
          onClear: onClearFilters,
        ),
        Expanded(
          child: MerchantStatisticsList(
            scrollController: scrollController,
            onApplyFilters: onApplyFilters,
          ),
        ),
      ],
    );
  }
}
