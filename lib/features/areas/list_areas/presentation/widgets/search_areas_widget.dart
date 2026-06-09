import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_search_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/areas/list_areas/presentation/bloc/list_areas_bloc.dart';

class SearchAreasWidget extends StatefulWidget {
  final String? initialSearch;

  const SearchAreasWidget({super.key, this.initialSearch});

  @override
  State<SearchAreasWidget> createState() => _SearchAreasWidgetState();
}

class _SearchAreasWidgetState extends State<SearchAreasWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialSearch != null && widget.initialSearch!.isNotEmpty) {
      _searchController.text = widget.initialSearch!;
    }
  }

  @override
  void didUpdateWidget(SearchAreasWidget oldWidget) {
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
      hintText: AppTranslation.searchAreasHint,
      controller: _searchController,
      onSubmitted: (query) {
        context.read<ListAreasBloc>().add(
              GetAreasEvent(
                search: query.isEmpty ? null : query,
              ),
            );
      },
      onRefetch: () {
        context.read<ListAreasBloc>().add(const GetAreasEvent());
      },
    );
  }
}
