import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/offer/create_offer/domain/entities/offer_product_line.dart';
import 'package:jeeb_admin/features/offer/update_offer/data/repositories/update_offer_repository.dart';

part 'update_offer_event.dart';
part 'update_offer_state.dart';

class UpdateOfferBloc extends Bloc<UpdateOfferEvent, UpdateOfferState> {
  final UpdateOfferRepository _repository;

  UpdateOfferBloc(this._repository) : super(const UpdateOfferInitial()) {
    on<UpdateOfferEvent>((event, emit) async {
      if (event is UpdateOfferSubmitted) {
        emit(const UpdateOfferLoading());
        final discountType =
            event.discountType == 'VALUE' ? 'FIXED' : event.discountType;
        final productsPayload = event.offerProducts
            .map((line) {
              final id = int.tryParse(line.productId);
              if (id == null) return null;
              return <String, dynamic>{
                'productId': id,
                'quantity': line.quantity,
              };
            })
            .whereType<Map<String, dynamic>>()
            .toList();
        final body = <String, dynamic>{
          'name': event.name.trim(),
          'description': event.description.trim(),
          'discountType': discountType,
          'discountValue': event.discountValue,
          'products': productsPayload,
          'isActive': true,
        };
        if (event.startDate != null) {
          body['startDate'] = event.startDate!.toIso8601String();
        }
        if (event.endDate != null) {
          body['endDate'] = event.endDate!.toIso8601String();
        }
        final removedIds = event.initialOfferProductIds
            .where(
              (id) => !event.offerProducts.any((p) => p.productId == id),
            )
            .map((id) => int.tryParse(id))
            .whereType<int>()
            .toList();
        if (removedIds.isNotEmpty) {
          body['removeProductIds'] = removedIds;
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
