import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/category/list_category/data/repositories/list_category_repository.dart';
import 'package:jeeb_admin/features/category/list_category/domain/entities/category_entity.dart';

part 'list_category_event.dart';
part 'list_category_state.dart';

class ListCategoryBloc extends Bloc<ListCategoryEvent, ListCategoryState> {
  final ListCategoryRepository _repository;
  static const int _pageSize = 20;
  static const int _fullListLimit = 500;

  ListCategoryBloc(this._repository) : super(const ListCategoryInitial()) {
    on<ListCategoryEvent>((event, emit) async {
      if (event is GetCategoriesEvent) {
        if (event.fullList) {
          emit(const ListCategoryLoading());
          final result = await _repository.getCategories(
            page: 1,
            limit: _fullListLimit,
          );
          result.fold(
            (failure) => emit(ListCategoryError(message: failure.message)),
            (categories) => emit(ListCategoryLoaded(
              categories: categories,
              hasMore: false,
              currentPage: 1,
              isLoadingMore: false,
              isRefreshing: false,
              search: null,
            )),
          );
          return;
        }

        if (event.loadMore) {
          final currentState = state;
          if (currentState is! ListCategoryLoaded) return;
          if (!currentState.hasMore ||
              currentState.isLoadingMore ||
              currentState.isRefreshing) {
            return;
          }

          emit(currentState.copyWith(isLoadingMore: true));

          final nextPage = currentState.currentPage + 1;
          final result = await _repository.getCategories(
            page: nextPage,
            limit: _pageSize,
            search: currentState.search,
          );

          result.fold(
            (failure) => emit(currentState.copyWith(isLoadingMore: false)),
            (categories) {
              final updatedCategories = [
                ...currentState.categories,
                ...categories,
              ];
              emit(ListCategoryLoaded(
                categories: updatedCategories,
                hasMore: categories.length >= _pageSize,
                currentPage: nextPage,
                search: currentState.search,
                isLoadingMore: false,
                isRefreshing: false,
              ));
            },
          );
        } else {
          final previous = state;
          if (previous is ListCategoryLoaded) {
            emit(previous.copyWith(isRefreshing: true));
          } else {
            emit(const ListCategoryLoading());
          }

          final result = await _repository.getCategories(
            page: 1,
            limit: _pageSize,
            search: event.search,
          );

          result.fold(
            (failure) {
              if (previous is ListCategoryLoaded) {
                emit(previous.copyWith(isRefreshing: false));
              } else {
                emit(ListCategoryError(message: failure.message));
              }
            },
            (categories) => emit(ListCategoryLoaded(
              categories: categories,
              hasMore: categories.length >= _pageSize,
              currentPage: 1,
              isLoadingMore: false,
              isRefreshing: false,
              search: event.search,
            )),
          );
        }
      }
    });
  }
}
