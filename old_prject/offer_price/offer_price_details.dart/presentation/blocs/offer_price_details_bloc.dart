import 'package:equatable/equatable.dart';
import 'package:fatoorahapp/core/services/errors_handler.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/data/repositories/offer_price_single_repositories.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'offer_price_details_event.dart';
part 'offer_price_details_state.dart';

class OfferPriceDetailsBloc
    extends Bloc<OfferPriceDetailsEvent, OfferPriceDetailsState> {
  final OfferPriceDetailsRepository _offerPriceDetailsRepository;

  OfferPriceDetailsBloc(this._offerPriceDetailsRepository)
      : super(const OfferPriceDetailsInitial()) {
    on<GetOfferPriceDetailsEvent>(_onGetOfferPriceDetails);
    on<OnDeleteOfferPriceEvent>(_onDeleteOfferPrice);
  }

  Future<void> _onGetOfferPriceDetails(GetOfferPriceDetailsEvent event,
      Emitter<OfferPriceDetailsState> emit) async {
    if (event.withLoading) {
      emit(const OfferPriceDetailsLoading());
    }
    try {
      final result = await _offerPriceDetailsRepository.getOfferPriceDetails(
          offerPriceId: event.offerPriceId);

      result.fold(
        (failure) {
          // Handle different error scenarios
          if (failure.statusCode == 404) {
            emit(const OfferPriceDetailsNotFoundState());
          } else if (failure.statusCode == -6) {
            // noInternetConnection
            emit(const OfferPriceDetailsNoInternetState());
          } else {
            emit(OfferPriceDetailsError(
              message: failure.prettyMessage ?? failure.message,
              statusCode: failure.statusCode,
            ));
          }
        },
        (offerPriceDetailsData) {
          // Check if we have data or need to show no data state
          if (offerPriceDetailsData.offerPriceDetails.isEmpty) {
            emit(const OfferPriceDetailsNoDataState());
          } else {
            emit(OfferPriceDetailsSuccess(
                offerPriceDetails: offerPriceDetailsData, withLoading: false));
          }
        },
      );
    } catch (e) {
      emit(OfferPriceDetailsError(
        message: ResponseMessage.defaultError,
        statusCode: ResponseCode.defaultError,
      ));
    }
  }

  Future<void> _onDeleteOfferPrice(OnDeleteOfferPriceEvent event,
      Emitter<OfferPriceDetailsState> emit) async {
    if (state is OfferPriceDetailsSuccess) {
      emit((state as OfferPriceDetailsSuccess)
          .copyWith(withLoading: event.isLoading));
    }
  }
}
