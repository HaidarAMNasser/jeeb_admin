import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_search_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/bloc/list_order_bloc.dart';

class SearchOrderWidget extends StatefulWidget {
  const SearchOrderWidget({super.key});

  @override
  State<SearchOrderWidget> createState() => _SearchOrderWidgetState();
}

class _SearchOrderWidgetState extends State<SearchOrderWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refetch() {
    final state = context.read<ListOrderBloc>().state;
    final merchantId = state is ListOrderLoaded ? state.merchantId : null;
    context.read<ListOrderBloc>().add(
          GetOrdersEvent(search: null, merchantId: merchantId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return CustomSearchField(
      hintText: AppTranslation.searchOrdersHint,
      controller: _searchController,
      onSubmitted: (query) {
        final state = context.read<ListOrderBloc>().state;
        final merchantId = state is ListOrderLoaded ? state.merchantId : null;
        context.read<ListOrderBloc>().add(
              GetOrdersEvent(search: query.isEmpty ? null : query, merchantId: merchantId),
            );
      },
      onRefetch: _refetch,
    );
  }
}
