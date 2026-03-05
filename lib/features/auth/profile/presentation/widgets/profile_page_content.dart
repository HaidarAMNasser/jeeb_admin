import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
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
  final bool isMerchant;
  final VoidCallback onUpdate;
  final VoidCallback onChangeLanguage;
  final VoidCallback onUpdateLocation;
  final ValueChanged<bool> onAccountStatusChanged;
  final bool isUpdateLoading;

  const ProfilePageContent({
    super.key,
    required this.user,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.addressController,
    required this.isMerchant,
    required this.onUpdate,
    required this.onChangeLanguage,
    required this.onUpdateLocation,
    required this.onAccountStatusChanged,
    required this.isUpdateLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppPadding.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileHeader(user: user),
          SizedBox(height: AppHeight.s32),
          ProfileForm(
            isMerchant: isMerchant,
            onUpdateLocation: onUpdateLocation,
            onAccountStatusChanged: onAccountStatusChanged,
            onChangeLanguage: onChangeLanguage,
            formKey: formKey,
            user: user,
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            phoneController: phoneController,
            addressController: addressController,
            onUpdate: onUpdate,
            isLoading: isUpdateLoading,
          ),
          SizedBox(height: AppHeight.s24),
        ],
      ),
    );
  }
}
