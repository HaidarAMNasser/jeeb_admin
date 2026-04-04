import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

Future<void> showMerchantSearchingPreparingSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: ColorManager.background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.r20)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.paddingOf(ctx).bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(AppPadding.p24),
        decoration: BoxDecoration(
          color: ColorManager.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.r20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: AppWidth.s40,
                  height: AppHeight.s4,
                  decoration: BoxDecoration(
                    color: ColorManager.borderColor,
                    borderRadius: BorderRadius.circular(AppRadius.r4),
                  ),
                ),
              ),
              SizedBox(height: AppHeight.s20),
              _SearchingHeroRow(),
              SizedBox(height: AppHeight.s20),
              CustomText(
                text: AppTranslation.merchantPreparingWaitDriverTitle,
                textAlign: TextAlign.center,
                textStyle: getBoldStyle(
                  fontSize: AppFontSize.s18,
                  color: ColorManager.titlesColor,
                ),
              ),
              SizedBox(height: AppHeight.s12),
              CustomText(
                text: AppTranslation.merchantPreparingWaitDriverBody,
                textAlign: TextAlign.center,
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.descriptionColor,
                ),
              ),
              SizedBox(height: AppHeight.s12),
              Container(
                padding: EdgeInsets.all(AppPadding.p12),
                decoration: BoxDecoration(
                  color: ColorManager.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  border: Border.all(
                    color: ColorManager.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_emotions_outlined,
                      color: ColorManager.primary,
                      size: AppSize.s22,
                    ),
                    SizedBox(width: AppWidth.s8),
                    Expanded(
                      child: CustomText(
                        text: AppTranslation.merchantSearchingSheetTagline,
                        textStyle: getMediumStyle(
                          fontSize: AppFontSize.s13,
                          color: ColorManager.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppHeight.s24),
              CustomButton(
                text: AppTranslation.close,
                onPressed: () => Navigator.of(ctx).pop(),
                isOutlined: true,
                color: ColorManager.primary,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Driver search + delivery vibe (aligned with language-dialog card feel).
class _SearchingHeroRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget card({
      required IconData icon,
      required String emoji,
      required Color accent,
    }) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppPadding.p16,
            horizontal: AppPadding.p8,
          ),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: accent.withValues(alpha: 0.35)),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              SizedBox(height: AppHeight.s8),
              Icon(icon, size: AppSize.s28, color: accent),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        card(
          emoji: '🔍',
          icon: Icons.person_search_rounded,
          accent: Colors.blue.shade700,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.p8),
          child: Icon(
            Icons.more_horiz_rounded,
            color: ColorManager.textSecondary,
            size: AppSize.s28,
          ),
        ),
        card(
          emoji: '🛵',
          icon: Icons.delivery_dining_rounded,
          accent: ColorManager.primary,
        ),
      ],
    );
  }
}
