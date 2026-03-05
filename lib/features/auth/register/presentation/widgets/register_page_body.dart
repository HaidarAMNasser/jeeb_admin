import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';
import 'package:jeeb_admin/features/city/domain/entities/city_entity.dart';
import 'package:jeeb_admin/features/auth/register/presentation/widgets/register_form.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPageBody extends StatelessWidget {
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
  final double? useLocationLat;
  final double? useLocationLng;
  final bool isLocationLoading;
  final bool isLoading;
  final ValueChanged<CountryEntity?> onCountryChanged;
  final ValueChanged<CityEntity?> onCityChanged;
  final VoidCallback onUseMyLocation;
  final VoidCallback? onClearDeviceLocation;
  final ValueChanged<String?> onRoleChanged;
  final VoidCallback onRegister;

  const RegisterPageBody({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    required this.addressController,
    required this.restaurantNameController,
    required this.selectedRole,
    required this.selectedCountry,
    required this.selectedCity,
    required this.useLocationLat,
    required this.useLocationLng,
    required this.isLocationLoading,
    required this.isLoading,
    required this.onCountryChanged,
    required this.onCityChanged,
    required this.onUseMyLocation,
    this.onClearDeviceLocation,
    required this.onRoleChanged,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: const CustomCircleIndicator(),
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: CustomAppBar(title: AppTranslation.register),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppPadding.p24),
            child: RegisterForm(
              formKey: formKey,
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              emailController: emailController,
              passwordController: passwordController,
              phoneController: phoneController,
              addressController: addressController,
              restaurantNameController: restaurantNameController,
              selectedRole: selectedRole,
              selectedCountry: selectedCountry,
              selectedCity: selectedCity,
              useLocationLatitude: useLocationLat,
              useLocationLongitude: useLocationLng,
              isLocationLoading: isLocationLoading,
              onCountryChanged: onCountryChanged,
              onCityChanged: onCityChanged,
              onUseMyLocation: onUseMyLocation,
              onClearDeviceLocation: onClearDeviceLocation,
              onRoleChanged: onRoleChanged,
              onRegister: onRegister,
              isLoading: isLoading,
            ),
          ),
        ),
      ),
    );
  }
}
