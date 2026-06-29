import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/city/domain/entities/city_entity.dart';
import 'package:jeeb_admin/features/city/presentation/bloc/city_bloc.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';
import 'package:jeeb_admin/features/country/presentation/bloc/country_bloc.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/helpful_functions/merchant_form_location_defaults.dart';

/// On add-merchant, selects Syria and Ar-Raqqah once country/city lists load.
class MerchantFormAddDefaultsListener extends StatelessWidget {
  final bool enabled;
  final CountryEntity? selectedCountry;
  final CityEntity? selectedCity;
  final ValueChanged<CountryEntity> onCountrySelected;
  final ValueChanged<CityEntity> onCitySelected;
  final Widget child;

  const MerchantFormAddDefaultsListener({
    super.key,
    required this.enabled,
    required this.selectedCountry,
    required this.selectedCity,
    required this.onCountrySelected,
    required this.onCitySelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CountryBloc, CountryState>(
          listener: (context, state) {
            if (!enabled || selectedCountry != null) return;
            if (state is! CountryLoaded) return;
            final syria = findSyriaCountry(state.countries);
            if (syria != null) onCountrySelected(syria);
          },
        ),
        BlocListener<CityBloc, CityState>(
          listener: (context, state) {
            if (!enabled || selectedCity != null) return;
            if (state is! CityLoaded) return;
            final raqqah = findRaqqahCity(state.cities);
            if (raqqah != null) onCitySelected(raqqah);
          },
        ),
      ],
      child: child,
    );
  }
}
