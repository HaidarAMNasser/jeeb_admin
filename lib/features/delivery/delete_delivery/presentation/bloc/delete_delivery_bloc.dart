import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/delivery/delete_delivery/data/repositories/delete_delivery_repository.dart';

part 'delete_delivery_event.dart';
part 'delete_delivery_state.dart';

class DeleteDeliveryBloc extends Bloc<DeleteDeliveryEvent, DeleteDeliveryState> {
  final DeleteDeliveryRepository _repository;

  DeleteDeliveryBloc(this._repository) : super(const DeleteDeliveryInitial()) {
    on<DeleteDeliveryEvent>((event, emit) async {
      if (event is DeleteDeliverySubmitted) {
        emit(const DeleteDeliveryLoading());
        final result = await _repository.deleteDeliveryMan(event.deliveryManId);
        result.fold(
          (failure) => emit(DeleteDeliveryError(message: failure.message)),
          (_) => emit(const DeleteDeliverySuccess()),
        );
      }
    });
  }
}
