import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/city/presentation/bloc/city_bloc.dart';
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
  int? _initialCityIdToHydrate;
  bool _isHydratingCity = false;

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
    _initialCityIdToHydrate = merchant.cityId;
    _isHydratingCity = merchant.cityId != null;
    final prefillCountry = merchant.countryId != null
        ? CountryEntity(
            id: merchant.countryId!,
            name: CountryName(
              en: (merchant.countryName ?? '').trim().isEmpty
                  ? '${merchant.countryId}'
                  : (merchant.countryName ?? '').trim(),
              ar: (merchant.countryName ?? '').trim().isEmpty
                  ? '${merchant.countryId}'
                  : (merchant.countryName ?? '').trim(),
            ),
            code: '',
            callingCode: '',
            currencyCode: '',
            currencySymbol: '',
            currencySmallestUnit: '',
            currencyFactor: 1,
            isActive: true,
          )
        : null;
    final prefillCity = merchant.cityId != null
        ? CityEntity(
            id: merchant.cityId!,
            name: CityName(
              en: (merchant.cityName ?? '').trim().isEmpty
                  ? '${merchant.cityId}'
                  : (merchant.cityName ?? '').trim(),
              ar: (merchant.cityName ?? '').trim().isEmpty
                  ? '${merchant.cityId}'
                  : (merchant.cityName ?? '').trim(),
            ),
            countryId: merchant.countryId ?? 0,
          )
        : null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _controllers.firstName.text = merchant.firstName ?? '';
        _controllers.lastName.text = merchant.lastName ?? '';
        _controllers.email.text = merchant.email;
        _controllers.phone.text = merchant.phoneNumber ?? '';
        _controllers.address.text = merchant.address ?? '';
        _selectedCountry = prefillCountry;
        _selectedCity = prefillCity;
      });
    });
  }

  void _onCityChanged(CityEntity? city) {
    // CountryCityWidget emits null when country changes; ignore this one-time
    // reset during initial hydration to preserve backend city value.
    if (_isHydratingCity && city == null) return;
    setState(() => _selectedCity = city);
  }

  void _tryHydrateCityFromState(CityState state) {
    if (!_isHydratingCity || _initialCityIdToHydrate == null) return;
    if (state is! CityLoaded) return;
    final cityId = _initialCityIdToHydrate!;
    CityEntity? matched;
    for (final city in state.cities) {
      if (city.id == cityId) {
        matched = city;
        break;
      }
    }
    if (matched == null) return;
    if (!mounted) return;
    setState(() {
      _selectedCity = matched;
      _isHydratingCity = false;
      _initialCityIdToHydrate = null;
    });
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
    return BlocListener<CityBloc, CityState>(
      listener: (context, state) => _tryHydrateCityFromState(state),
      child: EditMerchantBlocLayer(
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
            onCityChanged: _onCityChanged,
            onSave: _submit,
          ),
        ),
      ),
    );
  }
}
