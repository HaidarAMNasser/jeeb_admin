import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/order/confirm_paid_order/data/repositories/confirm_paid_order_repository.dart';

part 'confirm_paid_order_event.dart';
part 'confirm_paid_order_state.dart';

class ConfirmPaidOrderBloc
    extends Bloc<ConfirmPaidOrderEvent, ConfirmPaidOrderState> {
  final ConfirmPaidOrderRepository _repository;

  ConfirmPaidOrderBloc(this._repository)
      : super(const ConfirmPaidOrderInitial()) {
    on<ConfirmPaidOrderSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ConfirmPaidOrderSubmitted event,
    Emitter<ConfirmPaidOrderState> emit,
  ) async {
    emit(const ConfirmPaidOrderLoading());
    final result = await _repository.confirmPaidOrder(
      event.orderId,
      imagePayFromDelivery: event.imagePayFromDelivery,
    );
    result.fold(
      (failure) => emit(ConfirmPaidOrderError(failure.message)),
      (_) => emit(const ConfirmPaidOrderSuccess()),
    );
  }
}
