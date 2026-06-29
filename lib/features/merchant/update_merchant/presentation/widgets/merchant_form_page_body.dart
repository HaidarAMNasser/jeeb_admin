import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/maps/google_map_location_picker_page.dart';
import 'package:jeeb_admin/features/areas/list_areas/domain/entities/area_entity.dart';
import 'package:jeeb_admin/features/city/presentation/bloc/city_bloc.dart';
import 'package:jeeb_admin/features/city/domain/entities/city_entity.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';
import 'package:jeeb_admin/features/merchant/create_merchant/presentation/bloc/create_merchant_bloc.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/presentation/bloc/merchant_details_bloc.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/helpful_functions/merchant_form_validation.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/models/edit_merchant_form_controllers.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/bloc/update_merchant_bloc.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/widgets/edit_merchant_form.dart';

class MerchantFormPageBody extends StatefulWidget {
  final bool isEditMode;
  final String? merchantId;
  final MerchantDetailsLoaded? merchantDetails;

  const MerchantFormPageBody({
    super.key,
    required this.isEditMode,
    this.merchantId,
    this.merchantDetails,
  });

  @override
  State<MerchantFormPageBody> createState() => _MerchantFormPageBodyState();
}

class _MerchantFormPageBodyState extends State<MerchantFormPageBody> {
  final _controllers = EditMerchantFormControllers();
  CountryEntity? _selectedCountry;
  CityEntity? _selectedCity;
  AreaEntity? _selectedArea;
  String _merchantBusinessType = 'RESTAURANT';
  double? _mapLatitude;
  double? _mapLongitude;
  bool _initialized = false;
  int? _initialCityIdToHydrate;
  bool _isHydratingCity = false;

  @override
  void didUpdateWidget(MerchantFormPageBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.merchantDetails != null &&
        widget.merchantDetails != oldWidget.merchantDetails) {
      _initFromMerchant(widget.merchantDetails!);
    }
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.of(context).push<GoogleMapLocationPickResult>(
      MaterialPageRoute(
        builder: (_) => GoogleMapLocationPickerPage(
          initialLatitude: _mapLatitude,
          initialLongitude: _mapLongitude,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _mapLatitude = result.latitude;
        _mapLongitude = result.longitude;
      });
    }
  }

  void _initFromMerchant(MerchantDetailsLoaded state) {
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

    final merchantType = merchant.merchantType;
    final normalizedType =
        merchantType == 'STORE' || merchantType == 'RESTAURANT'
            ? merchantType!
            : 'RESTAURANT';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _controllers.firstName.text = merchant.firstName ?? '';
        _controllers.lastName.text = merchant.lastName ?? '';
        _controllers.email.text = merchant.email;
        _controllers.phone.text = merchant.phoneNumber ?? '';
        _controllers.address.text = merchant.address ?? '';
        _controllers.restaurantName.text = merchant.restaurantName;
        _selectedCountry = prefillCountry;
        _selectedCity = prefillCity;
        _merchantBusinessType = normalizedType;
        _mapLatitude = merchant.currentLat;
        _mapLongitude = merchant.currentLng;
      });
    });
  }

  void _onCityChanged(CityEntity? city) {
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
    final password = _controllers.password.text.trim();
    final restaurantName = _controllers.restaurantName.text.trim();
    final countryId = _selectedCountry?.id;
    final cityId = _selectedCity?.id;
    final areaId =
        _selectedArea != null ? int.tryParse(_selectedArea!.id) : null;
    final address = _controllers.address.text.trim();

    merchantFormValidationToast(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      restaurantName: restaurantName,
      address: address,
      countryId: countryId,
      cityId: cityId,
      areaId: areaId,
      latitude: _mapLatitude,
      longitude: _mapLongitude,
      isEditMode: widget.isEditMode,
      password: password,
    );

    if (!isMerchantFormValid(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      restaurantName: restaurantName,
      address: address,
      countryId: countryId,
      cityId: cityId,
      areaId: areaId,
      latitude: _mapLatitude,
      longitude: _mapLongitude,
      isEditMode: widget.isEditMode,
      password: password,
    )) {
      return;
    }

    if (widget.isEditMode) {
      context.read<UpdateMerchantBloc>().add(
            UpdateMerchantSubmitted(
              id: widget.merchantId!,
              firstName: firstName,
              lastName: lastName,
              phone: phone,
              email: email,
              countryId: countryId,
              cityId: cityId,
              areaId: areaId,
              restaurantName: restaurantName,
              merchantType: _merchantBusinessType,
              latitude: _mapLatitude,
              longitude: _mapLongitude,
              address: address,
            ),
          );
    } else {
      context.read<CreateMerchantBloc>().add(
            CreateMerchantSubmitted(
              firstName: firstName,
              lastName: lastName,
              email: email,
              password: password,
              phone: phone,
              countryId: countryId!,
              cityId: cityId!,
              areaId: areaId!,
              restaurantName: restaurantName,
              merchantType: _merchantBusinessType,
              latitude: _mapLatitude!,
              longitude: _mapLongitude!,
              address: address,
              notificationChannel: 'WHATSAPP',
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CityBloc, CityState>(
      listener: (context, state) => _tryHydrateCityFromState(state),
      child: EditMerchantForm(
        controllers: _controllers,
        isEdit: widget.isEditMode,
        merchantBusinessType: _merchantBusinessType,
        selectedCountry: _selectedCountry,
        selectedCity: _selectedCity,
        selectedArea: _selectedArea,
        mapLatitude: _mapLatitude,
        mapLongitude: _mapLongitude,
        onCountryChanged: (country) {
          setState(() {
            _selectedCountry = country;
            _selectedCity = null;
          });
        },
        onCityChanged: _onCityChanged,
        onAreaChanged: (area) => setState(() => _selectedArea = area),
        onMerchantTypeChanged: (type) {
          setState(() => _merchantBusinessType = type);
        },
        onPickMapLocation: _openMapPicker,
        onClearMapLocation: (_mapLatitude != null || _mapLongitude != null)
            ? () => setState(() {
                  _mapLatitude = null;
                  _mapLongitude = null;
                })
            : null,
        onSave: _submit,
      ),
    );
  }
}
