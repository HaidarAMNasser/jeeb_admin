import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/delivery/confirm_delivery/data/repositories/confirm_delivery_repository.dart';

part 'confirm_delivery_event.dart';
part 'confirm_delivery_state.dart';

class ConfirmDeliveryBloc
    extends Bloc<ConfirmDeliveryEvent, ConfirmDeliveryState> {
  final ConfirmDeliveryRepository _repository;

  ConfirmDeliveryBloc(this._repository)
      : super(const ConfirmDeliveryInitial()) {
    on<ConfirmDeliverySubmitted>((event, emit) async {
      emit(const ConfirmDeliveryLoading());
      final result = await _repository.confirmDeliveryMan(event.deliveryManId);

      result.fold(
        (failure) => emit(ConfirmDeliveryError(message: failure.message)),
        (_) => emit(const ConfirmDeliverySuccess()),
      );
    });
  }
}

