import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/domain/entities/merchant_entity.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/data/repositories/list_merchant_repository.dart';

part 'list_merchant_event.dart';
part 'list_merchant_state.dart';

class ListMerchantBloc extends Bloc<ListMerchantEvent, ListMerchantState> {
  final ListMerchantRepository _repository;
  static const int _pageSize = 20;

  ListMerchantBloc(this._repository) : super(const ListMerchantInitial()) {
    on<ListMerchantEvent>((event, emit) async {
      if (event is GetMerchantsEvent) {
        if (event.loadMore) {
          final currentState = state;
          if (currentState is! ListMerchantLoaded) return;
          if (!currentState.hasMore || currentState.isLoadingMore) return;

          final searchQuery = event.search ?? currentState.search;
          emit(currentState.copyWith(isLoadingMore: true));

          final nextPage = currentState.currentPage + 1;
          final result = await _repository.getMerchants(
            page: nextPage,
            limit: _pageSize,
            search: searchQuery,
          );

          result.fold(
            (failure) => emit(currentState.copyWith(isLoadingMore: false)),
            (newMerchants) {
              final updatedMerchants = [
                ...currentState.merchants,
                ...newMerchants,
              ];
              emit(ListMerchantLoaded(
                merchants: updatedMerchants,
                hasMore: newMerchants.length >= _pageSize,
                currentPage: nextPage,
                search: searchQuery,
                isLoadingMore: false,
              ));
            },
          );
        } else {
          // Initial load or refresh
          emit(const ListMerchantLoading());
          final result = await _repository.getMerchants(
            page: 1,
            limit: _pageSize,
            search: event.search,
          );

          result.fold(
            (failure) => emit(ListMerchantError(message: failure.message)),
            (merchants) => emit(ListMerchantLoaded(
              merchants: merchants,
              hasMore: merchants.length >= _pageSize,
              currentPage: 1,
              search: event.search,
              isLoadingMore: false,
            )),
          );
        }
      }
    });
  }
}

