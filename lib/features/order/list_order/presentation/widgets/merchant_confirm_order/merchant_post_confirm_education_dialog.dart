import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart' as di;
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

Future<void> showMerchantPostConfirmEducationDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => const _MerchantPostConfirmEducationDialog(),
  );
}

class _MerchantPostConfirmEducationDialog extends StatefulWidget {
  const _MerchantPostConfirmEducationDialog();

  @override
  State<_MerchantPostConfirmEducationDialog> createState() =>
      _MerchantPostConfirmEducationDialogState();
}

class _MerchantPostConfirmEducationDialogState
    extends State<_MerchantPostConfirmEducationDialog> {
  bool _dontShowAgain = false;

  Future<void> _onGotIt() async {
    if (_dontShowAgain) {
      await di.sl<StorageService>().setMerchantHidePostConfirmEducation(true);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final primary = ColorManager.primary;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppPadding.p20,
        vertical: AppPadding.p24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r20),
      ),
      child: Container(
        padding: EdgeInsets.all(AppPadding.p20),
        decoration: BoxDecoration(
          color: ColorManager.background,
          borderRadius: BorderRadius.circular(AppRadius.r20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(
              text: AppTranslation.merchantPostConfirmEducationTitle,
              textAlign: TextAlign.center,
              textStyle: getBoldStyle(
                fontSize: AppFontSize.s18,
                color: ColorManager.titlesColor,
              ),
            ),
            SizedBox(height: AppHeight.s20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _VisualStep(
                    icon: Icons.restaurant_menu_rounded,
                    label: AppTranslation.merchantSetPreparing,
                    accent: const Color(0xFFE65100),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppHeight.s24),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: ColorManager.textSecondary,
                    size: AppSize.s18,
                  ),
                ),
                Expanded(
                  child: _VisualStep(
                    icon: Icons.takeout_dining_rounded,
                    label: AppTranslation.merchantSetReadyPickup,
                    accent: primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppHeight.s16),
            CustomText(
              text: AppTranslation.merchantPostConfirmEducationBody,
              textAlign: TextAlign.center,
              textStyle: getRegularStyle(
                fontSize: AppFontSize.s13,
                color: ColorManager.descriptionColor,
              ),
            ),
            SizedBox(height: AppHeight.s16),
            InkWell(
              onTap: () => setState(() => _dontShowAgain = !_dontShowAgain),
              borderRadius: BorderRadius.circular(AppRadius.r12),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppPadding.p8),
                child: Row(
                  children: [
                    Icon(
                      _dontShowAgain
                          ? Icons.check_circle_outline
                          : Icons.circle_outlined,
                      color: _dontShowAgain ? primary : ColorManager.textSecondary,
                      size: AppSize.s20,
                    ),
                    SizedBox(width: AppWidth.s8),
                    Expanded(
                      child: CustomText(
                        text: AppTranslation.merchantDontShowEducationAgain,
                        textStyle: getRegularStyle(
                          fontSize: AppFontSize.s12,
                          color: ColorManager.descriptionColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppHeight.s8),
            CustomButton(
              text: AppTranslation.merchantGotIt,
              onPressed: _onGotIt,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _VisualStep extends StatelessWidget {
  const _VisualStep({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSize.s50,
          height: AppSize.s50,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: accent.withValues(alpha: 0.35)),
          ),
          child: Icon(icon, color: accent, size: AppSize.s24),
        ),
        SizedBox(height: AppHeight.s8),
        CustomText(
          text: label,
          textAlign: TextAlign.center,
          maxLines: 2,
          textOverflow: TextOverflow.ellipsis,
          textStyle: getMediumStyle(
            fontSize: AppFontSize.s10,
            color: ColorManager.titlesColor,
          ),
        ),
      ],
    );
  }
}
