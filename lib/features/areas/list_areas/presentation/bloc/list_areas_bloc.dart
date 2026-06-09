import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/areas/list_areas/data/repositories/list_areas_repository.dart';
import 'package:jeeb_admin/features/areas/list_areas/domain/entities/area_entity.dart';

part 'list_areas_event.dart';
part 'list_areas_state.dart';

class ListAreasBloc extends Bloc<ListAreasEvent, ListAreasState> {
  final ListAreasRepository _repository;
  static const int _pageSize = 20;

  ListAreasBloc(this._repository) : super(const ListAreasInitial()) {
    on<ListAreasEvent>((event, emit) async {
      if (event is GetAreasEvent) {
        if (event.loadMore) {
          final currentState = state;
          if (currentState is! ListAreasLoaded) return;
          if (!currentState.hasMore ||
              currentState.isLoadingMore ||
              currentState.isRefreshing) {
            return;
          }

          emit(currentState.copyWith(isLoadingMore: true));

          final nextPage = currentState.currentPage + 1;
          final result = await _repository.getAreas(
            page: nextPage,
            limit: _pageSize,
            search: currentState.search,
          );

          result.fold(
            (failure) => emit(currentState.copyWith(isLoadingMore: false)),
            (areas) {
              final updatedAreas = [
                ...currentState.areas,
                ...areas,
              ];
              emit(ListAreasLoaded(
                areas: updatedAreas,
                hasMore: areas.length >= _pageSize,
                currentPage: nextPage,
                search: currentState.search,
                isLoadingMore: false,
                isRefreshing: false,
              ));
            },
          );
        } else {
          final previous = state;
          if (previous is ListAreasLoaded) {
            emit(previous.copyWith(isRefreshing: true));
          } else {
            emit(const ListAreasLoading());
          }

          final result = await _repository.getAreas(
            page: 1,
            limit: _pageSize,
            search: event.search,
          );

          result.fold(
            (failure) {
              if (previous is ListAreasLoaded) {
                emit(previous.copyWith(isRefreshing: false));
              } else {
                emit(ListAreasError(message: failure.message));
              }
            },
            (areas) => emit(ListAreasLoaded(
              areas: areas,
              hasMore: areas.length >= _pageSize,
              currentPage: 1,
              search: event.search,
              isLoadingMore: false,
              isRefreshing: false,
            )),
          );
        }
      }
    });
  }
}
