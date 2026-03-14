import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/offer/delete_offer/data/repositories/delete_offer_repository.dart';

part 'delete_offer_event.dart';
part 'delete_offer_state.dart';

class DeleteOfferBloc extends Bloc<DeleteOfferEvent, DeleteOfferState> {
  final DeleteOfferRepository _repository;

  DeleteOfferBloc(this._repository) : super(const DeleteOfferInitial()) {
    on<DeleteOfferEvent>((event, emit) async {
      if (event is DeleteOfferSubmitted) {
        emit(const DeleteOfferLoading());
        final result = await _repository.deleteOffer(event.offerId);
        result.fold(
          (failure) => emit(DeleteOfferError(message: failure.message)),
          (_) => emit(const DeleteOfferSuccess()),
        );
      }
    });
  }
}
