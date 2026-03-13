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
        // Backend expects single "description" (combine short + long for API)
        final short = event.shortDescription.trim();
        final long = event.longDescription.trim();
        final description = short.isNotEmpty && long.isNotEmpty
            ? '$short\n\n$long'
            : (short.isNotEmpty ? short : long);
        final body = <String, dynamic>{
          'name': event.name.trim(),
          'description': description,
          'discountType': discountType,
          'discountValue': event.discountValue,
          'productIds': productIdsNumbers,
          'isActive': true,
        };
        if (event.startDate != null) {
          body['startDate'] = event.startDate!.toIso8601String();
        }
        if (event.endDate != null) {
          body['endDate'] = event.endDate!.toIso8601String();
        }
        final result = await _repository.updateOffer(event.id, body);
        result.fold(
          (failure) => emit(UpdateOfferError(message: failure.message)),
          (_) => emit(const UpdateOfferSuccess()),
        );
      }
    });
  }
}
