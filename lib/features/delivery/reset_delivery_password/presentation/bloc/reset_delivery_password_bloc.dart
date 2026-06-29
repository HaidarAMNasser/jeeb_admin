import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/delivery/reset_delivery_password/data/repositories/reset_delivery_password_repository.dart';

part 'reset_delivery_password_event.dart';
part 'reset_delivery_password_state.dart';

class ResetDeliveryPasswordBloc
    extends Bloc<ResetDeliveryPasswordEvent, ResetDeliveryPasswordState> {
  final ResetDeliveryPasswordRepository _repository;

  ResetDeliveryPasswordBloc(this._repository)
      : super(const ResetDeliveryPasswordInitial()) {
    on<ResetDeliveryPasswordSubmitted>((event, emit) async {
      emit(const ResetDeliveryPasswordLoading());
      final result = await _repository.resetDeliveryPassword(
        id: event.deliveryManId,
        password: event.password,
      );

      result.fold(
        (failure) =>
            emit(ResetDeliveryPasswordError(message: failure.message)),
        (_) => emit(const ResetDeliveryPasswordSuccess()),
      );
    });
  }
}
