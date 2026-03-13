import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_search_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

class SearchOfferWidget extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String query) onSearchChanged;

  const SearchOfferWidget({
    super.key,
    required this.controller,
    required this.onSearchChanged,
  });

  @override
  State<SearchOfferWidget> createState() => _SearchOfferWidgetState();
}

class _SearchOfferWidgetState extends State<SearchOfferWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomSearchField(
      hintText: AppTranslation.searchOffersHint,
      controller: widget.controller,
      onSubmitted: (query) => widget.onSearchChanged(query),
      onRefetch: () {
        widget.controller.clear();
        widget.onSearchChanged('');
      },
    );
  }
}
