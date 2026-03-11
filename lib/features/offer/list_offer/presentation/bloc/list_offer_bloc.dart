import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/offer/list_offer/domain/entities/offer_entity.dart';
import 'package:jeeb_admin/features/offer/list_offer/data/repositories/list_offer_repository.dart';

part 'list_offer_event.dart';
part 'list_offer_state.dart';

class ListOfferBloc extends Bloc<ListOfferEvent, ListOfferState> {
  final ListOfferRepository _repository;
  static const int _pageSize = 20;

  ListOfferBloc(this._repository) : super(const ListOfferInitial()) {
    on<ListOfferEvent>((event, emit) async {
      if (event is GetOffersEvent) {
        if (event.loadMore) {
          final currentState = state;
          if (currentState is ListOfferLoaded) {
            emit(ListOfferLoadingMore(
              offers: currentState.offers,
              currentPage: currentState.currentPage,
            ));
            final nextPage = currentState.currentPage + 1;
            final result = await _repository.getOffers(
              page: nextPage,
              limit: _pageSize,
              merchantId: currentState.merchantId,
            );
            result.fold(
              (failure) => emit(ListOfferError(message: failure.message)),
              (offers) => emit(ListOfferLoaded(
                offers: [...currentState.offers, ...offers],
                hasMore: offers.length == _pageSize,
                currentPage: nextPage,
                merchantId: currentState.merchantId,
              )),
            );
          }
        } else {
          emit(const ListOfferLoading());
          final result = await _repository.getOffers(
            page: 1,
            limit: _pageSize,
            merchantId: event.merchantId,
          );
          result.fold(
            (failure) => emit(ListOfferError(message: failure.message)),
            (offers) => emit(ListOfferLoaded(
              offers: offers,
              hasMore: offers.length == _pageSize,
              currentPage: 1,
              merchantId: event.merchantId,
            )),
          );
        }
      }
    });
  }
}
