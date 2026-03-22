import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/data/repositories/update_merchant_repository.dart';

part 'update_merchant_event.dart';
part 'update_merchant_state.dart';

class UpdateMerchantBloc extends Bloc<UpdateMerchantEvent, UpdateMerchantState> {
  final UpdateMerchantRepository _repository;

  UpdateMerchantBloc(this._repository) : super(const UpdateMerchantInitial()) {
    on<UpdateMerchantEvent>((event, emit) async {
      if (event is UpdateMerchantSubmitted) {
        emit(const UpdateMerchantLoading());
        final result = await _repository.updateMerchant(
          id: event.id,
          firstName: event.firstName,
          lastName: event.lastName,
          phone: event.phone,
          email: event.email,
          countryId: event.countryId,
          cityId: event.cityId,
          address: event.address,
          hidePhoneNumber: event.hidePhoneNumber,
        );
        result.fold(
          (failure) => emit(UpdateMerchantError(message: failure.message)),
          (_) => emit(const UpdateMerchantSuccess()),
        );
      }
    });
  }
}
