import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_service.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/features/auth/login/domain/entities/user_entity.dart';
import 'package:jeeb_admin/features/auth/profile/presentation/widgets/profile_header.dart';
import 'package:jeeb_admin/features/auth/profile/presentation/widgets/profile_form.dart';

class ProfilePageContent extends StatelessWidget {
  final UserEntity user;
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController restaurantNameController;
  final bool isAdminFromStorage;
  /// From [StorageService] `user_role` (login), not API profile `role`.
  final bool isMerchantFromStorage;
  final String merchantBusinessType;
  final ValueChanged<String> onMerchantBusinessTypeChanged;
  final VoidCallback onUpdate;
  final VoidCallback onChangeLanguage;
  final VoidCallback onChangePassword;
  final VoidCallback onUpdateLocation;
  final ValueChanged<bool> onAccountStatusChanged;
  final bool isUpdateLoading;
  final VoidCallback? onPickImage;
  final VoidCallback? onSendNotificationTap;

  const ProfilePageContent({
    super.key,
    required this.user,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.addressController,
    required this.restaurantNameController,
    required this.isAdminFromStorage,
    required this.isMerchantFromStorage,
    required this.merchantBusinessType,
    required this.onMerchantBusinessTypeChanged,
    required this.onUpdate,
    required this.onChangeLanguage,
    required this.onChangePassword,
    required this.onUpdateLocation,
    required this.onAccountStatusChanged,
    required this.isUpdateLoading,
    this.onPickImage,
    this.onSendNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppPadding.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileHeader(user: user, onPickImage: onPickImage),
          SizedBox(height: AppHeight.s32),
          ProfileForm(
            isMerchantFromStorage: isMerchantFromStorage,
            merchantBusinessType: merchantBusinessType,
            onMerchantBusinessTypeChanged: onMerchantBusinessTypeChanged,
            onUpdateLocation: onUpdateLocation,
            onAccountStatusChanged: onAccountStatusChanged,
            onChangeLanguage: onChangeLanguage,
            onChangePassword: onChangePassword,
            formKey: formKey,
            user: user,
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            phoneController: phoneController,
            addressController: addressController,
            restaurantNameController: restaurantNameController,
            onUpdate: onUpdate,
            isLoading: isUpdateLoading,
            onSettingsTap: isAdminFromStorage
                ? () => NavigationService().pushNamed(Routes.settings)
                : null,
            onCategoriesTap: isAdminFromStorage
                ? () => NavigationService().pushNamed(Routes.categories)
                : null,
            onAreasTap: isAdminFromStorage
                ? () => NavigationService().pushNamed(Routes.areas)
                : null,
            onSendNotificationTap: isAdminFromStorage
                ? onSendNotificationTap
                : null,
          ),
          SizedBox(height: AppHeight.s24),
        ],
      ),
    );
  }
}
