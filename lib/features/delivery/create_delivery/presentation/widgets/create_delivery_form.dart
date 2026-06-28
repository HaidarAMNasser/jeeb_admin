import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';
import 'package:jeeb_admin/features/city/domain/entities/city_entity.dart';
import 'package:jeeb_admin/features/country/presentation/widgets/country_city_widget.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/helpful_functions/delivery_validation.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/helpful_functions/birthday_format.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/presentation/models/delivery_form_controllers.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/presentation/models/delivery_form_values.dart';
import 'package:jeeb_admin/features/auth/register/presentation/widgets/location_source_selector.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/presentation/widgets/delivery_birthday_field.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';

class CreateDeliveryForm extends StatelessWidget {
  final bool isEdit;
  final String? deliveryManId;
  final DeliveryFormControllers controllers;
  final String? imagePath;
  final CountryEntity? selectedCountry;
  final CityEntity? selectedCity;
  final void Function(CountryEntity?) onCountryChanged;
  final void Function(CityEntity?) onCityChanged;
  final GlobalKey<FormState> formKey;
  final void Function(DeliveryFormValues values) onSubmit;
  /// Picked driver coordinates (create and edit).
  final double? mapLatitude;
  final double? mapLongitude;
  final VoidCallback onPickMapLocation;
  final VoidCallback onClearMapLocation;

  const CreateDeliveryForm({
    super.key,
    required this.isEdit,
    this.deliveryManId,
    required this.controllers,
    this.imagePath,
    this.selectedCountry,
    this.selectedCity,
    required this.onCountryChanged,
    required this.onCityChanged,
    required this.formKey,
    required this.onSubmit,
    this.mapLatitude,
    this.mapLongitude,
    required this.onPickMapLocation,
    required this.onClearMapLocation,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppPadding.p16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DeliveryFormFields(controllers: controllers, isEdit: isEdit),
            SizedBox(height: AppHeight.s16),
            CountryCityWidget(
              selectedCountry: selectedCountry,
              selectedCity: selectedCity,
              onSelectCountry: onCountryChanged,
              onSelectCity: onCityChanged,
              isRequired: false,
            ),
            SizedBox(height: AppHeight.s16),
            LocationSourceSelector(
              title: AppTranslation.deliveryPickLocation,
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
              onClearLocation:
                  (mapLatitude != null || mapLongitude != null)
                      ? onClearMapLocation
                      : null,
              isLoading: false,
            ),
            SizedBox(height: AppHeight.s24),
            CustomButton(
              text: isEdit
                  ? AppTranslation.save
                  : AppTranslation.addDeliveryMan,
              onPressed: () => _handleSubmit(context),
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    final firstName = controllers.firstName.text.trim();
    final lastName = controllers.lastName.text.trim();
    final phone = controllers.phone.text.trim();
    final email = controllers.email.text.trim();
    final password = controllers.password.text.trim();

    deliveryValidationToast(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      password: password,
      isEditMode: isEdit,
      latitude: mapLatitude,
      longitude: mapLongitude,
    );

    if (!isDeliveryFormValid(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      password: password,
      isEditMode: isEdit,
      latitude: mapLatitude,
      longitude: mapLongitude,
    )) {
      return;
    }

    final address = controllers.address.text.trim();
    final rawBirthday = controllers.birthday.text.trim();
    final String? birthday;
    if (rawBirthday.isEmpty) {
      birthday = null;
    } else {
      final normalized = normalizeBirthdayForPayload(rawBirthday);
      if (normalized == null) {
        customToast(msg: AppTranslation.deliveryBirthdayInvalid);
        return;
      }
      birthday = normalized;
    }

    onSubmit(
      DeliveryFormValues(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        password: password,
        address: address.isEmpty ? null : address,
        birthday: birthday,
        imagePath: imagePath,
        countryId: selectedCountry?.id,
        cityId: selectedCity?.id,
        latitude: mapLatitude,
        longitude: mapLongitude,
      ),
    );
  }
}

class _DeliveryFormFields extends StatelessWidget {
  final DeliveryFormControllers controllers;
  final bool isEdit;

  const _DeliveryFormFields({required this.controllers, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
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
          keyboardType: TextInputType.phone,
          controller: controllers.phone,
          title: AppTranslation.phone,
          hintText: AppTranslation.enterPhone,
        ),
        SizedBox(height: AppHeight.s16),
        CustomTextField(
          controller: controllers.email,
          title: AppTranslation.email,
          hintText: AppTranslation.enterEmail,
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
        DeliveryBirthdayField(birthdayController: controllers.birthday),
      ],
    );
  }
}
