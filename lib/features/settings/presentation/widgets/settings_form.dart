import 'package:flutter/material.dart';

import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

class SettingsForm extends StatelessWidget {
  const SettingsForm({
    super.key,
    required this.formKey,
    required this.supportPhoneController,
    required this.whatsappNumberController,
    required this.commissionRateController,
    required this.maxIncompleteOrdersController,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController supportPhoneController;
  final TextEditingController whatsappNumberController;
  final TextEditingController commissionRateController;
  final TextEditingController maxIncompleteOrdersController;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppPadding.p24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              title: AppTranslation.supportPhone,
              hintText: AppTranslation.enterSupportPhone,
              controller: supportPhoneController,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: AppHeight.s24),
            CustomTextField(
              title: AppTranslation.whatsappNumber,
              hintText: AppTranslation.enterWhatsappNumber,
              controller: whatsappNumberController,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: AppHeight.s24),
            CustomTextField(
              title: AppTranslation.defaultCommissionRate,
              hintText: AppTranslation.enterCommissionRate,
              controller: commissionRateController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppHeight.s24),
            CustomTextField(
              title: AppTranslation.maxIncompleteOrdersForDriver,
              hintText: AppTranslation.enterMaxIncompleteOrdersForDriver,
              controller: maxIncompleteOrdersController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppHeight.s32),
            CustomButton(
              text: AppTranslation.save,
              onPressed: onSave,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }
}
