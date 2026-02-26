import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/bloc/list_merchant_bloc.dart';

class SearchMerchantWidget extends StatefulWidget {
  const SearchMerchantWidget({super.key});

  @override
  State<SearchMerchantWidget> createState() => _SearchMerchantWidgetState();
}

class _SearchMerchantWidgetState extends State<SearchMerchantWidget> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    // Listen to controller changes to update clear button visibility
    _searchController.addListener(() {
      setState(() {});
    });
    // Listen to BLoC state to sync search controller
    _syncSearchController();
  }

  void _syncSearchController() {
    final state = context.read<ListMerchantBloc>().state;
    String? currentSearch;
    if (state is ListMerchantLoaded) {
      currentSearch = state.search;
    } else if (state is ListMerchantLoadingMore) {
      currentSearch = state.search;
    }
    
    final stateSearch = currentSearch ?? '';
    if (_searchController.text != stateSearch) {
      _searchController.text = stateSearch;
    }
  }

  void _onSearchChanged(String query) {
    // Cancel previous timer
    _searchDebounce?.cancel();

    // Debounce search - search after user stops typing for 500ms
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text == query && mounted) {
        context.read<ListMerchantBloc>().add(
          GetMerchantsEvent(search: query.isEmpty ? null : query),
        );
      }
    });
  }

  void _onClearSearch() {
    _searchController.clear();
    context.read<ListMerchantBloc>().add(
      const GetMerchantsEvent(),
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListMerchantBloc, ListMerchantState>(
      builder: (context, state) {
        // Sync search controller with state
        String? currentSearch;
        if (state is ListMerchantLoaded) {
          currentSearch = state.search;
        } else if (state is ListMerchantLoadingMore) {
          currentSearch = state.search;
        }

        final stateSearch = currentSearch ?? '';
        if (_searchController.text != stateSearch) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _searchController.text = stateSearch;
            }
          });
        }

        return Padding(
          padding: EdgeInsets.all(AppPadding.p16),
          child: CustomTextField(
            title: AppTranslation.searchMerchants,
            hintText: AppTranslation.searchMerchantsHint,
            controller: _searchController,
            onChanged: _onSearchChanged,
            prefixIcon: Icon(
              Icons.search,
              color: ColorManager.primary,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: ColorManager.descriptionColor,
                    ),
                    onPressed: _onClearSearch,
                  )
                : null,
          ),
        );
      },
    );
  }
}

