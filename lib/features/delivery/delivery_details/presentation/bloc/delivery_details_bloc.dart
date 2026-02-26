import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';
import 'package:jeeb_admin/features/delivery/delivery_details/data/repositories/delivery_details_repository.dart';

part 'delivery_details_event.dart';
part 'delivery_details_state.dart';

class DeliveryDetailsBloc
    extends Bloc<DeliveryDetailsEvent, DeliveryDetailsState> {
  final DeliveryDetailsRepository _repository;

  DeliveryDetailsBloc(this._repository) : super(const DeliveryDetailsInitial()) {
    on<DeliveryDetailsEvent>((event, emit) async {
      if (event is GetDeliveryManDetailsEvent) {
        emit(const DeliveryDetailsLoading());
        final result =
            await _repository.getDeliveryManDetails(event.id);
        result.fold(
          (failure) => emit(DeliveryDetailsError(message: failure.message)),
          (deliveryMan) => emit(DeliveryDetailsLoaded(deliveryMan: deliveryMan)),
        );
      }
    });
  }
}
