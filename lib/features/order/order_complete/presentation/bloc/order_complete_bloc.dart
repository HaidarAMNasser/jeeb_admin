import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/order/order_complete/data/repositories/order_complete_repository.dart';

part 'order_complete_event.dart';
part 'order_complete_state.dart';

class OrderCompleteBloc extends Bloc<OrderCompleteEvent, OrderCompleteState> {
  final OrderCompleteRepository _repository;

  OrderCompleteBloc(this._repository) : super(const OrderCompleteInitial()) {
    on<OrderCompleteEvent>((event, emit) async {
      if (event is CompleteOrderEvent) {
        emit(const OrderCompleteLoading());
        final result = await _repository.completeOrder(event.id);

        result.fold(
          (failure) => emit(OrderCompleteError(message: failure.message)),
          (_) => emit(const OrderCompleteSuccess()),
        );
      }
    });
  }
}

