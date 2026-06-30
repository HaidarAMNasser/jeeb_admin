import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_search_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/bloc/list_merchant_bloc.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/merchants_filter_button.dart';

class SearchMerchantWidget extends StatefulWidget {
  const SearchMerchantWidget({super.key});

  @override
  State<SearchMerchantWidget> createState() => _SearchMerchantWidgetState();
}

class _SearchMerchantWidgetState extends State<SearchMerchantWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refetch() {
    final state = context.read<ListMerchantBloc>().state;
    final loaded = state is ListMerchantLoaded ? state : null;
    context.read<ListMerchantBloc>().add(
          GetMerchantsEvent(isActiveFilter: loaded?.isActiveFilter),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListMerchantBloc, ListMerchantState>(
      listenWhen: (prev, curr) {
        if (curr is! ListMerchantLoaded) return false;
        if (prev is! ListMerchantLoaded) {
          return curr.search == null || curr.search!.isEmpty;
        }
        final hadSearch = prev.search != null && prev.search!.trim().isNotEmpty;
        final noSearch = curr.search == null || curr.search!.trim().isEmpty;
        return hadSearch && noSearch;
      },
      listener: (_, __) => _searchController.clear(),
      child: CustomSearchField(
        hintText: AppTranslation.searchMerchantsHint,
        controller: _searchController,
        showTrailingRefetch: false,
        trailingAction: const MerchantsFilterButton(),
        onSubmitted: (query) {
          final state = context.read<ListMerchantBloc>().state;
          final loaded = state is ListMerchantLoaded ? state : null;
          context.read<ListMerchantBloc>().add(
                GetMerchantsEvent(
                  search: query.isEmpty ? null : query,
                  isActiveFilter: loaded?.isActiveFilter,
                ),
              );
        },
        onRefetch: _refetch,
      ),
    );
  }
}
