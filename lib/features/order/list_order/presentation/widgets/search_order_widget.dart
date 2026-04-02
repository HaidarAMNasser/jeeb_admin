import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_search_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/bloc/list_order_bloc.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/admin_orders_filter_bar.dart';

class SearchOrderWidget extends StatefulWidget {
  const SearchOrderWidget({
    super.key,
    this.showTrailingRefetch = true,
    this.showInlineFilterSlot = false,
  });

  /// Merchant: orange restart next to search.
  final bool showTrailingRefetch;

  /// Admin: filter/reset slot next to search (uses bloc [ListOrderLoaded.isFiltered]).
  final bool showInlineFilterSlot;

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
    final loaded = state is ListOrderLoaded ? state : null;
    context.read<ListOrderBloc>().add(
      GetOrdersEvent(
        search: null,
        merchantId: loaded?.merchantId,
        merchantTab: loaded?.merchantTab,
        statusFilter: loaded?.statusFilter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListOrderBloc, ListOrderState>(
      listenWhen: (prev, curr) {
        if (curr is! ListOrderLoaded) return false;
        if (prev is! ListOrderLoaded) {
          return curr.search == null || curr.search!.isEmpty;
        }
        final hadSearch = prev.search != null && prev.search!.trim().isNotEmpty;
        final noSearch = curr.search == null || curr.search!.trim().isEmpty;
        return hadSearch && noSearch;
      },
      listener: (_, __) => _searchController.clear(),
      child: CustomSearchField(
        hintText: AppTranslation.searchOrdersHint,
        controller: _searchController,
        showTrailingRefetch: widget.showTrailingRefetch,
        trailingAction: widget.showInlineFilterSlot
            ? const AdminOrdersFilterSlot()
            : null,
        onSubmitted: (query) {
          final state = context.read<ListOrderBloc>().state;
          final loaded = state is ListOrderLoaded ? state : null;
          context.read<ListOrderBloc>().add(
            GetOrdersEvent(
              search: query.isEmpty ? null : query,
              merchantId: loaded?.merchantId,
              merchantTab: loaded?.merchantTab,
              statusFilter: loaded?.statusFilter,
            ),
          );
        },
        onRefetch: _refetch,
      ),
    );
  }
}
