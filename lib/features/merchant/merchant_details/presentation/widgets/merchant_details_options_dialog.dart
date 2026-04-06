import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

class MerchantDetailsOptionsDialog extends StatelessWidget {
  final bool hidePhoneNumber;
  final bool? merchantIsActive;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTogglePhoneVisibility;
  final VoidCallback onToggleMerchantActive;

  const MerchantDetailsOptionsDialog({
    super.key,
    required this.hidePhoneNumber,
    this.merchantIsActive,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePhoneVisibility,
    required this.onToggleMerchantActive,
  });

  static Future<void> show({
    required BuildContext context,
    required bool hidePhoneNumber,
    bool? merchantIsActive,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required VoidCallback onTogglePhoneVisibility,
    required VoidCallback onToggleMerchantActive,
  }) {
    return showDialog(
      context: context,
      builder: (context) => MerchantDetailsOptionsDialog(
        hidePhoneNumber: hidePhoneNumber,
        merchantIsActive: merchantIsActive,
        onEdit: onEdit,
        onDelete: onDelete,
        onTogglePhoneVisibility: onTogglePhoneVisibility,
        onToggleMerchantActive: onToggleMerchantActive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r20),
      ),
      child: Container(
        padding: EdgeInsets.all(AppPadding.p24),
        decoration: BoxDecoration(
          color: ColorManager.background,
          borderRadius: BorderRadius.circular(AppRadius.r20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(
              text: AppTranslation.options,
              textStyle: getBoldStyle(
                fontSize: AppFontSize.s18,
                color: ColorManager.titlesColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppHeight.s24),
            _OptionTile(
              label: AppTranslation.editMerchant,
              onTap: () {
                Navigator.of(context).pop();
                onEdit();
              },
            ),
            SizedBox(height: AppHeight.s16),
            if (merchantIsActive != null)
              _OptionTile(
                label: merchantIsActive!
                    ? AppTranslation.merchantDeactivateAction
                    : AppTranslation.merchantActivateAction,
                onTap: () {
                  Navigator.of(context).pop();
                  onToggleMerchantActive();
                },
              ),
            if (merchantIsActive != null) SizedBox(height: AppHeight.s16),
            _OptionTile(
              label: hidePhoneNumber
                  ? AppTranslation.showPhoneNumber
                  : AppTranslation.hidePhoneNumberOption,
              onTap: () {
                Navigator.of(context).pop();
                onTogglePhoneVisibility();
              },
            ),
            SizedBox(height: AppHeight.s16),
            _OptionTile(
              label: AppTranslation.delete,
              isDestructive: true,
              onTap: () {
                Navigator.of(context).pop();
                onDelete();
              },
            ),
            SizedBox(height: AppHeight.s24),
            CustomButton(
              text: AppTranslation.close,
              onPressed: () => Navigator.of(context).pop(),
              isOutlined: true,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool isDestructive;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? ColorManager.primary : ColorManager.titlesColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r12),
      child: Container(
        padding: EdgeInsets.all(AppPadding.p16),
        decoration: BoxDecoration(
          color: ColorManager.background,
          border: Border.all(
            color: isDestructive ? ColorManager.primary : ColorManager.borderColor,
          ),
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                text: label,
                textStyle: getSemiBoldStyle(
                  fontSize: AppFontSize.s18,
                  color: color,
                ),
              ),
            ),
            Icon(
              isDestructive ? Icons.delete_outline : Icons.arrow_forward_ios,
              size: AppSize.s18,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
