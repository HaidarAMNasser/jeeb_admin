import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/offer/update_offer/data/repositories/update_offer_repository.dart';

part 'update_offer_event.dart';
part 'update_offer_state.dart';

class UpdateOfferBloc extends Bloc<UpdateOfferEvent, UpdateOfferState> {
  final UpdateOfferRepository _repository;

  UpdateOfferBloc(this._repository) : super(const UpdateOfferInitial()) {
    on<UpdateOfferEvent>((event, emit) async {
      if (event is UpdateOfferSubmitted) {
        emit(const UpdateOfferLoading());
        final discountType = event.discountType == 'VALUE' ? 'FIXED' : event.discountType;
        final productIdsNumbers = event.productIds
            .map((id) => int.tryParse(id))
            .whereType<int>()
            .toList();
        final formData = FormData.fromMap({
          'name': event.name.trim(),
          'shortDescription': event.shortDescription,
          'longDescription': event.longDescription,
          if (event.startDate != null)
            'startDate': event.startDate!.toIso8601String(),
          if (event.endDate != null)
            'endDate': event.endDate!.toIso8601String(),
          'discountType': discountType,
          'discountValue': event.discountValue,
          'productIds': productIdsNumbers,
        });
        final result =
            await _repository.updateOffer(event.id, formData);
        result.fold(
          (failure) => emit(UpdateOfferError(message: failure.message)),
          (_) => emit(const UpdateOfferSuccess()),
        );
      }
    });
  }
}
