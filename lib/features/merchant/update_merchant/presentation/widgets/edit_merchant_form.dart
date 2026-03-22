import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/features/city/domain/entities/city_entity.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';
import 'package:jeeb_admin/features/country/presentation/widgets/country_city_widget.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/models/edit_merchant_form_controllers.dart';

class EditMerchantForm extends StatelessWidget {
  final EditMerchantFormControllers controllers;
  final CountryEntity? selectedCountry;
  final CityEntity? selectedCity;
  final ValueChanged<CountryEntity?> onCountryChanged;
  final ValueChanged<CityEntity?> onCityChanged;
  final VoidCallback onSave;

  const EditMerchantForm({
    super.key,
    required this.controllers,
    required this.selectedCountry,
    required this.selectedCity,
    required this.onCountryChanged,
    required this.onCityChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppPadding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: controllers.firstName,
            title: AppTranslation.firstName,
            hintText: AppTranslation.enterFirstName,
          ),
          SizedBox(height: AppHeight.s16),
          CustomTextField(
            controller: controllers.lastName,
            title: AppTranslation.lastName,
            hintText: AppTranslation.enterLastName,
          ),
          SizedBox(height: AppHeight.s16),
          CustomTextField(
            controller: controllers.email,
            title: AppTranslation.email,
            hintText: AppTranslation.enterEmail,
          ),
          SizedBox(height: AppHeight.s16),
          CustomTextField(
            controller: controllers.phone,
            title: AppTranslation.phone,
            hintText: AppTranslation.enterPhone,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: AppHeight.s16),
          CustomTextField(
            controller: controllers.address,
            title: AppTranslation.address,
            hintText: AppTranslation.enterAddress,
          ),
          SizedBox(height: AppHeight.s16),
          CountryCityWidget(
            selectedCountry: selectedCountry,
            selectedCity: selectedCity,
            onSelectCountry: onCountryChanged,
            onSelectCity: onCityChanged,
            isRequired: false,
          ),
          SizedBox(height: AppHeight.s24),
          CustomButton(
            text: AppTranslation.save,
            onPressed: onSave,
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
