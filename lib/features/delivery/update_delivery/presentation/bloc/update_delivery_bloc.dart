import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/delivery/update_delivery/data/repositories/update_delivery_repository.dart';

part 'update_delivery_event.dart';
part 'update_delivery_state.dart';

class UpdateDeliveryBloc extends Bloc<UpdateDeliveryEvent, UpdateDeliveryState> {
  final UpdateDeliveryRepository _repository;

  UpdateDeliveryBloc(this._repository) : super(const UpdateDeliveryInitial()) {
    on<UpdateDeliveryEvent>((event, emit) async {
      if (event is UpdateDeliverySubmitted) {
        emit(const UpdateDeliveryLoading());
        final result = await _repository.updateDeliveryMan(
          id: event.id,
          name: event.name,
          phone: event.phone,
          email: event.email,
          vehicleType: event.vehicleType,
          status: event.status,
        );
        result.fold(
          (failure) => emit(UpdateDeliveryError(message: failure.message)),
          (_) => emit(const UpdateDeliverySuccess()),
        );
      }
    });
  }
}
