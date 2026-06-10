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
    required this.deliveryTipPerKmController,
    required this.maxOrdersPerDeliveryController,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController supportPhoneController;
  final TextEditingController whatsappNumberController;
  final TextEditingController commissionRateController;
  final TextEditingController deliveryTipPerKmController;
  final TextEditingController maxOrdersPerDeliveryController;
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
              title: AppTranslation.deliveryTipPerKilometer,
              hintText: AppTranslation.enterDeliveryTipPerKilometer,
              controller: deliveryTipPerKmController,
            ),
            SizedBox(height: AppHeight.s24),

            CustomTextField(
              title: AppTranslation.maxOrdersPerDelivery,
              hintText: AppTranslation.enterMaxOrdersPerDelivery,
              controller: maxOrdersPerDeliveryController,
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
