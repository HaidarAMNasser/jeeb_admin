import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/data/repositories/list_delivery_repository.dart';

part 'list_delivery_event.dart';
part 'list_delivery_state.dart';

class ListDeliveryBloc extends Bloc<ListDeliveryEvent, ListDeliveryState> {
  final ListDeliveryRepository _repository;
  static const int _pageSize = 20;

  ListDeliveryBloc(this._repository) : super(const ListDeliveryInitial()) {
    on<ListDeliveryEvent>((event, emit) async {
      if (event is GetDeliveryMenEvent) {
        if (event.loadMore) {
          final currentState = state;
          if (currentState is ListDeliveryLoaded) {
            emit(ListDeliveryLoadingMore(
              deliveryMen: currentState.deliveryMen,
              currentPage: currentState.currentPage,
            ));

            final nextPage = currentState.currentPage + 1;
            final result = await _repository.getDeliveryMen(
              page: nextPage,
              limit: _pageSize,
              search: event.search,
            );

            result.fold(
              (failure) => emit(ListDeliveryError(message: failure.message)),
              (newDeliveryMen) {
                final updated = [
                  ...currentState.deliveryMen,
                  ...newDeliveryMen,
                ];
                emit(ListDeliveryLoaded(
                  deliveryMen: updated,
                  hasMore: newDeliveryMen.length == _pageSize,
                  currentPage: nextPage,
                ));
              },
            );
          }
        } else {
          emit(const ListDeliveryLoading());
          final result = await _repository.getDeliveryMen(
            page: 1,
            limit: _pageSize,
            search: event.search,
          );

          result.fold(
            (failure) => emit(ListDeliveryError(message: failure.message)),
            (deliveryMen) => emit(ListDeliveryLoaded(
              deliveryMen: deliveryMen,
              hasMore: deliveryMen.length == _pageSize,
              currentPage: 1,
            )),
          );
        }
      }
    });
  }
}
