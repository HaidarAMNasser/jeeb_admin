import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/data/repositories/create_delivery_repository.dart';

part 'create_delivery_event.dart';
part 'create_delivery_state.dart';

class CreateDeliveryBloc extends Bloc<CreateDeliveryEvent, CreateDeliveryState> {
  final CreateDeliveryRepository _repository;

  CreateDeliveryBloc(this._repository) : super(const CreateDeliveryInitial()) {
    on<CreateDeliveryEvent>((event, emit) async {
      if (event is CreateDeliverySubmitted) {
        emit(const CreateDeliveryLoading());
        final result = await _repository.createDeliveryMan(
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          password: event.password,
          phone: event.phone,
          countryId: event.countryId,
          cityId: event.cityId,
          address: event.address,
          birthday: event.birthday,
          notificationChannel: event.notificationChannel,
          officeOwnerId: event.officeOwnerId,
          imagePath: event.imagePath,
        );
        result.fold(
          (failure) => emit(CreateDeliveryError(message: failure.message)),
          (_) => emit(const CreateDeliverySuccess()),
        );
      }
    });
  }
}
