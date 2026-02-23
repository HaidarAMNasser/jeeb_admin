import 'package:equatable/equatable.dart';
import 'package:fatoorahapp/core/classes/entities/base_response_entity.dart';
import 'package:fatoorahapp/feature/offer_price/delete_offer_price/data/repositories/delete_offer_price_reposiroy.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/errors_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'delete_offer_price_event.dart';
part 'delete_offer_price_state.dart';
class DeleteOfferPriceBloc
    extends Bloc<DeleteOfferPriceEvent, DeleteOfferPriceState> {
  final DeleteOfferPriceRepository _deleteOfferPriceRepository;

  DeleteOfferPriceBloc(this._deleteOfferPriceRepository)
      : super(const DeleteOfferPriceInitialState()) {
    on<DeleteOfferPriceEvent>((event, emit) async {
      if (event is DeleteOfferPriceSubmitted) {
        try {
          if (event.withLoading) {
            emit(const DeleteOfferPriceLoadingState());
          }
          (await _deleteOfferPriceRepository.deleteOfferPrice(
            id: event.id,
          ))
              .fold((l) {
            emit(DeleteOfferPriceErrorState(
                message: l.prettyMessage ?? l.message));
          }, (r) {
            emit(DeleteOfferPriceSuccessState(baseResponseEntity: r));
          });
        } catch (e) {
          emit(DeleteOfferPriceErrorState(
              message: ResponseMessage.defaultError));
        }
      }
    });
  }
}
