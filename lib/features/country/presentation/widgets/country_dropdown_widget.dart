import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_paginated_dropdown.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';
import 'package:jeeb_admin/features/country/presentation/bloc/country_bloc.dart';

class CountryDropdownWidget extends StatefulWidget {
  final CountryEntity? selectedCountry;
  final ValueChanged<CountryEntity?> onSelectCountry;
  final bool isRequired;

  const CountryDropdownWidget({
    super.key,
    required this.selectedCountry,
    required this.onSelectCountry,
    this.isRequired = false,
  });

  @override
  State<CountryDropdownWidget> createState() => _CountryDropdownWidgetState();
}

class _CountryDropdownWidgetState extends State<CountryDropdownWidget> {
  @override
  void initState() {
    super.initState();
    context.read<CountryBloc>().add(const LoadCountries(withLoading: true));
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = context.locale.languageCode == 'ar';

    return BlocBuilder<CountryBloc, CountryState>(
      builder: (context, state) {
        List<CountryEntity> countries = [];
        var isLoading = false;
        var isLoadingMore = false;
        var hasMoreData = true;
        var isError = false;
        String? errorMessage;

        if (state is CountryLoading) {
          isLoading = true;
        } else if (state is CountryError) {
          isError = true;
          errorMessage = state.message;
        } else if (state is CountryLoaded) {
          countries = state.countries;
          isLoadingMore = state.isLoadingMore;
          hasMoreData = !state.hasReachedMax;
        }

        return CustomPaginatedDropdown<CountryEntity>(
          title: AppTranslation.selectCountry,
          hintText: AppTranslation.selectCountry,
          items: countries,
          selectedItem: widget.selectedCountry,
          displayText: (country) => isRTL ? country.name.ar : country.name.en,
          onChanged: widget.onSelectCountry,
          onLoadMore: () {
            if (!isLoadingMore && hasMoreData) {
              context.read<CountryBloc>().add(const LoadMoreCountries());
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
