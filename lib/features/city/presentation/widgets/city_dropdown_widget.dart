import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_paginated_dropdown.dart';
import 'package:jeeb_admin/features/city/domain/entities/city_entity.dart';
import 'package:jeeb_admin/features/city/presentation/bloc/city_bloc.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';

class CityDropdownWidget extends StatefulWidget {
  final CountryEntity? selectedCountry;
  final CityEntity? selectedCity;
  final ValueChanged<CityEntity?> onSelectCity;
  final bool isRequired;

  const CityDropdownWidget({
    super.key,
    required this.selectedCountry,
    required this.selectedCity,
    required this.onSelectCity,
    this.isRequired = false,
  });

  @override
  State<CityDropdownWidget> createState() => _CityDropdownWidgetState();
}

class _CityDropdownWidgetState extends State<CityDropdownWidget> {
  @override
  void initState() {
    super.initState();
    _loadCitiesIfNeeded();
  }

  @override
  void didUpdateWidget(CityDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCountry?.id != oldWidget.selectedCountry?.id) {
      _loadCitiesIfNeeded(reset: true);
    }
  }

  void _loadCitiesIfNeeded({bool reset = false}) {
    final country = widget.selectedCountry;
    if (reset) {
      context.read<CityBloc>().add(const ResetCities());
    }
    if (country != null) {
      context.read<CityBloc>().add(
            LoadCities(countryId: country.id, withLoading: true),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = context.locale.languageCode == 'ar';
    final country = widget.selectedCountry;

    if (country == null) {
      return CustomPaginatedDropdown<CityEntity>(
        title: AppTranslation.selectCity,
        hintText: AppTranslation.pleaseSelectCountryFirst,
        items: const [],
        selectedItem: null,
        displayText: (city) => isRTL ? city.name.ar : city.name.en,
        onChanged: widget.onSelectCity,
        isLoading: false,
        isLoadingMore: false,
        hasMoreData: false,
        isError: false,
        isRequired: widget.isRequired,
        isReadOnly: true,
      );
    }

    return BlocBuilder<CityBloc, CityState>(
      builder: (context, state) {
        List<CityEntity> cities = [];
        var isLoading = false;
        var isLoadingMore = false;
        var hasMoreData = true;
        var isError = false;
        String? errorMessage;

        if (state is CityLoading) {
          isLoading = true;
        } else if (state is CityError) {
          isError = true;
          errorMessage = state.message;
        } else if (state is CityLoaded) {
          cities = state.cities;
          isLoadingMore = state.isLoadingMore;
          hasMoreData = !state.hasReachedMax;
        }

        return CustomPaginatedDropdown<CityEntity>(
          title: AppTranslation.selectCity,
          hintText: cities.isEmpty
              ? AppTranslation.noCitiesAvailable
              : AppTranslation.selectCity,
          items: cities,
          selectedItem: widget.selectedCity,
          displayText: (city) => isRTL ? city.name.ar : city.name.en,
          onChanged: widget.onSelectCity,
          onLoadMore: () {
            if (!isLoadingMore && hasMoreData) {
              context.read<CityBloc>().add(const LoadMoreCities());
            }
          },
          isLoading: isLoading,
          isLoadingMore: isLoadingMore,
          hasMoreData: hasMoreData,
          isError: isError,
          errorMessage: errorMessage,
          isRequired: widget.isRequired,
        );
      },
    );
  }
}
