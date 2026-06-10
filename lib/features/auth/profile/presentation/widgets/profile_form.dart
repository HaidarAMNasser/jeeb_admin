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
import 'package:jeeb_admin/features/auth/register/presentation/widgets/merchant_business_type_dropdown.dart';
import 'package:jeeb_admin/features/auth/profile/presentation/widgets/profile_send_notification_tile.dart';

class ProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final UserEntity user;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController restaurantNameController;
  final VoidCallback onUpdate;
  final bool isLoading;
  final VoidCallback onChangeLanguage;
  final VoidCallback onChangePassword;
  final VoidCallback onUpdateLocation;
  final ValueChanged<bool> onAccountStatusChanged;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onCategoriesTap;
  final VoidCallback? onAreasTap;
  final VoidCallback? onSendNotificationTap;
  /// Merchant-only fields/actions — from SharedPreferences `user_role` at login.
  final bool isMerchantFromStorage;
  /// `RESTAURANT` or `STORE`; only used when [isMerchantFromStorage].
  final String merchantBusinessType;
  final ValueChanged<String> onMerchantBusinessTypeChanged;

  const ProfileForm({
    super.key,
    required this.isMerchantFromStorage,
    required this.merchantBusinessType,
    required this.onMerchantBusinessTypeChanged,
    required this.formKey,
    required this.user,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.addressController,
    required this.restaurantNameController,
    required this.onUpdate,
    required this.isLoading,
    required this.onChangeLanguage,
    required this.onChangePassword,
    required this.onUpdateLocation,
    required this.onAccountStatusChanged,
    this.onSettingsTap,
    this.onCategoriesTap,
    this.onAreasTap,
    this.onSendNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: AppSize.s24.h,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isMerchantFromStorage)
            CustomCheckbox(
              value: user.isOpen ?? true,
              onChanged: (value) {
                if (value != null) {
                  onAccountStatusChanged(value);
                }
              },
              label: AppTranslation.restaurantOpenNow,
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
          if (isMerchantFromStorage)
            CustomTextField(
              title: AppTranslation.restaurantName,
              hintText: AppTranslation.restaurantName,
              controller: restaurantNameController,
            ),
          if (isMerchantFromStorage) ...[
            MerchantBusinessTypeDropdown(
              value: merchantBusinessType,
              onChanged: onMerchantBusinessTypeChanged,
            ),
          ],
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
          InkWell(
            onTap: onChangePassword,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppPadding.p8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 20, color: ColorManager.primary),
                  SizedBox(width: AppWidth.s8),
                  CustomText(
                    text: AppTranslation.changePasswordAction,
                    textStyle: getMediumStyle(
                      color: ColorManager.primary,
                      fontSize: AppFontSize.s15,
                    ),
                  ),
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
          if (onCategoriesTap != null)
            InkWell(
              onTap: onCategoriesTap,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppPadding.p8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.category, size: 20, color: ColorManager.primary),
                    SizedBox(width: AppWidth.s8),
                    CustomText(
                      text: AppTranslation.categories,
                      textStyle: getMediumStyle(
                        color: ColorManager.primary,
                        fontSize: AppFontSize.s15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (onAreasTap != null)
            InkWell(
              onTap: onAreasTap,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppPadding.p8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map_outlined, size: 20, color: ColorManager.primary),
                    SizedBox(width: AppWidth.s8),
                    CustomText(
                      text: AppTranslation.areas,
                      textStyle: getMediumStyle(
                        color: ColorManager.primary,
                        fontSize: AppFontSize.s15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (onSendNotificationTap != null)
            ProfileSendNotificationTile(onTap: onSendNotificationTap!),
          if (isMerchantFromStorage) ...[
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
