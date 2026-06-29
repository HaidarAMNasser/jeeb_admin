import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/merchant/create_merchant/data/repositories/create_merchant_repository.dart';

part 'create_merchant_event.dart';
part 'create_merchant_state.dart';

class CreateMerchantBloc extends Bloc<CreateMerchantEvent, CreateMerchantState> {
  final CreateMerchantRepository _repository;

  CreateMerchantBloc(this._repository) : super(const CreateMerchantInitial()) {
    on<CreateMerchantEvent>((event, emit) async {
      if (event is CreateMerchantSubmitted) {
        emit(const CreateMerchantLoading());
        final result = await _repository.createMerchant(
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          password: event.password,
          phone: event.phone,
          countryId: event.countryId,
          cityId: event.cityId,
          areaId: event.areaId,
          restaurantName: event.restaurantName,
          merchantType: event.merchantType,
          latitude: event.latitude,
          longitude: event.longitude,
          address: event.address,
          notificationChannel: event.notificationChannel,
        );
        result.fold(
          (failure) => emit(CreateMerchantError(message: failure.message)),
          (_) => emit(const CreateMerchantSuccess()),
        );
      }
    });
  }
}
