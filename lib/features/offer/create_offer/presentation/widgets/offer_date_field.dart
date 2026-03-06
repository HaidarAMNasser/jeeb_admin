import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

class OfferDateField extends StatelessWidget {
  final String title;
  final DateTime? value;
  final VoidCallback onTap;

  const OfferDateField({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = value != null
        ? '${value!.day}/${value!.month}/${value!.year}'
        : AppTranslation.selectDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          textStyle: getMediumStyle(
            fontSize: AppFontSize.s15,
            color: ColorManager.defaultWhite,
          ),
        ),
        SizedBox(height: AppHeight.s8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p16,
              vertical: AppHeight.s16,
            ),
            decoration: BoxDecoration(
              color: ColorManager.defaultWhite,
              borderRadius: BorderRadius.circular(AppRadius.r18),
              border: Border.all(color: ColorManager.borderColor),
            ),
            child: CustomText(
              text: displayText,
              textStyle: getRegularStyle(
                fontSize: AppFontSize.s14,
                color: value != null
                    ? ColorManager.productNameColor
                    : ColorManager.descriptionColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
