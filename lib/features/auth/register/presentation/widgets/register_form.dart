import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_display.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_extensions.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/features/country/presentation/widgets/country_city_widget.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';
import 'package:jeeb_admin/features/city/domain/entities/city_entity.dart';
import 'package:jeeb_admin/features/auth/register/presentation/widgets/location_source_selector.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController restaurantNameController;
  final String? selectedRole;
  final CountryEntity? selectedCountry;
  final CityEntity? selectedCity;
  final double? useLocationLatitude;
  final double? useLocationLongitude;
  final ValueChanged<CountryEntity?> onCountryChanged;
  final ValueChanged<CityEntity?> onCityChanged;
  final VoidCallback onUseMyLocation;
  final VoidCallback? onClearDeviceLocation;
  final ValueChanged<String?> onRoleChanged;
  final VoidCallback onRegister;
  final bool isLoading;
  final bool isLocationLoading;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    required this.addressController,
    required this.restaurantNameController,
    this.selectedRole,
    this.selectedCountry,
    this.selectedCity,
    this.useLocationLatitude,
    this.useLocationLongitude,
    required this.onCountryChanged,
    required this.onCityChanged,
    required this.onUseMyLocation,
    this.onClearDeviceLocation,
    required this.onRoleChanged,
    required this.onRegister,
    required this.isLoading,
    this.isLocationLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: AppHeight.s24,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
            title: AppTranslation.email,
            hintText: AppTranslation.enterEmail,
            controller: emailController,
          ),
          CustomTextField(
            title: AppTranslation.phone,
            hintText: AppTranslation.enterPhone,
            controller: phoneController,
          ),
          CustomTextField(
            obscureText: true,
            title: AppTranslation.password,
            hintText: AppTranslation.enterPassword,
            controller: passwordController,
          ),

          CustomTextField(
            title: AppTranslation.address,
            hintText: AppTranslation.enterAddress,
            controller: addressController,
          ),
          CustomTextField(
            title: AppTranslation.restaurantName,
            hintText: AppTranslation.enterRestaurantName,
            controller: restaurantNameController,
          ),
          LocationSourceSelector(
            title: AppTranslation.location,
            useMyLocationHint: AppTranslation.useMyLocation,
            locationSetHint: AppTranslation.locationSetFormat,
            latitude: useLocationLatitude,
            longitude: useLocationLongitude,
            isRequired: true,
            onUseMyLocation: onUseMyLocation,
            onClearLocation: (useLocationLatitude != null || useLocationLongitude != null)
                ? onClearDeviceLocation
                : null,
            isLoading: isLocationLoading,
          ),
          CountryCityWidget(
            selectedCountry: selectedCountry,
            selectedCity: selectedCity,
            onSelectCountry: onCountryChanged,
            onSelectCity: onCityChanged,
            isRequired: true,
            isReadOnly: useLocationLatitude != null && useLocationLongitude != null,
          ),
          CustomButton(
            text: AppTranslation.register,
            onPressed: onRegister,
            isLoading: isLoading,
            color: ColorManager.primary,
          ),

          // CustomDropdown<String>(
          //   title: 'Role (Admin or Merchant)',
          //   value: selectedRole,
          //   hintText: 'Select Role',
          //   items: const [
          //     DropdownMenuItem<String>(
          //       value: 'MERCHANT',
          //       child: Text('MERCHANT'),
          //     ),
          //     DropdownMenuItem<String>(value: 'ADMIN', child: Text('ADMIN')),
          //   ],
          //   onChanged: onRoleChanged,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextDisplay(
                text: AppTranslation.alreadyHaveAccount,
                fontSize: AppFontSize.s14,
                color: ColorManager.textColor,
              ),
              TextButton(
                onPressed: () {
                  context.pushNamed(Routes.login);
                },
                child: CustomTextDisplay(
                  text: AppTranslation.login,
                  fontSize: AppFontSize.s14,
                  color: ColorManager.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
