import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_date_select.dart';

class MerchantStatisticsDateFilterBar extends StatelessWidget {
  final DateTime? from;
  final DateTime? to;
  final ValueChanged<DateTime?> onFromChanged;
  final ValueChanged<DateTime?> onToChanged;
  final VoidCallback onClear;

  const MerchantStatisticsDateFilterBar({
    super.key,
    required this.from,
    required this.to,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 5);
    final lastDate = DateTime(now.year + 1);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppPadding.p16,
        0,
        AppPadding.p16,
        AppPadding.p12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomDateSelect(
              hintText: AppTranslation.fromDate,
              initialValue: from,
              firstDate: firstDate,
              lastDate: lastDate,
              onDateSelected: onFromChanged,
            ),
          ),
          SizedBox(width: AppWidth.s8),
          Expanded(
            child: CustomDateSelect(
              hintText: AppTranslation.toDate,
              initialValue: to,
              firstDate: firstDate,
              lastDate: lastDate,
              onDateSelected: onToChanged,
            ),
          ),
          SizedBox(width: AppWidth.s8),
          IconButton(
            onPressed: onClear,
            icon: Icon(Icons.close, color: ColorManager.defaultWhite),
          ),
        ],
      ),
    );
  }
}
