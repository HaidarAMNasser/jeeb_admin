import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/presentation/widgets/delivery_list_item_pill.dart';

/// Online/offline and confirmation pills on one row (beside each other).
class DeliveryListItemStatusRow extends StatelessWidget {
  final bool? isOnline;
  final bool isConfirmed;

  const DeliveryListItemStatusRow({
    super.key,
    required this.isOnline,
    required this.isConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppWidth.s8,
      runSpacing: AppHeight.s8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (isOnline != null)
          DeliveryListItemPill(
            label: isOnline == true
                ? AppTranslation.online
                : AppTranslation.offline,
            backgroundColor: isOnline == true
                ? ColorManager.primary.withOpacity(0.1)
                : ColorManager.descriptionColor.withOpacity(0.2),
            textColor: isOnline == true
                ? ColorManager.primary
                : ColorManager.descriptionColor,
          ),
        DeliveryListItemPill(
          label: isConfirmed
              ? AppTranslation.confirmed
              : AppTranslation.notConfirmed,
          backgroundColor: isConfirmed
              ? ColorManager.success.withOpacity(0.12)
              : ColorManager.defaultYellow.withOpacity(0.18),
          textColor: isConfirmed
              ? ColorManager.success
              : ColorManager.defaultYellow,
        ),
      ],
    );
  }
}
