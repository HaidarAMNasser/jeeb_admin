import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_paginated_dropdown.dart';

class MerchantBusinessTypeDropdown extends StatelessWidget {
  const MerchantBusinessTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomPaginatedDropdown<String>(
      title: AppTranslation.merchantBusinessType,
      hintText: AppTranslation.merchantBusinessType,
      items: const ['RESTAURANT', 'STORE'],
      selectedItem: value,
      displayText: (item) {
        if (item == 'STORE') return AppTranslation.merchantTypeMarket;
        return AppTranslation.merchantTypeRestaurant;
      },
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      hasMoreData: false,
      isLoading: false,
      isLoadingMore: false,
    );
  }
}

