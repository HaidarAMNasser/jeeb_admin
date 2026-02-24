import 'package:fatoorahapp/core/classes/entities/city_entity.dart';
import 'package:fatoorahapp/core/classes/entities/country_entity.dart';
import 'package:fatoorahapp/core/classes/entities/region_entity.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/city/presentation/blocs/city_bloc.dart';
import 'package:fatoorahapp/feature/country/presentation/blocs/country_bloc.dart';
import 'package:fatoorahapp/feature/region/presentation/blocs/region_bloc.dart';
import 'package:fatoorahapp/widgets/custom_paginated_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminCountryCityRegion extends StatefulWidget {
  final Function(CityEntity?) onSelectCity;
  final Function(CountryEntity?) onSelectCountry;
  final Function(RegionEntity?) onSelectRegion;
  final String country;
  final String countryId;
  final String region;
  final String city;

  const AdminCountryCityRegion({
    super.key,
    required this.onSelectCity,
    required this.onSelectCountry,
    required this.onSelectRegion,
    required this.country,
    required this.countryId,
    required this.region,
    required this.city,
  });

  @override
  State<AdminCountryCityRegion> createState() => _AdminCountryCityRegionState();
}

class _AdminCountryCityRegionState extends State<AdminCountryCityRegion> {
  Key regionKey = UniqueKey();
  Key cityKey = UniqueKey();

  String? currentRegion;
  String? currentCity;

  @override
  void initState() {
    super.initState();
    currentRegion = widget.region.isNotEmpty ? widget.region : null;
    currentCity = widget.city.isNotEmpty ? widget.city : null;
  }

  @override
  void didUpdateWidget(covariant AdminCountryCityRegion oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If parent updates country (e.g., after prefill), reset dependent keys
    if (widget.country != oldWidget.country) {
      setState(() {
        regionKey = UniqueKey();
        cityKey = UniqueKey();
        currentRegion = widget.region.isNotEmpty ? widget.region : null;
        currentCity = widget.city.isNotEmpty ? widget.city : null;
      });
    }
    // Sync region value if parent prefilled/changed it
    if (widget.region != oldWidget.region) {
      setState(() {
        currentRegion = widget.region.isNotEmpty ? widget.region : null;
      });
    }
    // Sync city value if parent prefilled/changed it
    if (widget.city != oldWidget.city) {
      setState(() {
        currentCity = widget.city.isNotEmpty ? widget.city : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountriesBloc, CountriesState>(
      builder: (context, countriesState) {
        return BlocBuilder<RegionsBloc, RegionsState>(
          builder: (context, regionState) {
            return Column(
              children: [
                AdminCountriesWidget(
                  initOption: widget.country.isNotEmpty ? widget.country : null,
                  onCountrySelection: (c) {
                    widget.onSelectCountry(c);
                    setState(() {
                      currentRegion = null;
                      currentCity = null;
                      regionKey = UniqueKey();
                      cityKey = UniqueKey();
                      widget.onSelectRegion(null);
                      widget.onSelectCity(null);
                    });
                    if (countriesState is CountriesSuccessState &&
                        countriesState.isFiltered != null &&
                        countriesState.isFiltered == true) {
                      context.read<CountriesBloc>().add(
                        FetchCountries(withLoading: true, isFiltered: false),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSize.s10),
                AdminRegionWidget(
                  key: regionKey,
                  initOption: currentRegion,
                  onRegionSelection: (r) {
                    widget.onSelectRegion(r);
                    setState(() {
                      currentCity = null;
                      cityKey = UniqueKey();
                      widget.onSelectCity(null);
                    });
                  },
                ),
                const SizedBox(height: AppSize.s10),
                AdminCitiesWidget(
                  key: cityKey,
                  initOption: currentCity,
                  onCitySelection: (c) {
                    widget.onSelectCity(c);
                    setState(() {
                      currentCity = c?.name ?? "";
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// Custom Country Widget for Admin (Not Required)
class AdminCountriesWidget extends StatelessWidget {
  final Function(CountryEntity?) onCountrySelection;
  final String? initOption;
  final bool? isReadOnly;

  const AdminCountriesWidget({
    super.key,
    required this.onCountrySelection,
    this.initOption,
    this.isReadOnly,
  });

  @override
  Widget build(BuildContext context) {
    // Create a custom dropdown that looks like the existing one but is not required
    return BlocBuilder<CountriesBloc, CountriesState>(
      builder: (context, state) {
        final List<CountryEntity> countriesList = state is CountriesSuccessState
            ? state.countries
            : [];
        final bool isLoadingMore = state is CountriesSuccessState
            ? state.isLoadingMore
            : false;
        final bool isFiltered = state is CountriesSuccessState
            ? state.isFiltered ?? false
            : false;
        final bool hasMoreData = state is CountriesSuccessState
            ? !state.hasReachedMax
            : true;

        return CustomPaginatedDropDown(
          isFiltered: isFiltered,
          showFtechButton: true,
          searchBorderColor: state is CountriesSuccessState
              ? ColorManager.primaryColor
              : null,
          isReadOnly: isReadOnly,
          withSearch: true,
          initOption: initOption,
          isSuccess: state is CountriesSuccessState,
          isLoading: state is CountriesLoadingState,
          isError: state is CountriesErrorState,
          title: TranslationsController.instance.getTranslations().country,
          color: ColorManager.white,
          isRequired: false, // NOT REQUIRED for admin
          hintText: TranslationsController.instance.getTranslations().country,
          dropDownList: countriesList,
          onFetchingData: () {
            BlocProvider.of<CountriesBloc>(
              context,
            ).add(FetchCountries(withLoading: true));
          },
          withApiPagination: true,
          isLoadingMore: isLoadingMore,
          hasMoreData: hasMoreData,
          onLoadMoreApi: () async {
            if (!isLoadingMore && hasMoreData) {
              context.read<CountriesBloc>().add(LoadMoreCountries());
            }
          },
          onSearchChangedApi: (query) {
            context.read<CountriesBloc>().add(
              FetchCountries(searchText: query, isFiltered: true),
            );
          },
          onSelectItem: (val) {
            if (val != null) {
              onCountrySelection(val);
            }
          },
        );
      },
    );
  }
}

// Custom Region Widget for Admin (Not Required)
class AdminRegionWidget extends StatelessWidget {
  final Function(RegionEntity?) onRegionSelection;
  final String? initOption;
  final bool? isReadOnly;

  const AdminRegionWidget({
    super.key,
    required this.onRegionSelection,
    this.initOption,
    this.isReadOnly,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegionsBloc, RegionsState>(
      builder: (context, state) {
        final List<RegionEntity> regionsList = state is RegionsSuccessState
            ? state.regions
            : [];
        final bool isLoadingMore = state is RegionsSuccessState
            ? state.isLoadingMore
            : false;
        final bool hasMoreData = state is RegionsSuccessState
            ? !state.hasReachedMax
            : true;

        return CustomPaginatedDropDown(
          showFtechButton: true,
          searchBorderColor: state is RegionsSuccessState
              ? ColorManager.primaryColor
              : null,
          isReadOnly: isReadOnly,
          withSearch: true,
          initOption: initOption,
          isSuccess: state is RegionsSuccessState,
          isLoading: state is RegionsLoadingState,
          isError: state is RegionsErrorState,
          title: TranslationsController.instance.getTranslations().region,
          color: ColorManager.white,
          isRequired: false, // NOT REQUIRED for admin
          hintText:
              TranslationsController.instance.getTranslations().region + '...',
          dropDownList: regionsList,
          onFetchingData: () {
            // This will be triggered when the dropdown is opened
            // The actual fetching should be triggered by country selection
          },
          withApiPagination: true,
          isLoadingMore: isLoadingMore,
          hasMoreData: hasMoreData,
          onLoadMoreApi: () async {
            if (!isLoadingMore && hasMoreData) {
              context.read<RegionsBloc>().add(LoadMoreRegions());
            }
          },
          onSearchChangedApi: (query) {
            // Search functionality if needed
          },
          onSelectItem: (val) {
            if (val != null) {
              onRegionSelection(val);
            }
          },
        );
      },
    );
  }
}

// Custom Cities Widget for Admin (Not Required)
class AdminCitiesWidget extends StatelessWidget {
  final Function(CityEntity?) onCitySelection;
  final String? initOption;
  final bool? isReadOnly;

  const AdminCitiesWidget({
    super.key,
    required this.onCitySelection,
    this.initOption,
    this.isReadOnly,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitiesBloc, CitiesState>(
      builder: (context, state) {
        final List<CityEntity> citiesList = state is CitiesSuccessState
            ? state.cities
            : [];
        final bool isLoadingMore = state is CitiesSuccessState
            ? state.isLoadingMore
            : false;
        final bool hasMoreData = state is CitiesSuccessState
            ? !state.hasReachedMax
            : true;

        return CustomPaginatedDropDown(
          showFtechButton: true,
          searchBorderColor: state is CitiesSuccessState
              ? ColorManager.primaryColor
              : null,
          isReadOnly: isReadOnly,
          withSearch: true,
          initOption: initOption,
          isSuccess: state is CitiesSuccessState,
          isLoading: state is CitiesLoadingState,
          isError: state is CitiesErrorState,
          title: TranslationsController.instance.getTranslations().city,
          color: ColorManager.white,
          isRequired: false, // NOT REQUIRED for admin
          hintText:
              TranslationsController.instance.getTranslations().city + '...',
          dropDownList: citiesList,
          onFetchingData: () {
            // This will be triggered when the dropdown is opened
            // The actual fetching should be triggered by region selection
          },
          withApiPagination: true,
          isLoadingMore: isLoadingMore,
          hasMoreData: hasMoreData,
          onLoadMoreApi: () async {
            if (!isLoadingMore && hasMoreData) {
              context.read<CitiesBloc>().add(LoadMoreCities());
            }
          },
          onSearchChangedApi: (query) {
            // Search functionality if needed
          },
          onSelectItem: (val) {
            if (val != null) {
              onCitySelection(val);
            }
          },
        );
      },
    );
  }
}
