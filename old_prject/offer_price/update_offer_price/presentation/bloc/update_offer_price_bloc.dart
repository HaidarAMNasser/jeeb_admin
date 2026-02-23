import 'package:equatable/equatable.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/feature/offer_price/update_offer_price/data/repositories/update_offer_price_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fatoorahapp/core/services/errors_handler.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';

part 'update_offer_price_event.dart';
part 'update_offer_price_state.dart';

class OfferPriceUpdateBloc
    extends Bloc<OfferPriceUpdateEvent, OfferPriceUpdateState> {
  final OfferPriceUpdateRepository _updateRepository;

  OfferPriceUpdateBloc(this._updateRepository)
      : super(OfferPriceUpdateInitial()) {
    on<OfferPriceUpdateSubmitted>(_onOfferPriceUpdateSubmitted);
        on<ResetUpdateToInit>(_onResetUpdateToInit);
  }
  void _onResetUpdateToInit(
    ResetUpdateToInit event,
    Emitter<OfferPriceUpdateState> emit,
  ) {
    emit(OfferPriceUpdateInitial());
  }
  Future<void> _onOfferPriceUpdateSubmitted(
    OfferPriceUpdateSubmitted event,
    Emitter<OfferPriceUpdateState> emit,
  ) async {
    emit(OfferPriceUpdateLoading());
    try {
      final result = await _updateRepository.updateOfferPrice(
        offerPriceId: event.offerPriceId,
        referenceNumber: event.referenceNumber,
        userId: event.userId,
        supplyDate: event.supplyDate,
        serviceEndDate: event.serviceEndDate,
        workPalceId: event.workPalceId,
        expirationDate: event.expirationDate,
        employeeId: event.employeeId,
        payments: event.payments,
        date: event.date,
        status: event.status,
        details: event.details,
      );

      result.fold(
        (l) =>
            emit(OfferPriceUpdateError(message: l.prettyMessage ?? l.message, details: event.details, payments: event.payments)),
        (r) => emit(OfferPriceUpdateSuccess(offerPriceEntity: r)),
      );
    } catch (e) {
      emit(OfferPriceUpdateError(message: ResponseMessage.defaultError, details: event.details, payments: event.payments));
    }
  }
}
