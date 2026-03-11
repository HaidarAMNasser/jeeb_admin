import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_search_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/bloc/list_merchant_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return CustomSearchField(
      hintText: AppTranslation.searchMerchantsHint,
      controller: _searchController,
      onSubmitted: (query) {
        context.read<ListMerchantBloc>().add(
              GetMerchantsEvent(search: query.isEmpty ? null : query),
            );
      },
      onRefetch: () {
        context.read<ListMerchantBloc>().add(const GetMerchantsEvent());
      },
    );
  }
}
