import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/product/list_product/data/repositories/list_product_repository.dart';

part 'list_product_event.dart';
part 'list_product_state.dart';

class ListProductBloc extends Bloc<ListProductEvent, ListProductState> {
  final ListProductRepository _repository;
  static const int _pageSize = 20;

  ListProductBloc(this._repository) : super(const ListProductInitial()) {
    on<ListProductEvent>((event, emit) async {
      if (event is GetProductsEvent) {
        if (event.loadMore) {
          final currentState = state;
          if (currentState is! ListProductLoaded) return;
          if (!currentState.hasMore ||
              currentState.isLoadingMore ||
              currentState.isRefreshing) {
            return;
          }

          emit(currentState.copyWith(isLoadingMore: true));

          final nextPage = currentState.currentPage + 1;
          final result = await _repository.getProducts(
            page: nextPage,
            limit: _pageSize,
            restaurantId: currentState.merchantId,
            search: currentState.search,
          );

          result.fold(
            (failure) => emit(currentState.copyWith(isLoadingMore: false)),
            (products) {
              final updatedProducts = [
                ...currentState.products,
                ...products,
              ];
              emit(ListProductLoaded(
                products: updatedProducts,
                hasMore: products.length >= _pageSize,
                currentPage: nextPage,
                merchantId: currentState.merchantId,
                search: currentState.search,
                isLoadingMore: false,
                isRefreshing: false,
              ));
            },
          );
        } else {
          final previous = state;
          if (previous is ListProductLoaded) {
            emit(previous.copyWith(isRefreshing: true));
          } else {
            emit(const ListProductLoading());
          }

          final result = await _repository.getProducts(
            page: 1,
            limit: _pageSize,
            restaurantId: event.merchantId,
            search: event.search,
          );

          result.fold(
            (failure) {
              if (previous is ListProductLoaded) {
                emit(previous.copyWith(isRefreshing: false));
              } else {
                emit(ListProductError(message: failure.message));
              }
            },
            (products) => emit(ListProductLoaded(
              products: products,
              hasMore: products.length >= _pageSize,
              currentPage: 1,
              merchantId: event.merchantId,
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
