import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/order/order_cancel/data/repositories/order_cancel_repository.dart';

part 'order_cancel_event.dart';
part 'order_cancel_state.dart';

class OrderCancelBloc extends Bloc<OrderCancelEvent, OrderCancelState> {
  final OrderCancelRepository _repository;

  OrderCancelBloc(this._repository) : super(const OrderCancelInitial()) {
    on<OrderCancelEvent>((event, emit) async {
      if (event is CancelOrderEvent) {
        emit(const OrderCancelLoading());
        final result = await _repository.cancelOrder(event.id);

        result.fold(
          (failure) => emit(OrderCancelError(message: failure.message)),
          (_) => emit(const OrderCancelSuccess()),
        );
      }
    });
  }
}

