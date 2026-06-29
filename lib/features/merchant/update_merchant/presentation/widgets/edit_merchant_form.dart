import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/features/areas/list_areas/domain/entities/area_entity.dart';
import 'package:jeeb_admin/features/areas/list_areas/presentation/widgets/area_dropdown_widget.dart';
import 'package:jeeb_admin/features/auth/register/presentation/widgets/location_source_selector.dart';
import 'package:jeeb_admin/features/auth/register/presentation/widgets/merchant_business_type_dropdown.dart';
import 'package:jeeb_admin/features/city/domain/entities/city_entity.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';
import 'package:jeeb_admin/features/city/presentation/widgets/city_dropdown_widget.dart';
import 'package:jeeb_admin/features/country/presentation/widgets/country_dropdown_widget.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/models/edit_merchant_form_controllers.dart';

class EditMerchantForm extends StatelessWidget {
  final EditMerchantFormControllers controllers;
  final bool isEdit;
  final String merchantBusinessType;
  final CountryEntity? selectedCountry;
  final CityEntity? selectedCity;
  final AreaEntity? selectedArea;
  final double? mapLatitude;
  final double? mapLongitude;
  final ValueChanged<CountryEntity?> onCountryChanged;
  final ValueChanged<CityEntity?> onCityChanged;
  final ValueChanged<AreaEntity?> onAreaChanged;
  final ValueChanged<String> onMerchantTypeChanged;
  final VoidCallback onPickMapLocation;
  final VoidCallback? onClearMapLocation;
  final VoidCallback onSave;

  const EditMerchantForm({
    super.key,
    required this.controllers,
    required this.isEdit,
    required this.merchantBusinessType,
    required this.selectedCountry,
    required this.selectedCity,
    required this.selectedArea,
    this.mapLatitude,
    this.mapLongitude,
    required this.onCountryChanged,
    required this.onCityChanged,
    required this.onAreaChanged,
    required this.onMerchantTypeChanged,
    required this.onPickMapLocation,
    this.onClearMapLocation,
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
          if (!isEdit) ...[
            SizedBox(height: AppHeight.s16),
            CustomTextField(
              controller: controllers.password,
              title: AppTranslation.password,
              hintText: AppTranslation.enterPassword,
              obscureText: true,
            ),
          ],
          SizedBox(height: AppHeight.s16),
          CustomTextField(
            controller: controllers.address,
            title: AppTranslation.address,
            hintText: AppTranslation.enterAddress,
          ),
          SizedBox(height: AppHeight.s16),
          CustomTextField(
            controller: controllers.restaurantName,
            title: AppTranslation.restaurantName,
            hintText: AppTranslation.enterRestaurantName,
          ),
          SizedBox(height: AppHeight.s16),
          MerchantBusinessTypeDropdown(
            value: merchantBusinessType,
            onChanged: onMerchantTypeChanged,
          ),
          SizedBox(height: AppHeight.s16),
          LocationSourceSelector(
            title: AppTranslation.location,
            titleTextStyle: getMediumStyle(
              fontSize: AppFontSize.s15,
              color: ColorManager.defaultWhite,
            ),
            useMyLocationHint: AppTranslation.deliveryOpenMap,
            locationSetHint: AppTranslation.locationSetFormat,
            latitude: mapLatitude,
            longitude: mapLongitude,
            isRequired: true,
            onUseMyLocation: onPickMapLocation,
            onClearLocation: onClearMapLocation,
            isLoading: false,
          ),
          SizedBox(height: AppHeight.s16),
          CountryDropdownWidget(
            selectedCountry: selectedCountry,
            onSelectCountry: onCountryChanged,
            isRequired: true,
          ),
          SizedBox(height: AppHeight.s16),
          CityDropdownWidget(
            selectedCountry: selectedCountry,
            selectedCity: selectedCity,
            onSelectCity: onCityChanged,
            isRequired: true,
          ),
          SizedBox(height: AppHeight.s16),
          AreaDropdownWidget(
            selectedArea: selectedArea,
            onSelectArea: onAreaChanged,
          ),
          SizedBox(height: AppHeight.s24),
          CustomButton(
            text: isEdit ? AppTranslation.save : AppTranslation.addMerchant,
            onPressed: onSave,
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
