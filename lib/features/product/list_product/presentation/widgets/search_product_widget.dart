import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_search_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/bloc/list_product_bloc.dart';

class SearchProductWidget extends StatefulWidget {
  final String? merchantId;
  /// Current search from bloc state; keeps the field in sync so text doesn't disappear after search.
  final String? initialSearch;

  const SearchProductWidget({super.key, this.merchantId, this.initialSearch});

  @override
  State<SearchProductWidget> createState() => _SearchProductWidgetState();
}

class _SearchProductWidgetState extends State<SearchProductWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialSearch != null && widget.initialSearch!.isNotEmpty) {
      _searchController.text = widget.initialSearch!;
    }
  }

  @override
  void didUpdateWidget(SearchProductWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSearch != oldWidget.initialSearch) {
      _searchController.text = widget.initialSearch ?? '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSearchField(
      hintText: AppTranslation.searchProductsHint,
      controller: _searchController,
      onSubmitted: (query) {
        final merchantId = widget.merchantId ??
            (context.read<ListProductBloc>().state is ListProductLoaded
                ? (context.read<ListProductBloc>().state as ListProductLoaded).merchantId
                : null);
        context.read<ListProductBloc>().add(
              GetProductsEvent(
                merchantId: merchantId ?? '0',
                search: query.isEmpty ? null : query,
              ),
            );
      },
      onRefetch: () {
        final merchantId = widget.merchantId ??
            (context.read<ListProductBloc>().state is ListProductLoaded
                ? (context.read<ListProductBloc>().state as ListProductLoaded).merchantId
                : null);
        context.read<ListProductBloc>().add(
              GetProductsEvent(merchantId: merchantId ?? '0'),
            );
      },
    );
  }
}
