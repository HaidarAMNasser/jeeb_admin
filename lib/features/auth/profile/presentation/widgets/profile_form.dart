import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/auth/login/domain/entities/user_entity.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_checkbox.dart';

class ProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final UserEntity user;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final VoidCallback onUpdate;
  final bool isLoading;
  final VoidCallback onChangeLanguage;
  final bool isMerchant;
  final VoidCallback onUpdateLocation;
  final ValueChanged<bool> onAccountStatusChanged;
  final VoidCallback? onSettingsTap;

  const ProfileForm({
    super.key,
    required this.formKey,
    required this.user,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.addressController,
    required this.onUpdate,
    required this.isLoading,
    required this.onChangeLanguage,
    required this.isMerchant,
    required this.onUpdateLocation,
    required this.onAccountStatusChanged,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: AppSize.s24.h,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isMerchant)
            CustomCheckbox(
              value: user.isActive ?? true,
              onChanged: (value) {
                if (value != null) {
                  onAccountStatusChanged(value);
                }
              },
              label: AppTranslation.accountStatus,
            ),
          CustomTextField(
            title: AppTranslation.firstName,
            hintText: AppTranslation.firstName,
            controller: firstNameController,
          ),
          CustomTextField(
            title: AppTranslation.lastName,
            hintText: AppTranslation.lastName,
            controller: lastNameController,
          ),
          CustomTextField(
            title: AppTranslation.phone,
            hintText: AppTranslation.enterPhone,
            controller: phoneController,
          ),
          CustomTextField(
            title: AppTranslation.address,
            hintText: AppTranslation.enterAddress,
            controller: addressController,
          ),
          InkWell(
            onTap: onChangeLanguage,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppPadding.p8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.language, size: 20, color: ColorManager.primary),
                  SizedBox(width: AppWidth.s8),
                  CustomText(
                    text: AppTranslation.changeLanguage,
                    textStyle: getMediumStyle(
                      color: ColorManager.primary,
                      fontSize: AppFontSize.s15,
                    ),
                  ),
                  SizedBox(width: AppWidth.s8),
                ],
              ),
            ),
          ),
          if (onSettingsTap != null)
            InkWell(
              onTap: onSettingsTap,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppPadding.p8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.settings, size: 20, color: ColorManager.primary),
                    SizedBox(width: AppWidth.s8),
                    CustomText(
                      text: AppTranslation.settings,
                      textStyle: getMediumStyle(
                        color: ColorManager.primary,
                        fontSize: AppFontSize.s15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (isMerchant) ...[
            InkWell(
              onTap: onUpdateLocation,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppPadding.p8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20,
                      color: ColorManager.primary,
                    ),
                    SizedBox(width: AppWidth.s8),
                    CustomText(
                      text: AppTranslation.updateLocation,
                      textStyle: getMediumStyle(
                        color: ColorManager.primary,
                        fontSize: AppFontSize.s15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          CustomButton(
            text: AppTranslation.save,
            onPressed: isLoading ? null : onUpdate,
            color: ColorManager.primary,
          ),
        ],
      ),
    );
  }
}
