import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/city/domain/entities/city_entity.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/presentation/bloc/merchant_details_bloc.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/helpful_functions/edit_merchant_validation.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/models/edit_merchant_form_controllers.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/bloc/update_merchant_bloc.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/widgets/edit_merchant_bloc_layer.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/widgets/edit_merchant_form.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/widgets/edit_merchant_scaffold.dart';

class EditMerchantPage extends StatefulWidget {
  final String merchantId;

  const EditMerchantPage({super.key, required this.merchantId});

  @override
  State<EditMerchantPage> createState() => _EditMerchantPageState();
}

class _EditMerchantPageState extends State<EditMerchantPage> {
  final _controllers = EditMerchantFormControllers();
  CountryEntity? _selectedCountry;
  CityEntity? _selectedCity;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    context.read<MerchantDetailsBloc>().add(
      GetMerchantDetailsEvent(id: widget.merchantId),
    );
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  void _initFormIfNeeded(MerchantDetailsLoaded state) {
    if (_initialized) return;
    _initialized = true;
    final merchant = state.merchant;
    _controllers.firstName.text = merchant.firstName ?? '';
    _controllers.lastName.text = merchant.lastName ?? '';
    _controllers.email.text = merchant.email;
    _controllers.phone.text = merchant.phoneNumber ?? '';
    _controllers.address.text = merchant.address ?? '';
    if (merchant.countryId != null && merchant.countryName != null) {
      _selectedCountry = CountryEntity(
        id: merchant.countryId!,
        name: CountryName(en: merchant.countryName!, ar: merchant.countryName!),
        code: '',
        callingCode: '',
        currencyCode: '',
        currencySymbol: '',
        currencySmallestUnit: '',
        currencyFactor: 1,
        isActive: true,
      );
    }
    if (merchant.cityId != null && merchant.cityName != null) {
      _selectedCity = CityEntity(
        id: merchant.cityId!,
        name: CityName(en: merchant.cityName!, ar: merchant.cityName!),
        countryId: merchant.countryId ?? 0,
      );
    }
  }

  void _submit() {
    final firstName = _controllers.firstName.text.trim();
    final lastName = _controllers.lastName.text.trim();
    final email = _controllers.email.text.trim();
    final phone = _controllers.phone.text.trim();

    editMerchantValidationToast(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
    );

    if (!isEditMerchantFormValid(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
    )) {
      return;
    }

    context.read<UpdateMerchantBloc>().add(
      UpdateMerchantSubmitted(
        id: widget.merchantId,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        countryId: _selectedCountry?.id,
        cityId: _selectedCity?.id,
        address: _controllers.address.text.trim().isEmpty
            ? null
            : _controllers.address.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EditMerchantBlocLayer(
      builder: (context, isLoading) => EditMerchantScaffold(
        isLoading: isLoading,
        merchantId: widget.merchantId,
        onInitialize: _initFormIfNeeded,
        formContent: EditMerchantForm(
          controllers: _controllers,
          selectedCountry: _selectedCountry,
          selectedCity: _selectedCity,
          onCountryChanged: (country) {
            setState(() => _selectedCountry = country);
          },
          onCityChanged: (city) {
            setState(() => _selectedCity = city);
          },
          onSave: _submit,
        ),
      ),
    );
  }
}
