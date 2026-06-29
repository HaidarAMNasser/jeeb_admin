import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_paginated_dropdown.dart';
import 'package:jeeb_admin/features/areas/list_areas/domain/entities/area_entity.dart';
import 'package:jeeb_admin/features/areas/list_areas/presentation/bloc/list_areas_bloc.dart';

class AreaDropdownWidget extends StatefulWidget {
  final void Function(AreaEntity?) onSelectArea;
  final AreaEntity? selectedArea;

  const AreaDropdownWidget({
    super.key,
    required this.onSelectArea,
    this.selectedArea,
  });

  @override
  State<AreaDropdownWidget> createState() => _AreaDropdownWidgetState();
}

class _AreaDropdownWidgetState extends State<AreaDropdownWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ListAreasBloc>().add(const GetAreasEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListAreasBloc, ListAreasState>(
      builder: (context, state) {
        List<AreaEntity> areas = [];
        var isLoading = false;
        var isLoadingMore = false;
        var hasMoreData = true;
        var isError = false;
        String? errorMessage;
        var isRefreshing = false;

        if (state is ListAreasLoading) {
          isLoading = true;
        } else if (state is ListAreasError) {
          isError = true;
          errorMessage = state.message;
        } else if (state is ListAreasLoaded) {
          areas = state.areas;
          isLoadingMore = state.isLoadingMore;
          isRefreshing = state.isRefreshing;
          hasMoreData = state.hasMore;
        }

        return CustomPaginatedDropdown<AreaEntity>(
          title: AppTranslation.selectArea,
          hintText: AppTranslation.selectArea,
          items: areas,
          selectedItem: widget.selectedArea,
          displayText: (area) => area.name,
          onChanged: widget.onSelectArea,
          onLoadMore: () {
            if (!isLoadingMore && hasMoreData && !isRefreshing) {
              context.read<ListAreasBloc>().add(const GetAreasEvent(loadMore: true));
            }
          },
          isLoading: isLoading,
          isLoadingMore: isLoadingMore,
          isBorderLoading: isLoadingMore || isRefreshing,
          hasMoreData: hasMoreData,
          isError: isError,
          errorMessage: errorMessage,
          enableSearch: true,
          searchHintText: AppTranslation.searchAreasHint,
          emptyMessage: AppTranslation.noAreasFound,
          onSearchChanged: (query) {
            context.read<ListAreasBloc>().add(
                  GetAreasEvent(search: query.isEmpty ? null : query),
                );
          },
        );
      },
    );
  }
}
