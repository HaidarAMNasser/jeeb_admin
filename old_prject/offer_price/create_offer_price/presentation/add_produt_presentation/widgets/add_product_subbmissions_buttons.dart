import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/returns_reports/widgets/custom_text_field.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';

Widget addProductSubbmissionButtons({
  required bool isEditMode,
  required bool isButtonActive,
  required bool isFormValid,
  required VoidCallback onSave,
  required VoidCallback onSaveAndAddNew,
}) {
  return Row(
    children: [
      Expanded(
        child: CustomButton(
          text: isEditMode
              ? TranslationsController.instance.getTranslations().save
              : TranslationsController.instance.getTranslations().add,
          onPressed: onSave,
          color: isButtonActive
              ? ColorManager.primaryColor
              : ColorManager.closeDialogColor,
          textcolor: ColorManager.white,
        ),
      ),
      if (!isEditMode) ...[
        horizontalSpace(width: AppWidth.s10),
        Expanded(
          child: CustomButton(
            text:
                TranslationsController.instance.getTranslations().saveAndAddNew,
            onPressed: onSaveAndAddNew,
            color: isFormValid ? ColorManager.green50 : ColorManager.lightGrey,
            textcolor: ColorManager.primaryColor,
          ),
        ),
      ],
    ],
  );
}
